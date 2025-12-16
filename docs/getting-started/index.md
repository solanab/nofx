# Getting Started with NOFX

This section contains all the documentation you need to get NOFX up and running.

---

## Quick Start

### One-Click Install (Recommended)

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
```

That's it! Open **http://127.0.0.1:3000** in your browser.

### Docker Compose (Manual)

```bash
# Download and start
curl -O https://raw.githubusercontent.com/NoFxAiOS/nofx/main/docker-compose.prod.yml
docker compose -f docker-compose.prod.yml up -d
```

Access Web Interface: **http://127.0.0.1:3000**

```bash
# Management commands
docker compose -f docker-compose.prod.yml logs -f    # View logs
docker compose -f docker-compose.prod.yml restart    # Restart
docker compose -f docker-compose.prod.yml down       # Stop
docker compose -f docker-compose.prod.yml pull && docker compose -f docker-compose.prod.yml up -d  # Update
```

### Manual Installation (For Developers)

#### Prerequisites

- **Go 1.21+**
- **Node.js 18+**
- **TA-Lib** (technical indicator library)

```bash
# Install TA-Lib
# macOS
brew install ta-lib

# Ubuntu/Debian
sudo apt-get install libta-lib0-dev
```

#### Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/NoFxAiOS/nofx.git
cd nofx

# 2. Install backend dependencies
go mod download

# 3. Install frontend dependencies
cd web
npm install
cd ..

# 4. Build and start backend
go build -o nofx
./nofx

# 5. Start frontend (new terminal)
cd web
npm run dev
```

Access Web Interface: **http://127.0.0.1:3000**

---

## Windows Installation

### Method 1: Docker Desktop (Recommended)

1. **Install Docker Desktop**
    - Download from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
    - Run the installer and restart your computer
    - Start Docker Desktop and wait for it to be ready

2. **Run NOFX**
   ```powershell
   # Open PowerShell and run:
   curl -o docker-compose.prod.yml https://raw.githubusercontent.com/NoFxAiOS/nofx/main/docker-compose.prod.yml
   docker compose -f docker-compose.prod.yml up -d
   ```

3. **Access**: Open **http://127.0.0.1:3000** in your browser

### Method 2: WSL2 (For Development)

1. **Install WSL2**
   ```powershell
   # Open PowerShell as Administrator
   wsl --install
   ```
   Restart your computer after installation.

2. **Install Ubuntu from Microsoft Store**
    - Open Microsoft Store
    - Search "Ubuntu 22.04" and install
    - Launch Ubuntu and set up username/password

3. **Install Dependencies in WSL2**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y

   # Install Go
   wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
   sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
   echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
   source ~/.bashrc

   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # Install TA-Lib
   sudo apt-get install -y libta-lib0-dev

   # Install Git
   sudo apt-get install -y git
   ```

4. **Clone and Run NOFX**
   ```bash
   git clone https://github.com/NoFxAiOS/nofx.git
   cd nofx

   # Build and run backend
   go build -o nofx && ./nofx

   # In another terminal, run frontend
   cd web && npm install && npm run dev
   ```

5. **Access**: Open **http://127.0.0.1:3000** in Windows browser

### Method 3: Docker in WSL2 (Best of Both Worlds)

1. **Install Docker Desktop with WSL2 backend**
    - During Docker Desktop installation, enable "Use WSL 2 based engine"
    - In Docker Desktop Settings → Resources → WSL Integration, enable your Linux distro

2. **Run from WSL2 terminal**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
   ```

---

## Server Deployment

### Quick Deploy (HTTP via IP)

By default, transport encryption is **disabled**, allowing you to access NOFX via IP address without HTTPS:

```bash
# Deploy to your server
curl -fsSL https://raw.githubusercontent.com/NoFxAiOS/nofx/main/install.sh | bash
```

Access via `http://YOUR_SERVER_IP:3000` - works immediately.

### Enhanced Security (HTTPS)

For enhanced security, enable transport encryption in `.env`:

```bash
TRANSPORT_ENCRYPTION=true
```

When enabled, browser uses Web Crypto API to encrypt API keys before transmission. This requires:

- `https://` - Any domain with SSL
- `http://localhost` - Local development

### Quick HTTPS Setup with Cloudflare

1. **Add your domain to Cloudflare** (free plan works)
    - Go to [dash.cloudflare.com](https://dash.cloudflare.com)
    - Add your domain and update nameservers

2. **Create DNS record**
    - Type: `A`
    - Name: `nofx` (or your subdomain)
    - Content: Your server IP
    - Proxy status: **Proxied** (orange cloud)

3. **Configure SSL/TLS**
    - Go to SSL/TLS settings
    - Set encryption mode to **Flexible**

   ```
   User ──[HTTPS]──→ Cloudflare ──[HTTP]──→ Your Server:3000
   ```

4. **Enable transport encryption**
   ```bash
   # Edit .env and set
   TRANSPORT_ENCRYPTION=true
   ```

5. **Done!** Access via `https://nofx.yourdomain.com`

---

## AI Configuration

### Custom AI Providers

[Custom AI API Guide](custom-api.md){ .md-button }

Use custom AI models or third-party OpenAI-compatible APIs:

- Custom DeepSeek endpoints
- Self-hosted models
- Other LLM providers

---

## Exchange Setup

Configure your exchange API keys:

| Exchange | Guide | Type |
|----------|-------|------|
| **Binance** | [Setup Guide](binance-api.md) | CEX |
| **Bybit** | [Setup Guide](bybit-api.md) | CEX |
| **OKX** | [Setup Guide](okx-api.md) | CEX |
| **Hyperliquid** | [Setup Guide](hyperliquid-agent-wallet.md) | DEX |
| **Aster DEX** | [Setup Guide](aster-api-wallet.md) | DEX |
| **Lighter** | [Setup Guide](lighter-agent-wallet.md) | DEX |

---

## Initial Setup (Web Interface)

After starting the system, configure through the web interface:

1. **Configure AI Models** - Add your AI API keys (DeepSeek, OpenAI, etc.)
2. **Configure Exchanges** - Set up exchange API credentials
3. **Create Strategy** - Configure trading strategy in Strategy Studio
4. **Create Trader** - Combine AI model + Exchange + Strategy
5. **Start Trading** - Launch your configured traders

All configuration is done through the web interface - no JSON file editing required.

---

## Important Notes

!!! warning "Before Trading"
    - :warning: Test on testnet first
    - :warning: Start with small amounts
    - :warning: Understand the risks
    - :warning: Read [Security Policy](https://github.com/tinkle-community/nofx/blob/main/SECURITY.md)

!!! danger "API Keys"
    - :key: Never commit API keys to git
    - :key: Use environment variables
    - :key: Restrict IP access
    - :key: Enable 2FA on exchanges

---

## Common Issues

### TA-Lib not found

```bash
# macOS
brew install ta-lib

# Ubuntu
sudo apt-get install libta-lib0-dev
```

### AI API timeout

- Check if API key is correct
- Check network connection
- System timeout is 120 seconds

### Frontend can't connect to backend

- Ensure backend is running on http://localhost:8080
- Check if port is occupied

**Need more help?**

- :book: [FAQ](../guides/faq.md)
- :book: [Troubleshooting Guide](../guides/troubleshooting.md)
- :speech_balloon: [Telegram Community](https://t.me/nofx_dev_community)
- :bug: [GitHub Issues](https://github.com/NoFxAiOS/nofx/issues)
