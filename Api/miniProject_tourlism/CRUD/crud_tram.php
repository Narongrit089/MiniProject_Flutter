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
            // ดึงข้อมูลรถรางทั้งหมด
            $sql = "SELECT * FROM tram_data";
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
                $response['message'] = "Failed to fetch tram data: " . mysqli_error($conn);
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
            $car_num = sanitize_input($data['car_num']);

            // ดึงข้อมูลรหัสรถรางทั้งหมดและหาค่าที่มากที่สุด
            $sql_max_tram_code = "SELECT MAX(tram_code) AS max_tram_code FROM tram_data";
            $result_max_tram_code = mysqli_query($conn, $sql_max_tram_code);
            $row_max_tram_code = mysqli_fetch_assoc($result_max_tram_code);
            $max_tram_code = $row_max_tram_code['max_tram_code'];

            // เพิ่มค่ารหัสรถรางใหม่
            $new_tram_code = $max_tram_code + 1;

            // เพิ่มข้อมูลรถรางใหม่
            $sql = "INSERT INTO tram_data (tram_code, car_num) VALUES ('$new_tram_code', '$car_num')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Tram data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add tram data: " . mysqli_error($conn);
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
            $tram_code = sanitize_input($data['tram_code']);
            $car_num = sanitize_input($data['car_num']);

            // อัปเดตข้อมูลรถราง
            $sql = "UPDATE tram_data SET car_num='$car_num' WHERE tram_code='$tram_code'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Tram data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update tram data: " . mysqli_error($conn);
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
            $tram_code = sanitize_input($data['tram_code']);

            // ลบข้อมูลรถราง
            $sql = "DELETE FROM tram_data WHERE tram_code='$tram_code'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Tram data deleted successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to delete tram data: " . mysqli_error($conn);
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
