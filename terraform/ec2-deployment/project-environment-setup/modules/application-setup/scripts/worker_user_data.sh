#!/bin/bash
yum update -y
yum install -y docker git

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

cd /home/ec2-user

git clone https://github.com/Kuriy35/example-voting-app.git
cd example-voting-app/worker/

docker build -t worker-app:latest .

docker run -d \
  --name worker \
  -e REDIS_HOST="${redis_private_ip}" \
  -e DB_HOST="${db_hostname}" \
  -e DB_USERNAME="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  -e DB_NAME="${db_name}" \
  --restart always \
  worker-app:latest

chown -R ec2-user:ec2-user /home/ec2-user/example-voting-app