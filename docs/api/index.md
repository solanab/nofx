# API Reference

This section contains the API documentation for NOFX.

---

## Available APIs

| API | Description | Status |
|-----|-------------|--------|
| [Coin API](coin_api.md) | Coin data and information | :white_check_mark: Available |
| [Open Interest API](oi_api.md) | Open interest data | :white_check_mark: Available |

---

## REST API Overview

### Base URL

```
http://localhost:8080/api
```

### Authentication

Most endpoints require JWT authentication:

```
Authorization: Bearer <your-jwt-token>
```

### Common Endpoints

#### Traders

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/traders` | List all traders |
| POST | `/traders` | Create a new trader |
| GET | `/traders/:id` | Get trader details |
| POST | `/traders/:id/start` | Start a trader |
| POST | `/traders/:id/stop` | Stop a trader |
| DELETE | `/traders/:id` | Delete a trader |

#### Status

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/status` | System status |
| GET | `/positions` | Current positions |
| GET | `/decisions/latest` | Recent AI decisions |

#### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | User login |
| POST | `/auth/register` | User registration |
| POST | `/auth/refresh` | Refresh JWT token |

---

## Response Format

All API responses follow this structure:

```json
{
  "success": true,
  "data": { ... },
  "error": null
}
```

Error responses:

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description"
  }
}
```

---

## Rate Limiting

- Default: 100 requests per minute
- Authentication endpoints: 10 requests per minute

---

## Detailed API Documentation

For detailed API documentation, see:

- [Coin API](coin_api.md) - Coin data endpoints
- [Open Interest API](oi_api.md) - Market open interest data
