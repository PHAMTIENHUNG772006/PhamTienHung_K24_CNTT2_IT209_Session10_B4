# Báo cáo Bài tập: Thiết lập Custom Network & Named Volume bằng Docker CLI

## 1. Giới thiệu (Overview)
Bài tập này thực hiện việc kết nối cụm 2 container gồm **Backend Web API** và **PostgreSQL Database** thông qua các công cụ thủ công của Docker CLI. Nội dung tập trung vào hai yếu tố cốt lõi:
* **Custom Bridge Network (`app-net`):** Cho phép các container trong cùng một mạng có thể giao tiếp nội bộ với nhau bằng **Container Name** nhờ cơ chế Embedded DNS tích hợp sẵn của Docker.
* **Named Volume (`db-data`):** Đảm bảo tính bền vững cho dữ liệu cơ sở dữ liệu, không bị mất mát ngay cả khi container database bị xóa bỏ hoàn toàn (`docker rm -f`).

---

## 2. Quy trình thực hiện (Implementation steps)
Các thao tác được tự động hóa thông qua tệp script `commands.sh`:
1. Tạo Custom Bridge Network tên `app-net`.
2. Tạo Named Volume tên `db-data`.
3. Khởi chạy container PostgreSQL (`postgres:15-alpine`) gắn vào `app-net` và mount volume `db-data`.
4. Khởi chạy container Backend (`alpine:latest`) tham gia vào `app-net` để thực hiện kiểm tra phân giải tên miền (DNS).

---

## 3. Kiểm tra và Kết quả (Verification)

### 3.1. Kiểm tra Network và DNS Resolution
Chạy các lệnh kiểm tra hệ thống:
```bash
docker network ls | grep app-net
docker volume ls | grep db-data
docker network inspect app-net
docker exec -it app-container ping -c 2 db-server