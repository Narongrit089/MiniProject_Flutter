<?php
include '../conn.php'; // ตรวจสอบว่า 'conn.php' มีโค้ดเชื่อมต่อฐานข้อมูลอยู่

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// ฟังก์ชันสำหรับทำความสะอาดและตรวจสอบข้อมูล input
function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();

// ใช้ $_SERVER['REQUEST_METHOD'] เพื่อรับวิธีการร้องขอ
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        // ตรวจสอบว่าเป็นการร้องขอแบบ GET
        if ($request_method == 'GET') {
            // ดึงข้อมูลร้านทั้งหมด
            $sql = "SELECT * FROM stores";
            $result = mysqli_query($conn, $sql);

            if ($result) {
                $rows = array();
                while ($row = mysqli_fetch_assoc($result)) {
                    $rows[] = $row;
                }
                $response['status'] = 200;
                $response['data'] = $rows;
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to fetch store data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // ตรวจสอบว่าเป็นการร้องขอแบบ POST
        if ($request_method == 'POST') {
            // แปลงข้อมูลจาก JSON เป็น array
            $data = json_decode(file_get_contents("php://input"), true);

            // ทำความสะอาดและรับข้อมูล input
            $nameStore = sanitize_input($data['nameStore']);

            // เพิ่มข้อมูลร้านใหม่
            $sql_max_id = "SELECT MAX(codeStore) AS max_id FROM stores";
            $result_max_id = mysqli_query($conn, $sql_max_id);
            $row_max_id = mysqli_fetch_assoc($result_max_id);
            $next_id = $row_max_id['max_id'] + 1;

            $sql = "INSERT INTO stores (codeStore, nameStore) VALUES ('$next_id', '$nameStore')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Store data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add store data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'PUT':
        // ตรวจสอบว่าเป็นการร้องขอแบบ PUT
        if ($request_method == 'PUT') {
            // แปลงข้อมูลจาก JSON เป็น array
            $data = json_decode(file_get_contents("php://input"), true);

            // ทำความสะอาดและรับข้อมูล input
            $codeStore = sanitize_input($data['codeStore']);
            $nameStore = sanitize_input($data['nameStore']);

            // อัปเดตข้อมูลร้าน
            $sql = "UPDATE stores SET nameStore='$nameStore' WHERE codeStore='$codeStore'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Store data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update store data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'DELETE':
        // ตรวจสอบว่าเป็นการร้องขอแบบ DELETE
        if ($request_method == 'DELETE') {
            // แปลงข้อมูลจาก JSON เป็น array
            $data = json_decode(file_get_contents("php://input"), true);

            // ทำความสะอาดและรับข้อมูล input
            $codeStore = sanitize_input($data['codeStore']);

            // ลบข้อมูลร้าน
            $sql = "DELETE FROM stores WHERE codeStore='$codeStore'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Store data deleted successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to delete store data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
