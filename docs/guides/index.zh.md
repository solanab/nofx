# 使用指南

全面的指南帮助你有效使用 NOFX。

---

## 可用指南

### 基本使用

| 指南 | 描述 | 状态 |
|------|------|------|
| [常见问题](faq.md) | 常见问题解答 | :white_check_mark: 可用 |
| [故障排查](troubleshooting.md) | 常见问题和解决方案 | :white_check_mark: 可用 |
| [提示词指南](prompt-guide.md) | AI 提示词自定义 | :white_check_mark: 可用 |
| [盈亏计算](pnl.md) | 了解盈亏计算 | :white_check_mark: 可用 |

---

## 故障排查快速参考

### 常见问题

**问题: 找不到 TA-Lib**
```bash
# macOS
brew install ta-lib

# Ubuntu/Debian
sudo apt-get install libta-lib0-dev
```

**问题: 精度错误**

- 系统自动处理交易所的 LOT_SIZE
- 检查网络连接
- 验证交易所 API 是否可访问

**问题: AI API 超时**

- 检查 API key 有效性
- 验证网络连接
- 检查 API 余额/积分
- 超时设置为 120 秒

**问题: 前端无法连接**

- 确保后端正在运行（http://localhost:8080）
- 检查端口 8080 是否可用
- 检查浏览器控制台错误

---

## 使用技巧

### 最佳实践

**1. 风险管理**

- 从小额开始（100-500 USDT）
- 使用子账户增加安全性
- 设置合理的杠杆限制
- 监控每日亏损限制

**2. 性能监控**

- 定期检查决策日志
- 分析胜率和盈利因子
- 查看 AI 推理（思维链）
- 追踪权益曲线趋势

**3. 配置**

- 先在测试网测试
- 逐步增加交易金额
- 调整扫描间隔（推荐 3-5 分钟）
- 初学者使用默认币种列表

---

## 进阶主题

### 多交易员竞赛

同时运行多个 AI 模型：

- 通义千问 vs DeepSeek 对决
- 实时比较表现
- 识别最佳策略

### 自定义币种池

- 使用外部 API 选择币种
- 结合 AI500 + OI Top 数据
- 按流动性和成交量过滤

### 交易所集成

- Binance Futures（CEX）
- Hyperliquid（DEX）
- Aster DEX（Binance 兼容）

---

## 理解指标

### 关键绩效指标

**胜率**

- 盈利交易的百分比
- 目标：>50% 以实现稳定盈利

**盈利因子**

- 毛利润与毛亏损的比率
- 目标：>1.5（1.5:1 或更好）

**夏普比率**

- 风险调整后的回报衡量
- 越高越好（>1.0 为佳）

**最大回撤**

- 最大峰谷跌幅
- 保持在 20% 以下以确保安全

---

## 需要帮助？

- :speech_balloon: [Telegram 社区](https://t.me/nofx_dev_community)
- :bug: [GitHub Issues](https://github.com/tinkle-community/nofx/issues)
- :bird: [Twitter @nofx_official](https://x.com/nofx_official)
