<?php
error_reporting(0);
ini_set('display_errors', 0);

// Database configuration
$host = "localhost";
$user = "root";
$pass = "";
$db   = "dopamind_db";

// Create connection
$conn = mysqli_connect($host, $user, $pass, $db);
