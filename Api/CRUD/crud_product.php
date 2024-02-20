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
            // ดึงข้อมูลสินค้าทั้งหมด
            $sql = "SELECT `codeProduct`,`codeStore`,`codeStore`,`nameProduct`,`count_unit`,`price`,stores.nameStore
            FROM products
            JOIN stores USING(codeStore);";
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
                $response['message'] = "Failed to fetch product data: " . mysqli_error($conn);
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

            // Debugging: Output the received data to the error log
            error_log(print_r($data, true));

            // Check if the required fields are present in the input data
            if (isset($data['codeStore']) && isset($data['nameProduct']) && isset($data['count_unit']) && isset($data['price'])) {
                // ทำความสะอาดและรับข้อมูล input
                $codeStore = sanitize_input($data['codeStore']);
                $nameProduct = sanitize_input($data['nameProduct']);
                $count_unit = sanitize_input($data['count_unit']);
                $price = intval($data['price']);

                // Get the latest codeProduct value from the database
                $result = mysqli_query($conn, "SELECT MAX(codeProduct) AS maxCode FROM products");
                $row = mysqli_fetch_assoc($result);
                $maxCode = $row['maxCode'];
                // Increment the codeProduct by 1
                $codeProduct = $maxCode + 1;

                // Insert new product data
                $sql = "INSERT INTO products (codeProduct, codeStore, nameProduct, count_unit, price) VALUES ('$codeProduct', '$codeStore', '$nameProduct', '$count_unit', $price)";

                if (mysqli_query($conn, $sql)) {
                    $response['status'] = 200;
                    $response['message'] = "Product data added successfully";
                } else {
                    $response['status'] = 500;
                    $response['message'] = "Failed to add product data: " . mysqli_error($conn);
                }
            } else {
                $response['status'] = 400;
                $response['message'] = "Invalid request. Required fields are missing in the input data.";
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
            $codeProduct = sanitize_input($data['codeProduct']);
            $nameProduct = sanitize_input($data['nameProduct']);
            $count_unit = sanitize_input($data['count_unit']);
            $price = intval($data['price']);

            // อัปเดตข้อมูลสินค้า
            $sql = "UPDATE products SET codeStore='$codeStore', nameProduct='$nameProduct', count_unit='$count_unit', price=$price WHERE codeProduct='$codeProduct'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Product data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update product data: " . mysqli_error($conn);
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
            $codeProduct = sanitize_input($data['codeProduct']);

            // ลบข้อมูลสินค้า
            $sql = "DELETE FROM products WHERE codeProduct='$codeProduct'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Product data deleted successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to delete product data: " . mysqli_error($conn);
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
