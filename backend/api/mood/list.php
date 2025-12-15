<?php
include '../../conn.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

$month = $_GET['month'] ?? date('Y-m');

// Validasi bulan format
if (!preg_match('/^\d{4}-\d{2}$/', $month)) {
    $month = date('Y-m');
}

$year = substr($month, 0, 4);
$monthNum = substr($month, 5, 2);

// Ambil semua mood untuk bulan tertentu
$query = "SELECT id, mood, note, created_date, created_at 
          FROM mood_entries 
          WHERE YEAR(created_date) = ? AND MONTH(created_date) = ?
          ORDER BY created_date DESC";

$stmt = mysqli_prepare($conn, $query);
mysqli_stmt_bind_param($stmt, "ii", $year, $monthNum);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$moods = [];
while ($row = mysqli_fetch_assoc($result)) {
    $moods[] = [
        'id' => (int)$row['id'],
        'mood' => $row['mood'],
        'note' => $row['note'],
        'date' => $row['created_date'],
        'created_at' => $row['created_at']
    ];
}

echo json_encode([
    'status' => 'success',
    'month' => $month,
    'data' => $moods
]);

mysqli_close($conn);
