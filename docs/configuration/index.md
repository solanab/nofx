# Configuration

This section covers all configuration options for NOFX.

## AI API

Configure your AI model providers (DeepSeek, Qwen, OpenAI, Claude, etc.) to power the trading decisions.

- [AI API Configuration](../getting-started/custom-api.md)

## Exchange API

Set up API credentials for supported exchanges:

| Exchange | Type | Documentation |
|----------|------|---------------|
| Binance | CEX | [Binance API](../getting-started/binance-api.md) |
| Bybit | CEX | [Bybit API](../getting-started/bybit-api.md) |
| OKX | CEX | [OKX API](../getting-started/okx-api.md) |
| Hyperliquid | DEX | [Hyperliquid Agent Wallet](../getting-started/hyperliquid-agent-wallet.md) |
| Aster DEX | DEX | [Aster API Wallet](../getting-started/aster-api-wallet.md) |
| Lighter | DEX | [Lighter Agent Wallet](../getting-started/lighter-agent-wallet.md) |

## Environment Variables

Key environment variables for NOFX:

| Variable | Description | Required |
|----------|-------------|----------|
| `JWT_SECRET` | JWT signing secret | Yes |
| `ENCRYPTION_KEY` | API key encryption key | Yes |
| `TRANSPORT_ENCRYPTION` | Enable browser-side encryption | No |
