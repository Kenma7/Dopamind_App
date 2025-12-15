<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// PERBAIKAN PATH
require_once __DIR__ . '/../../conn.php';

// Validasi koneksi
if (!isset($conn) || !$conn) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed'
    ]);
    exit;
}

$id = $_POST['id'] ?? 0;
$content = $_POST['content'] ?? '';
$type = $_POST['type'] ?? 'reflection';
$mood = $_POST['mood'] ?? '';

// Validasi
if (empty($id) || !is_numeric($id)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Valid ID is required'
    ]);
    exit;
}

if (empty(trim($content))) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Content is required'
    ]);
    exit;
}

// Escape untuk keamanan
$content = mysqli_real_escape_string($conn, $content);
$type = mysqli_real_escape_string($conn, $type);
$mood = mysqli_real_escape_string($conn, $mood);
$id = mysqli_real_escape_string($conn, $id);

// Update database
$sql = "UPDATE myjournal SET content = '$content', type = '$type', mood = '$mood' WHERE id = '$id'";

if (mysqli_query($conn, $sql)) {
    if (mysqli_affected_rows($conn) > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Journal updated successfully'
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Journal not found or no changes made'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to update journal: ' . mysqli_error($conn)
    ]);
}

mysqli_close($conn);
