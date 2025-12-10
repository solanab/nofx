# API 参考

本节包含 NOFX 的 API 文档。

---

## 可用 API

| API | 描述 | 状态 |
|-----|------|------|
| [Coin API](coin_api.md) | 币种数据和信息 | :white_check_mark: 可用 |
| [持仓量 API](oi_api.md) | 持仓量数据 | :white_check_mark: 可用 |

---

## REST API 概述

### 基础 URL

```
http://localhost:8080/api
```

### 认证

大多数端点需要 JWT 认证：

```
Authorization: Bearer <your-jwt-token>
```

### 常用端点

#### 交易员

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/traders` | 列出所有交易员 |
| POST | `/traders` | 创建新交易员 |
| GET | `/traders/:id` | 获取交易员详情 |
| POST | `/traders/:id/start` | 启动交易员 |
| POST | `/traders/:id/stop` | 停止交易员 |
| DELETE | `/traders/:id` | 删除交易员 |

#### 状态

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/status` | 系统状态 |
| GET | `/positions` | 当前持仓 |
| GET | `/decisions/latest` | 最近的 AI 决策 |

#### 认证

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/auth/login` | 用户登录 |
| POST | `/auth/register` | 用户注册 |
| POST | `/auth/refresh` | 刷新 JWT 令牌 |

---

## 响应格式

所有 API 响应遵循此结构：

```json
{
  "success": true,
  "data": { ... },
  "error": null
}
```

错误响应：

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述"
  }
}
```

---

## 速率限制

- 默认：每分钟 100 次请求
- 认证端点：每分钟 10 次请求

---

## 详细 API 文档

详细的 API 文档请参阅：

- [Coin API](coin_api.md) - 币种数据端点
- [持仓量 API](oi_api.md) - 市场持仓量数据
