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

// Get POST data
$content = $_POST['content'] ?? '';
$type = $_POST['type'] ?? 'reflection';
$mood = $_POST['mood'] ?? '';

// Validasi
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

// Insert ke database
$sql = "INSERT INTO myjournal (content, type, mood) VALUES ('$content', '$type', '$mood')";

if (mysqli_query($conn, $sql)) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Journal created successfully',
        'id' => mysqli_insert_id($conn)
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to create journal: ' . mysqli_error($conn)
    ]);
}

mysqli_close($conn);
