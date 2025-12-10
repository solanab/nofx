# NOFX 快速开始

本节包含了启动和运行 NOFX 所需的所有文档。

---

## 部署选项

选择最适合你需求的方法：

### :whale: Docker 部署（推荐）

**最适合:** 新手、快速部署、生产环境部署

[Docker 部署指南](docker-deploy.md){ .md-button .md-button--primary }

**优点:**

- :white_check_mark: 一键部署
- :white_check_mark: 包含所有依赖
- :white_check_mark: 易于更新和管理
- :white_check_mark: 隔离环境

**快速开始:**
```bash
cp config.json.example config.json
./scripts/start.sh start --build
```

---

## AI 配置

### 自定义 AI 提供商

[自定义 AI API 指南](custom-api.md){ .md-button }

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

## 前提条件

开始之前，请确保你有：

### Docker 方式

- :white_check_mark: Docker 20.10+
- :white_check_mark: Docker Compose V2

### 手动方式

- :white_check_mark: Go 1.21+
- :white_check_mark: Node.js 18+
- :white_check_mark: TA-Lib 库

---

## 下一步

部署完成后：

1. **配置 AI 模型** → 访问 http://localhost:3000 的 Web 界面
2. **设置交易所** → 添加 Binance/Hyperliquid 凭证
3. **创建交易员** → 将 AI 模型与交易所结合
4. **开始交易** → 在仪表板监控表现

### 可选: 启用管理员模式（单用户）

对于单租户/自托管使用，你可以启用严格的管理员专用访问：

1. 在 `config.json` 中设置以下 2 个字段：
```json
{
  "admin_mode": true,
  "jwt_secret": "YOUR_JWT_SECRET"
}
```

2. 设置环境变量（Docker compose 已配置）：
    - `NOFX_ADMIN_PASSWORD` — 管理员密码（明文；启动时会被哈希）

3. 在 `/login` 页面使用管理员密码登录。启用管理员模式后，所有非必要的端点对未认证用户都会被阻止。

---

## 重要说明

!!! warning "交易前"
    - :warning: 先在测试网测试
    - :warning: 从小额开始
    - :warning: 理解风险
    - :warning: 阅读 [安全政策](https://github.com/tinkle-community/nofx/blob/main/SECURITY.md)

!!! danger "API 密钥"
    - :key: 永远不要将 API 密钥提交到 git
    - :key: 使用环境变量
    - :key: 限制 IP 访问
    - :key: 在交易所启用 2FA

---

## 故障排查

**常见问题:**

1. **Docker 构建失败** → 检查 Docker 版本，更新到 20.10+
2. **找不到 TA-Lib** → `brew install ta-lib`（macOS）或 `apt-get install libta-lib0-dev`（Ubuntu）
3. **端口 8080 被占用** → 在 .env 文件中更改 `API_PORT`
4. **前端无法连接** → 检查后端是否在端口 8080 运行

**需要更多帮助?**

- :book: [常见问题](../guides/faq.md)
- :speech_balloon: [Telegram 社区](https://t.me/nofx_dev_community)
- :bug: [GitHub Issues](https://github.com/tinkle-community/nofx/issues)
