<?php
include '../../conn.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$data = json_decode(file_get_contents('php://input'), true) ?: $_POST;
$mood = $data['mood'] ?? '';
$note = $data['note'] ?? '';
$date = $data['date'] ?? date('Y-m-d');

// Validasi
$allowedMoods = ['Buruk', 'Biasa', 'Baik', 'Sangat Baik'];
if (!in_array($mood, $allowedMoods)) {
    echo json_encode(['status' => 'error', 'message' => 'Mood tidak valid']);
    exit();
}

// Cek apakah sudah ada entry untuk tanggal ini
$checkQuery = "SELECT id FROM mood_entries WHERE created_date = ?";
$stmt = mysqli_prepare($conn, $checkQuery);
mysqli_stmt_bind_param($stmt, "s", $date);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if (mysqli_num_rows($result) > 0) {
    // Update mood yang sudah ada
    $row = mysqli_fetch_assoc($result);
    $id = $row['id'];
    $query = "UPDATE mood_entries SET mood = ?, note = ? WHERE id = ?";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "ssi", $mood, $note, $id);
} else {
    // Insert baru
    $query = "INSERT INTO mood_entries (mood, note, created_date) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "sss", $mood, $note, $date);
}

if (mysqli_stmt_execute($stmt)) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Mood berhasil disimpan',
        'date' => $date
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Gagal menyimpan']);
}

mysqli_close($conn);
