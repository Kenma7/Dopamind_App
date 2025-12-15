<?php
// api/mood/stats.php - UPDATE
include '../../conn.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

$month = $_GET['month'] ?? date('Y-m');

// Hitung statistik
$statsQuery = "SELECT 
    COUNT(*) as total_entries,
    AVG(CASE 
        WHEN mood = 'Sangat Baik' THEN 4
        WHEN mood = 'Baik' THEN 3
        WHEN mood = 'Biasa' THEN 2
        WHEN mood = 'Buruk' THEN 1
        ELSE 2
    END) as average_score
    FROM mood_entries 
    WHERE DATE_FORMAT(created_date, '%Y-%m') = ?";

$stmt = mysqli_prepare($conn, $statsQuery);
mysqli_stmt_bind_param($stmt, "s", $month);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$stats = mysqli_fetch_assoc($result);

// Hitung distribusi mood - PASTIKAN RETURN INTEGER
$distQuery = "SELECT 
    COALESCE(SUM(CASE WHEN mood = 'Sangat Baik' THEN 1 ELSE 0 END), 0) as sangat_baik,
    COALESCE(SUM(CASE WHEN mood = 'Baik' THEN 1 ELSE 0 END), 0) as baik,
    COALESCE(SUM(CASE WHEN mood = 'Biasa' THEN 1 ELSE 0 END), 0) as biasa,
    COALESCE(SUM(CASE WHEN mood = 'Buruk' THEN 1 ELSE 0 END), 0) as buruk
    FROM mood_entries 
    WHERE DATE_FORMAT(created_date, '%Y-%m') = ?";

$stmt2 = mysqli_prepare($conn, $distQuery);
mysqli_stmt_bind_param($stmt2, "s", $month);
mysqli_stmt_execute($stmt2);
$result2 = mysqli_stmt_get_result($stmt2);
$distribution = mysqli_fetch_assoc($result2);

// Convert ke integer
$distribution = array_map('intval', $distribution);

// Mood paling sering
$commonQuery = "SELECT mood, COUNT(*) as count 
               FROM mood_entries 
               WHERE DATE_FORMAT(created_date, '%Y-%m') = ?
               GROUP BY mood 
               ORDER BY count DESC 
               LIMIT 1";

$stmt3 = mysqli_prepare($conn, $commonQuery);
mysqli_stmt_bind_param($stmt3, "s", $month);
mysqli_stmt_execute($stmt3);
$result3 = mysqli_stmt_get_result($stmt3);
$common = mysqli_fetch_assoc($result3);

// Convert score to mood label
$score = $stats['average_score'] ?? 2;
if ($score >= 3.5) {
    $averageMood = 'Sangat Baik';
} elseif ($score >= 2.5) {
    $averageMood = 'Baik';
} elseif ($score >= 1.5) {
    $averageMood = 'Biasa';
} else {
    $averageMood = 'Buruk';
}

echo json_encode([
    'status' => 'success',
    'stats' => [
        'total_entries' => (int)($stats['total_entries'] ?? 0),
        'average_mood' => $averageMood,
        'average_score' => round((float)$score, 1),
        'most_common_mood' => $common['mood'] ?? 'Biasa',
        'most_common_count' => (int)($common['count'] ?? 0),
        'distribution' => $distribution
    ]
]);

mysqli_close($conn);
