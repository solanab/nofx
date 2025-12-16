# NOFX 快速开始

本节包含了启动和运行 NOFX 所需的所有文档。

---

## 快速开始

### 一键安装（推荐）

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
```

就这样！在浏览器中打开 **http://127.0.0.1:3000**。

### Docker Compose（手动）

```bash
# 下载并启动
curl -O https://raw.githubusercontent.com/NoFxAiOS/nofx/main/docker-compose.prod.yml
docker compose -f docker-compose.prod.yml up -d
```

访问 Web 界面：**http://127.0.0.1:3000**

```bash
# 管理命令
docker compose -f docker-compose.prod.yml logs -f    # 查看日志
docker compose -f docker-compose.prod.yml restart    # 重启
docker compose -f docker-compose.prod.yml down       # 停止
docker compose -f docker-compose.prod.yml pull && docker compose -f docker-compose.prod.yml up -d  # 更新
```

### 手动安装（开发者）

#### 前置条件

- **Go 1.21+**
- **Node.js 18+**
- **TA-Lib**（技术指标库）

```bash
# 安装 TA-Lib
# macOS
brew install ta-lib

# Ubuntu/Debian
sudo apt-get install libta-lib0-dev
```

#### 安装步骤

```bash
# 1. 克隆仓库
git clone https://github.com/NoFxAiOS/nofx.git
cd nofx

# 2. 安装后端依赖
go mod download

# 3. 安装前端依赖
cd web
npm install
cd ..

# 4. 构建并启动后端
go build -o nofx
./nofx

# 5. 启动前端（新终端）
cd web
npm run dev
```

访问 Web 界面：**http://127.0.0.1:3000**

---

## Windows 安装

### 方法 1: Docker Desktop（推荐）

1. **安装 Docker Desktop**
    - 从 [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) 下载
    - 运行安装程序并重启电脑
    - 启动 Docker Desktop 并等待就绪

2. **运行 NOFX**
   ```powershell
   # 打开 PowerShell 并运行：
   curl -o docker-compose.prod.yml https://raw.githubusercontent.com/NoFxAiOS/nofx/main/docker-compose.prod.yml
   docker compose -f docker-compose.prod.yml up -d
   ```

3. **访问**: 在浏览器中打开 **http://127.0.0.1:3000**

### 方法 2: WSL2（开发用）

1. **安装 WSL2**
   ```powershell
   # 以管理员身份打开 PowerShell
   wsl --install
   ```
   安装后重启电脑。

2. **从 Microsoft Store 安装 Ubuntu**
    - 打开 Microsoft Store
    - 搜索 "Ubuntu 22.04" 并安装
    - 启动 Ubuntu 并设置用户名/密码

3. **在 WSL2 中安装依赖**
   ```bash
   # 更新系统
   sudo apt update && sudo apt upgrade -y

   # 安装 Go
   wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
   sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
   echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
   source ~/.bashrc

   # 安装 Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # 安装 TA-Lib
   sudo apt-get install -y libta-lib0-dev

   # 安装 Git
   sudo apt-get install -y git
   ```

4. **克隆并运行 NOFX**
   ```bash
   git clone https://github.com/NoFxAiOS/nofx.git
   cd nofx

   # 构建并运行后端
   go build -o nofx && ./nofx

   # 在另一个终端运行前端
   cd web && npm install && npm run dev
   ```

5. **访问**: 在 Windows 浏览器中打开 **http://127.0.0.1:3000**

### 方法 3: WSL2 中的 Docker（两全其美）

1. **安装带 WSL2 后端的 Docker Desktop**
    - 在 Docker Desktop 安装过程中，启用 "Use WSL 2 based engine"
    - 在 Docker Desktop 设置 → 资源 → WSL 集成中，启用你的 Linux 发行版

2. **从 WSL2 终端运行**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
   ```

---

## 服务器部署

### 快速部署（HTTP 通过 IP）

默认情况下，传输加密是 **禁用** 的，允许你通过 IP 地址访问 NOFX 而无需 HTTPS：

```bash
# 部署到你的服务器
curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
```

通过 `http://YOUR_SERVER_IP:3000` 访问 - 立即可用。

### 增强安全性（HTTPS）

为了增强安全性，在 `.env` 中启用传输加密：

```bash
TRANSPORT_ENCRYPTION=true
```

启用后，浏览器使用 Web Crypto API 在传输前加密 API 密钥。这需要：

- `https://` - 任何带 SSL 的域名
- `http://localhost` - 本地开发

### 使用 Cloudflare 快速设置 HTTPS

1. **将你的域名添加到 Cloudflare**（免费计划可用）
    - 前往 [dash.cloudflare.com](https://dash.cloudflare.com)
    - 添加你的域名并更新 nameservers

2. **创建 DNS 记录**
    - 类型：`A`
    - 名称：`nofx`（或你的子域名）
    - 内容：你的服务器 IP
    - 代理状态：**已代理**（橙色云朵）

3. **配置 SSL/TLS**
    - 前往 SSL/TLS 设置
    - 将加密模式设为 **灵活**

   ```
   用户 ──[HTTPS]──→ Cloudflare ──[HTTP]──→ 你的服务器:3000
   ```

4. **启用传输加密**
   ```bash
   # 编辑 .env 并设置
   TRANSPORT_ENCRYPTION=true
   ```

5. **完成！** 通过 `https://nofx.yourdomain.com` 访问

---

## AI 配置

### 自定义 AI 提供商

[自定义 AI API 指南](custom-api.zh.md){ .md-button }

使用自定义 AI 模型或第三方 OpenAI 兼容的 API：

- 自定义 DeepSeek 端点
- 自托管模型
- 其他 LLM 提供商

---

## 交易所设置

配置你的交易所 API 密钥：

| 交易所 | 指南 | 类型 |
|--------|------|------|
| **Binance** | [设置指南](binance-api.md) | CEX |
| **Bybit** | [设置指南](bybit-api.md) | CEX |
| **OKX** | [设置指南](okx-api.md) | CEX |
| **Hyperliquid** | [设置指南](hyperliquid-agent-wallet.md) | DEX |
| **Aster DEX** | [设置指南](aster-api-wallet.md) | DEX |
| **Lighter** | [设置指南](lighter-agent-wallet.md) | DEX |

---

## 初始设置（Web 界面）

启动系统后，通过 Web 界面进行配置：

1. **配置 AI 模型** - 添加你的 AI API 密钥（DeepSeek、OpenAI 等）
2. **配置交易所** - 设置交易所 API 凭证
3. **创建策略** - 在策略工作室配置交易策略
4. **创建交易员** - 组合 AI 模型 + 交易所 + 策略
5. **开始交易** - 启动你配置的交易员

所有配置都通过 Web 界面完成 - 无需编辑 JSON 文件。

---

## 重要说明

!!! warning "交易前"
    - :warning: 先在测试网测试
    - :warning: 从小额开始
    - :warning: 理解风险
    - :warning: 阅读 [安全政策](https://github.com/NoFxAiOS/nofx/blob/main/SECURITY.md)

!!! danger "API 密钥"
    - :key: 永远不要将 API 密钥提交到 git
    - :key: 使用环境变量
    - :key: 限制 IP 访问
    - :key: 在交易所启用 2FA

---

## 常见问题

### 找不到 TA-Lib

```bash
# macOS
brew install ta-lib

# Ubuntu
sudo apt-get install libta-lib0-dev
```

### AI API 超时

- 检查 API 密钥是否正确
- 检查网络连接
- 系统超时为 120 秒

### 前端无法连接后端

- 确保后端在 http://localhost:8080 运行
- 检查端口是否被占用

**需要更多帮助?**

- :book: [常见问题](../guides/faq.zh.md)
- :book: [故障排查指南](../guides/troubleshooting.zh.md)
- :speech_balloon: [Telegram 社区](https://t.me/nofx_dev_community)
- :bug: [GitHub Issues](https://github.com/NoFxAiOS/nofx/issues)
