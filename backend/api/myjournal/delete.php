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

$id = $_POST['id'] ?? '';

// Validasi ID
if (empty($id) || !is_numeric($id)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid journal ID'
    ]);
    exit;
}

// Escape untuk mencegah SQL Injection
$id = mysqli_real_escape_string($conn, $id);

// Gunakan prepared statement atau escape
$query = "DELETE FROM myjournal WHERE id = '$id'";
$result = mysqli_query($conn, $query);

if ($result && mysqli_affected_rows($conn) > 0) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Journal deleted successfully'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to delete journal or journal not found'
    ]);
}

mysqli_close($conn);
