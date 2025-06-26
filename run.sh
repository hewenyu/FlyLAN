#!/bin/bash
set -e

# 1. 安装依赖
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# 2. 添加 Docker GPG 密钥
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 3. 添加 Docker 软件源
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

# 4. 安装 Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. 创建 runner 用户（如果不存在）
id -u runner &>/dev/null || adduser --disabled-password --gecos "" runner

# 6. 将 runner 用户加入 docker 组
usermod -aG docker runner

# 7. 启动并设置 Docker 开机自启
systemctl enable docker
systemctl start docker

echo "Docker 已安装并启动。"
echo "用户 runner 已创建并加入 docker 组。"
echo "请以 runner 用户登录后测试 docker 访问权限，例如："
echo "    su - runner"
echo "    docker info"