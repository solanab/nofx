# Getting Started with NOFX

This section contains all the documentation you need to get NOFX up and running.

---

## Deployment Options

Choose the method that best fits your needs:

### :whale: Docker Deployment (Recommended)

**Best for:** Beginners, quick setup, production deployments

[Docker Deployment Guide](docker-deploy.md){ .md-button .md-button--primary }

**Pros:**

- :white_check_mark: One-command setup
- :white_check_mark: All dependencies included
- :white_check_mark: Easy to update and manage
- :white_check_mark: Isolated environment

**Quick Start:**
```bash
cp config.json.example config.json
./scripts/start.sh start --build
```

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

## Prerequisites

Before starting, ensure you have:

### For Docker Method

- :white_check_mark: Docker 20.10+
- :white_check_mark: Docker Compose V2

### For Manual Method

- :white_check_mark: Go 1.21+
- :white_check_mark: Node.js 18+
- :white_check_mark: TA-Lib library

---

## Next Steps

After deployment:

1. **Configure AI Models** → Web interface at http://localhost:3000
2. **Set Up Exchange** → Add Binance/Hyperliquid credentials
3. **Create Traders** → Combine AI models with exchanges
4. **Start Trading** → Monitor performance in dashboard

### Optional: Enable Admin Mode (Single-User)

For single-tenant/self-hosted usage, you can enable strict admin-only access:

1. In `config.json` set the 2 fields below:
```json
{
  "admin_mode": true,
  "jwt_secret": "YOUR_JWT_SECRET"
}
```

2. Set environment variables (Docker compose already wired):
    - `NOFX_ADMIN_PASSWORD` — admin password (plaintext; hashed on startup)

3. Login at `/login` using the admin password. All non-essential endpoints are blocked to unauthenticated users while admin mode is enabled.

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

## Troubleshooting

**Common Issues:**

1. **Docker build fails** → Check Docker version, update to 20.10+
2. **TA-Lib not found** → `brew install ta-lib` (macOS) or `apt-get install libta-lib0-dev` (Ubuntu)
3. **Port 8080 in use** → Change `API_PORT` in .env file
4. **Frontend won't connect** → Check backend is running on port 8080

**Need more help?**

- :book: [FAQ](../guides/faq.md)
- :speech_balloon: [Telegram Community](https://t.me/nofx_dev_community)
- :bug: [GitHub Issues](https://github.com/tinkle-community/nofx/issues)
