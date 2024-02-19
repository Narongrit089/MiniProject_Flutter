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
            // ดึงข้อมูลเส้นทางรถบัสทั้งหมด
            $sql = "SELECT `route_no`,`codeLo`,`route_time`,locations.nameLo
            FROM bus_route
            JOIN locations USING(codeLo);";
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
                $response['message'] = "Failed to fetch bus route data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // ตรวจสอบว่าเป็นการร้องขอแบบ POST
        if ($request_method == 'POST') {
            // ดึงข้อมูลล่าสุดของ route_no จากฐานข้อมูล
            $sql_latest_route_no = "SELECT MAX(route_no) AS max_route_no FROM bus_route";
            $result_latest_route_no = mysqli_query($conn, $sql_latest_route_no);

            if ($result_latest_route_no) {
                $row_latest_route_no = mysqli_fetch_assoc($result_latest_route_no);
                $latest_route_no = $row_latest_route_no['max_route_no'];

                // เพิ่มค่าของ route_no ใหม่โดยบวกไปอีก 1
                $new_route_no = $latest_route_no + 1;

                // แปลงข้อมูลจาก JSON เป็น array
                $data = json_decode(file_get_contents("php://input"), true);

                // ทำความสะอาดและรับข้อมูล input
                $codeLo = sanitize_input($data['codeLo']);
                $route_time = sanitize_input($data['route_time']);

                // เพิ่มข้อมูลเส้นทางรถบัสใหม่
                $sql = "INSERT INTO bus_route (route_no, codeLo, route_time) VALUES ('$new_route_no', '$codeLo', '$route_time')";

                if (mysqli_query($conn, $sql)) {
                    $response['status'] = 201;
                    $response['message'] = "Bus route data added successfully";
                } else {
                    $response['status'] = 500;
                    $response['message'] = "Failed to add bus route data: " . mysqli_error($conn);
                }
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to fetch latest route_no: " . mysqli_error($conn);
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
            $route_no = sanitize_input($data['route_no']);
            $codeLo = sanitize_input($data['codeLo']);
            $route_time = sanitize_input($data['route_time']);

            // อัปเดตข้อมูลเส้นทางรถบัส
            $sql = "UPDATE bus_route SET codeLo='$codeLo', route_time='$route_time' WHERE route_no='$route_no'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Bus route data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update bus route data: " . mysqli_error($conn);
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
            $route_no = sanitize_input($data['route_no']);

            // ลบข้อมูลเส้นทางรถบัส
            $sql = "DELETE FROM bus_route WHERE route_no='$route_no'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Bus route data deleted successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to delete bus route data: " . mysqli_error($conn);
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
