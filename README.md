# Dockerized Shadowsocks Client
# Docker 化的 Shadowsocks 客户端

[English](#english-section) | [中文](#chinese-section)

## English Section

A Docker containerized Shadowsocks client with PAC (Proxy Auto-Configuration) support and automatic updates.

### Project Structure
```
dockerized-ss/
├── config/                # Configuration directory
│   ├── config.json        # Shadowsocks configuration file
│   ├── config.json.example # Example configuration file
│   ├── gfwlist.user.txt   # Custom PAC rules
│   └── supervisord.conf   # Supervisor configuration
├── scripts/              # Scripts directory
│   ├── generate_pac.sh    # PAC file generation script
│   └── update_pac_cron.sh # PAC update cron script
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### Features
- Shadowsocks client with SOCKS5 proxy
- PAC file generation and auto-update
- Customizable configuration through external config file
- Automatic PAC updates every 6 hours
- Supervisor for process management

### Prerequisites
- Docker
- Docker Compose
- A Shadowsocks server

### Quick Start

1. Clone this repository:
```bash
git clone <repository-url>
cd dockerized-ss
```

2. Create your configuration files:
   - Copy `config/config.json.example` to `config/config.json` and edit it:
```json
{
    "server": "your-server-ip",
    "server_port": your-server-port,
    "local_address": "0.0.0.0",
    "local_port": 1080,
    "password": "your-password",
    "timeout": 300,
    "method": "aes-256-gcm"
}
```
   - (Optional) Edit `config/gfwlist.user.txt` to add custom PAC rules

3. Start the container:
```bash
docker-compose up -d
```

### Ports
- `1080`: SOCKS5 proxy port
- `8080`: PAC file HTTP server

### Configuration
- Main configuration file: `config/config.json`
- Custom PAC rules: `config/gfwlist.user.txt`
- You can modify these files at any time without rebuilding the container

### PAC File
- The PAC file is automatically generated and updated every 6 hours
- Access the PAC file at `http://localhost:8080/pac`
- Custom rules can be added to `config/gfwlist.user.txt`

### Logs
View container logs:
```bash
docker logs -f ssclient
```

### Stop the Container
```bash
docker-compose down
```

## Chinese Section

一个支持 PAC（代理自动配置）和自动更新的 Docker 容器化 Shadowsocks 客户端。

### 项目结构
```
dockerized-ss/
├── config/                # 配置文件目录
│   ├── config.json        # Shadowsocks 配置文件
│   ├── config.json.example # 示例配置文件
│   ├── gfwlist.user.txt   # 自定义 PAC 规则
│   └── supervisord.conf   # Supervisor 配置文件
├── scripts/              # 脚本目录
│   ├── generate_pac.sh    # PAC 文件生成脚本
│   └── update_pac_cron.sh # PAC 更新定时脚本
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### 特性
- 支持 SOCKS5 代理的 Shadowsocks 客户端
- PAC 文件生成和自动更新
- 通过外部配置文件实现配置自定义
- 每 6 小时自动更新 PAC
- 使用 Supervisor 进行进程管理

### 前置要求
- Docker
- Docker Compose
- Shadowsocks 服务器

### 快速开始

1. 克隆仓库：
```bash
git clone <repository-url>
cd dockerized-ss
```

2. 创建配置文件：
   - 复制 `config/config.json.example` 到 `config/config.json` 并编辑：
```json
{
    "server": "你的服务器IP",
    "server_port": 你的服务器端口,
    "local_address": "0.0.0.0",
    "local_port": 1080,
    "password": "你的密码",
    "timeout": 300,
    "method": "aes-256-gcm"
}
```
   - （可选）编辑 `config/gfwlist.user.txt` 添加自定义 PAC 规则

3. 启动容器：
```bash
docker-compose up -d
```

### 端口说明
- `1080`: SOCKS5 代理端口
- `8080`: PAC 文件 HTTP 服务器端口

### 配置说明
- 主配置文件：`config/config.json`
- 自定义 PAC 规则：`config/gfwlist.user.txt`
- 你可以随时修改这些文件，无需重新构建容器

### PAC 文件
- PAC 文件每 6 小时自动生成和更新一次
- 通过 `http://localhost:8080/pac` 访问 PAC 文件
- 可以在 `config/gfwlist.user.txt` 中添加自定义规则

### 日志查看
查看容器日志：
```bash
docker logs -f ssclient
```

### 停止容器
```bash
docker-compose down
```

## License
Apache License 2.0