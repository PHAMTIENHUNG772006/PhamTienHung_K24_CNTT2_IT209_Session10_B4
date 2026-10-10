#!/bin/bash

# ==============================================================================
# Bài 4: Thiết lập Custom Network & Named Volume bằng Docker CLI
# ==============================================================================

echo "=== Bước 1: Tạo Custom Bridge Network (app-net) ==="
docker network create app-net

echo "=== Bước 2: Tạo Named Volume lưu trữ dữ liệu bền vững (db-data) ==="
docker volume create db-data

echo "=== Bước 3: Khởi chạy PostgreSQL Database Container (db-server) ==="
docker run -d \
  --name db-server \
  --network app-net \
  -v db-data:/var/lib/postgresql/data \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=secretpassword \
  -e POSTGRES_DB=appdb \
  postgres:15-alpine

echo "=== Bước 4: Khởi chạy Backend Web API Container (app-container) ==="
# Sử dụng một image Alpine nhẹ làm giả lập Backend để test kết nối và DNS
docker run -d \
  --name app-container \
  --network app-net \
  -e DB_HOST=db-server \
  -e DB_PORT=5432 \
  alpine:latest \
  sh -c "tail -f /dev/null"

echo "=== Bước 5: Kiểm tra cấu hình Network và DNS Resolution ==="
echo "Kiểm tra danh sách Network:"
docker network ls | grep app-net

echo "Kiểm tra danh sách Volume:"
docker volume ls | grep db-data

echo "Kiểm tra chi tiết Embedded DNS trong app-net:"
docker network inspect app-net

echo "Kiểm tra lệnh ping từ app-container tới db-server (DNS Resolution):"
docker exec -it app-container ping -c 2 db-server

echo "=== Hoàn thành thiết lập Bài 4! ==="