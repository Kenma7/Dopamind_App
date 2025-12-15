<?php
// api/myjournal/list.php - FINAL WORKING VERSION
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

// Include connection - PAKAI PATH YANG SUDAH TERBUKTI BERHASIL
require_once __DIR__ . '/../../conn.php';

// Pastikan koneksi ada
if (!isset($conn) || !$conn) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection not established'
    ]);
    exit();
}

// Query database
$sql = "SELECT id, content, type, mood, created_at FROM myjournal ORDER BY created_at DESC";
$result = mysqli_query($conn, $sql);

if (!$result) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Query failed: ' . mysqli_error($conn)
    ]);
    exit();
}

// Fetch data
$journals = [];
while ($row = mysqli_fetch_assoc($result)) {
    $journals[] = [
        'id' => (int)$row['id'],
        'content' => $row['content'] ?? '',
        'type' => $row['type'] ?? 'reflection',
        'mood' => $row['mood'] ?? '',
        'created_at' => $row['created_at'] ?? date('Y-m-d H:i:s')
    ];
}

// Success response
echo json_encode([
    'status' => 'success',
    'data' => $journals,
    'count' => count($journals)
]);

// Close connection
mysqli_close($conn);
