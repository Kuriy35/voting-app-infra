#!/bin/bash
yum update -y
yum install -y docker git

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user


cd /home/ec2-user

git clone https://github.com/Kuriy35/example-voting-app.git
cd example-voting-app/vote/

docker build -t vote-app:latest .

docker run -d \
  --name vote \
  -p 80:80 \
  -e REDIS_HOST="${redis_private_ip}"\
  --restart always \
  vote-app:latest

chown -R ec2-user:ec2-user /home/ec2-user/example-voting-app