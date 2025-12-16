# Architecture Documentation

Technical documentation for developers who want to understand NOFX internals.

---

## Overview

NOFX is a full-stack AI trading platform with:

- **Backend:** Go (Gin framework, SQLite)
- **Frontend:** React/TypeScript (Vite, TailwindCSS)
- **Architecture:** Microservice-inspired modular design

---

## Project Structure

```
nofx/
├── main.go                          # Program entry (multi-trader manager)
├── config.json                      # Configuration (now via web interface)
├── trading.db                       # SQLite database
│
├── api/                             # HTTP API service
│   └── server.go                    # Gin framework, RESTful API
│
├── trader/                          # Trading core
│   ├── auto_trader.go               # Auto trading main controller
│   ├── interface.go                 # Unified trader interface
│   ├── binance_futures.go           # Binance API wrapper
│   ├── hyperliquid_trader.go        # Hyperliquid DEX wrapper
│   └── aster_trader.go              # Aster DEX wrapper
│
├── manager/                         # Multi-trader management
│   └── trader_manager.go            # Manages multiple trader instances
│
├── config/                          # Configuration & database
│   └── database.go                  # SQLite operations and schema
│
├── auth/                            # Authentication
│   └── jwt.go                       # JWT token management & 2FA
│
├── mcp/                             # Model Context Protocol
│   └── client.go                    # AI API client
│
├── decision/                        # AI decision engine
│   ├── engine.go                    # Decision logic
│   └── prompt_manager.go            # Prompt template system
│
├── market/                          # Market data
│   ├── data.go                      # Market data & indicators
│   └── websocket_client.go          # WebSocket interface
│
├── pool/                            # Coin pool management
│   └── coin_pool.go                 # AI500 + OI Top merged pool
│
├── logger/                          # Logging system
│   └── decision_logger.go           # Decision recording
│
└── web/                             # React frontend
    ├── src/
    │   ├── components/              # React components
    │   ├── lib/api.ts               # API wrapper
    │   └── stores/                  # Zustand state management
    └── package.json                 # Frontend dependencies
```

---

## System Architecture

### High-Level Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│    React SPA (Vite + TypeScript + TailwindCSS)                  │
│    - Competition dashboard, trader management UI                 │
└──────────────────────────────────────────────────────────────────┘
                             ↓ HTTP/JSON API
┌──────────────────────────────────────────────────────────────────┐
│                      API LAYER (Gin Router)                      │
│    /api/traders, /api/status, /api/positions, /api/decisions    │
│    Authentication middleware (JWT), CORS handling                │
└──────────────────────────────────────────────────────────────────┘
                             ↓
┌──────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                        │
│  ┌──────────────────┐  ┌──────────────────┐  ┌────────────────┐ │
│  │ TraderManager    │  │ DecisionEngine   │  │ MarketData     │ │
│  │ - Multi-trader   │  │ - AI reasoning   │  │ - K-lines      │ │
│  │   orchestration  │  │ - Risk control   │  │ - Indicators   │ │
│  └──────────────────┘  └──────────────────┘  └────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                             ↓
┌──────────────────────────────────────────────────────────────────┐
│                      DATA ACCESS LAYER                           │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │
│  │ SQLite DB    │  │ File Logger  │  │ External APIs      │     │
│  │ - Traders    │  │ - Decisions  │  │ - Binance          │     │
│  │ - Models     │  │ - Performance│  │ - Hyperliquid      │     │
│  └──────────────┘  └──────────────┘  └────────────────────┘     │
└──────────────────────────────────────────────────────────────────┘
```

---

## Core Modules

### 1. Trader System (`trader/`)

**Purpose:** Trading execution layer with multi-exchange support

**Key Files:**

- `auto_trader.go` - Main trading orchestrator
- `interface.go` - Unified trader interface
- `binance_futures.go` - Binance API wrapper
- `hyperliquid_trader.go` - Hyperliquid DEX wrapper

**Design Pattern:** Strategy pattern with interface-based abstraction

```go
type ExchangeClient interface {
    GetAccount() (*AccountInfo, error)
    GetPositions() ([]*Position, error)
    CreateOrder(*OrderParams) (*Order, error)
}
```

### 2. Decision Engine (`decision/`)

**Purpose:** AI-powered trading decision making

**Features:**

- Chain-of-Thought reasoning
- Historical performance analysis
- Risk-aware decision making
- Multi-model support

### 3. Market Data System (`market/`)

**Purpose:** Fetch and analyze market data

**Features:**

- Multi-timeframe K-line data
- Technical indicators via TA-Lib (EMA, MACD, RSI, ATR)
- Open Interest tracking

---

## Request Flow

### Trading Decision Cycle

```
AutoTrader (every 3-5 min)
    ↓
1. FetchAccountStatus()
    ↓
2. GetOpenPositions()
    ↓
3. FetchMarketData() → TA-Lib indicators
    ↓
4. AnalyzeHistory() → last 20 trades
    ↓
5. GeneratePrompt() → full context
    ↓
6. CallAI() → DeepSeek/Qwen
    ↓
7. ParseDecision() → structured output
    ↓
8. ValidateRisk() → position limits, margin
    ↓
9. ExecuteOrders() → exchange API
    ↓
10. LogDecision() → JSON file + database
```

---

## Database Schema

### Core Tables

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

## Core Dependencies

### Backend (Go)

| Package | Purpose |
|---------|---------|
| `github.com/gin-gonic/gin` | HTTP API framework |
| `github.com/adshao/go-binance/v2` | Binance API client |
| `github.com/markcheno/go-talib` | Technical indicators |
| `github.com/golang-jwt/jwt/v5` | JWT authentication |

### Frontend (React + TypeScript)

| Package | Purpose |
|---------|---------|
| `react` | UI framework |
| `vite` | Build tool |
| `recharts` | Charts |
| `zustand` | State management |
| `tailwindcss` | CSS framework |

---

## For Developers

**Want to contribute?**

- Read [Contributing Guide](https://github.com/tinkle-community/nofx/blob/main/CONTRIBUTING.md)
- Check [Open Issues](https://github.com/tinkle-community/nofx/issues)
- Join [Telegram Community](https://t.me/nofx_dev_community)
