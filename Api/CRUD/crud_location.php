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
            // ดึงข้อมูลสถานที่ทั้งหมด
            $sql = "SELECT * FROM locations";
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
                $response['message'] = "Failed to fetch location data: " . mysqli_error($conn);
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
            $nameLo = sanitize_input($data['nameLo']);
            $latitude = sanitize_input($data['latitude']);
            $longitude = sanitize_input($data['longitude']);

            // ดึงข้อมูลรหัสสถานที่ล่าสุดและเพิ่มไปอีก 1
            $sql_max_codeLo = "SELECT MAX(codeLo) AS max_codeLo FROM locations";
            $result_max_codeLo = mysqli_query($conn, $sql_max_codeLo);
            $row_max_codeLo = mysqli_fetch_assoc($result_max_codeLo);
            $max_codeLo = $row_max_codeLo['max_codeLo'];

            // เพิ่มค่ารหัสสถานที่ใหม่
            $new_codeLo = $max_codeLo + 1;

            // เพิ่มข้อมูลสถานที่ใหม่
            $sql = "INSERT INTO locations (codeLo, nameLo, latitude, longitude) VALUES ('$new_codeLo', '$nameLo', '$latitude', '$longitude')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Location data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add location data: " . mysqli_error($conn);
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
            $codeLo = sanitize_input($data['codeLo']);
            $nameLo = sanitize_input($data['nameLo']);
            $latitude = floatval($data['latitude']);
            $longitude = floatval($data['longitude']);

            // อัปเดตข้อมูลสถานที่
            $sql = "UPDATE locations SET nameLo='$nameLo', latitude=$latitude, longitude=$longitude WHERE codeLo='$codeLo'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Location data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update location data: " . mysqli_error($conn);
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
            $codeLo = sanitize_input($data['codeLo']);

            // ลบข้อมูลสถานที่
            $sql = "DELETE FROM locations WHERE codeLo='$codeLo'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Location data deleted successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to delete location data: " . mysqli_error($conn);
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
