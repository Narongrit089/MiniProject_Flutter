<?php


header('Access-Control-Allow-Origin: *');
include "./conn.php";

// คำสั่ง SQL เพื่อดึงข้อมูลผู้ใช้ทั้งหมด
$sql = "SELECT * FROM users";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // สร้างตัวแปรสำหรับเก็บข้อมูลผู้ใช้ทั้งหมด
  $users = array();

  // เก็บข้อมูลผู้ใช้ในตัวแปร $users
  while($row = $result->fetch_assoc()) {
    $users[] = $row;
  }

  // แสดงข้อมูลผู้ใช้เป็น JSON
  echo json_encode($users);
} else {
  echo "0 results";
}

// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();

?>
