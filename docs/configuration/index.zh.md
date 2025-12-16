# 配置参考

本节涵盖 NOFX 的所有配置选项。

## AI 接口

配置 AI 模型提供商（DeepSeek、Qwen、OpenAI、Claude 等）以驱动交易决策。

- [AI 接口配置](../getting-started/custom-api.zh.md)

## 交易所接口

为支持的交易所设置 API 凭证：

| 交易所 | 类型 | 文档 |
|--------|------|------|
| Binance | CEX | [Binance API](../getting-started/binance-api.md) |
| Bybit | CEX | [Bybit API](../getting-started/bybit-api.md) |
| OKX | CEX | [OKX API](../getting-started/okx-api.md) |
| Hyperliquid | DEX | [Hyperliquid 代理钱包](../getting-started/hyperliquid-agent-wallet.md) |
| Aster DEX | DEX | [Aster API 钱包](../getting-started/aster-api-wallet.md) |
| Lighter | DEX | [Lighter 代理钱包](../getting-started/lighter-agent-wallet.md) |

## 环境变量

NOFX 关键环境变量：

| 变量 | 说明 | 必需 |
|------|------|------|
| `JWT_SECRET` | JWT 签名密钥 | 是 |
| `ENCRYPTION_KEY` | API 密钥加密密钥 | 是 |
| `TRANSPORT_ENCRYPTION` | 启用浏览器端加密 | 否 |
