# 架构文档

面向想要了解 NOFX 内部机制的开发者的技术文档。

---

## 概述

NOFX 是一个全栈 AI 交易平台：

- **后端:** Go (Gin 框架, SQLite)
- **前端:** React/TypeScript (Vite, TailwindCSS)
- **架构:** 微服务风格的模块化设计

---

## 项目结构

```
nofx/
├── main.go                          # 程序入口（多交易员管理器）
├── config.json                      # 配置（现在通过 web 界面）
├── trading.db                       # SQLite 数据库
│
├── api/                             # HTTP API 服务
│   └── server.go                    # Gin 框架, RESTful API
│
├── trader/                          # 交易核心
│   ├── auto_trader.go               # 自动交易主控制器
│   ├── interface.go                 # 统一交易接口
│   ├── binance_futures.go           # Binance API 封装
│   ├── hyperliquid_trader.go        # Hyperliquid DEX 封装
│   └── aster_trader.go              # Aster DEX 封装
│
├── manager/                         # 多交易员管理
│   └── trader_manager.go            # 管理多个交易员实例
│
├── config/                          # 配置和数据库
│   └── database.go                  # SQLite 操作和模式
│
├── auth/                            # 认证
│   └── jwt.go                       # JWT 令牌管理 & 2FA
│
├── mcp/                             # 模型上下文协议
│   └── client.go                    # AI API 客户端
│
├── decision/                        # AI 决策引擎
│   ├── engine.go                    # 决策逻辑
│   └── prompt_manager.go            # 提示词模板系统
│
├── market/                          # 市场数据
│   ├── data.go                      # 市场数据和指标
│   └── websocket_client.go          # WebSocket 接口
│
├── pool/                            # 币种池管理
│   └── coin_pool.go                 # AI500 + OI Top 合并池
│
├── logger/                          # 日志系统
│   └── decision_logger.go           # 决策记录
│
└── web/                             # React 前端
    ├── src/
    │   ├── components/              # React 组件
    │   ├── lib/api.ts               # API 封装
    │   └── stores/                  # Zustand 状态管理
    └── package.json                 # 前端依赖
```

---

## 系统架构

### 高层概述

```
┌──────────────────────────────────────────────────────────────────┐
│                      表现层                                       │
│    React SPA (Vite + TypeScript + TailwindCSS)                  │
│    - 竞赛仪表板、交易员管理界面                                    │
└──────────────────────────────────────────────────────────────────┘
                             ↓ HTTP/JSON API
┌──────────────────────────────────────────────────────────────────┐
│                      API 层 (Gin 路由)                            │
│    /api/traders, /api/status, /api/positions, /api/decisions    │
│    认证中间件 (JWT), CORS 处理                                    │
└──────────────────────────────────────────────────────────────────┘
                             ↓
┌──────────────────────────────────────────────────────────────────┐
│                      业务逻辑层                                    │
│  ┌──────────────────┐  ┌──────────────────┐  ┌────────────────┐ │
│  │ TraderManager    │  │ DecisionEngine   │  │ MarketData     │ │
│  │ - 多交易员       │  │ - AI 推理        │  │ - K线数据      │ │
│  │   编排           │  │ - 风险控制       │  │ - 指标         │ │
│  └──────────────────┘  └──────────────────┘  └────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                             ↓
┌──────────────────────────────────────────────────────────────────┐
│                      数据访问层                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │
│  │ SQLite 数据库 │  │ 文件日志器   │  │ 外部 API          │     │
│  │ - 交易员     │  │ - 决策       │  │ - Binance         │     │
│  │ - 模型       │  │ - 性能       │  │ - Hyperliquid     │     │
│  └──────────────┘  └──────────────┘  └────────────────────┘     │
└──────────────────────────────────────────────────────────────────┘
```

---

## 核心模块

### 1. 交易系统 (`trader/`)

**目的:** 支持多交易所的交易执行层

**关键文件:**

- `auto_trader.go` - 主交易编排器
- `interface.go` - 统一交易接口
- `binance_futures.go` - Binance API 封装
- `hyperliquid_trader.go` - Hyperliquid DEX 封装

**设计模式:** 基于接口抽象的策略模式

```go
type ExchangeClient interface {
    GetAccount() (*AccountInfo, error)
    GetPositions() ([]*Position, error)
    CreateOrder(*OrderParams) (*Order, error)
}
```

### 2. 决策引擎 (`decision/`)

**目的:** AI 驱动的交易决策

**功能:**

- 思维链推理
- 历史性能分析
- 风险感知决策
- 多模型支持

### 3. 市场数据系统 (`market/`)

**目的:** 获取和分析市场数据

**功能:**

- 多时间框架 K 线数据
- 通过 TA-Lib 的技术指标（EMA、MACD、RSI、ATR）
- 持仓量追踪

---

## 请求流程

### 交易决策周期

```
AutoTrader（每 3-5 分钟）
    ↓
1. FetchAccountStatus() - 获取账户状态
    ↓
2. GetOpenPositions() - 获取持仓
    ↓
3. FetchMarketData() → TA-Lib 指标
    ↓
4. AnalyzeHistory() → 最近 20 笔交易
    ↓
5. GeneratePrompt() → 完整上下文
    ↓
6. CallAI() → DeepSeek/通义千问
    ↓
7. ParseDecision() → 结构化输出
    ↓
8. ValidateRisk() → 仓位限制、保证金
    ↓
9. ExecuteOrders() → 交易所 API
    ↓
10. LogDecision() → JSON 文件 + 数据库
```

---

## 数据库模式

### 核心表

**users**
```sql
- id (INTEGER PRIMARY KEY)
- username (TEXT UNIQUE)
- password_hash (TEXT)
- totp_secret (TEXT)
- is_admin (BOOLEAN)
```

**ai_models**
```sql
- id (INTEGER PRIMARY KEY)
- name (TEXT)
- model_type (TEXT)
- api_key (TEXT)
- api_url (TEXT)
```

**traders**
```sql
- id (TEXT PRIMARY KEY)
- name (TEXT)
- ai_model_id (INTEGER FK)
- exchange_id (INTEGER FK)
- status (TEXT)
```

---

## 核心依赖

### 后端 (Go)

| 包 | 用途 |
|---|------|
| `github.com/gin-gonic/gin` | HTTP API 框架 |
| `github.com/adshao/go-binance/v2` | Binance API 客户端 |
| `github.com/markcheno/go-talib` | 技术指标 |
| `github.com/golang-jwt/jwt/v5` | JWT 认证 |

### 前端 (React + TypeScript)

| 包 | 用途 |
|---|------|
| `react` | UI 框架 |
| `vite` | 构建工具 |
| `recharts` | 图表 |
| `zustand` | 状态管理 |
| `tailwindcss` | CSS 框架 |

---

## 开发者指南

**想要贡献?**

- 阅读 [贡献指南](https://github.com/tinkle-community/nofx/blob/main/CONTRIBUTING.md)
- 查看 [Open Issues](https://github.com/tinkle-community/nofx/issues)
- 加入 [Telegram 社区](https://t.me/nofx_dev_community)
