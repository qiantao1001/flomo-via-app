# flomo-send

通过 Webhook API 发送笔记到 flomo（浮墨笔记）的 OpenClaw Skill。

> ⚠️ 注意：本版本已取消 URL Scheme 模式（mac 应用当前不支持该功能）。
> 统一改为使用 Webhook API（需要 flomo PRO）。

## 功能特性

-- ✅ **Webhook 为主（已取消 URL Scheme）**：统一使用 Webhook API 进行发送，URL Scheme 模式已移除
- ✅ **交互式配置**：安装时自动引导配置 Pro 账户
- ✅ **标签支持**：自动解析 `#标签` 格式
- ✅ **长度检查**：自动验证 5000 字限制
- ✅ **特殊字符处理**：正确处理中文、引号等特殊字符

## 安装

```bash
# 进入 skill 目录
cd skills/flomo-send

# 运行交互式配置
./scripts/configure.sh
```

配置脚本会询问：
1. 是否有 flomo PRO 账户
2. Webhook URL（或只提供 token，脚本会自动构造成完整 URL）
3. 配置保存位置（默认保存到本地 `.env` 文件，仅此方式以避免修改 shell 配置）

## 使用方法

### 基础用法

```bash
# 发送简单笔记
./scripts/flomo_send.sh "我的快速想法"

# 带标签
./scripts/flomo_send.sh "读书笔记" "#读书 #认知"

# 从剪贴板
./scripts/flomo_send.sh "$(pbpaste)" "#待读"

# 管道输入
echo "来自管道的笔记" | ./scripts/flomo_send.sh
```

### URL Scheme

URL Scheme 直接调用已在本版本移除，因为 macOS 上的 flomo 应用当前不支持所需的行为。请改用 Webhook API（参见下方“配置”一节），或通过 `./scripts/configure.sh` 保存你的 Webhook 设置到本地 `.env` 后使用 `./scripts/flomo_send.sh`。

## 要求

- **flomo PRO 会员**（Webhook API 需要）
- **curl** 命令可用（脚本使用 `curl` 发送 HTTP 请求）
- **Python 3**（脚本使用 Python 构建 JSON payload，或可调整为纯 shell 实现）

## 配置

### 环境变量

| 变量 | 说明 |
|------|------|
| `FLOMO_WEBHOOK_URL` | 完整的 Webhook URL（格式：`https://flomoapp.com/iwh/<your-token>`） |

### 手动配置

```bash
export FLOMO_WEBHOOK_URL="https://flomoapp.com/iwh/your-token-here"
```

建议将该变量写入本地 `.env`（skill 目录）以持久化，或在当前终端临时导出以测试。

## 限制

- 内容最多 **5000 字**
- 图片最多 **9 张**（仅 URL Scheme）
- Webhook 不支持图片

## 获取 Webhook URL

1. 访问 [flomo 设置页面](https://flomoapp.com/mine?source=incoming_webhook)
2. 复制你的专属 Webhook URL（示例格式：`https://flomoapp.com/iwh/xxxxxxxxxxxxxxxx`）

## 示例

**.env 示例（请勿提交到版本控制）**

```bash
# .env（示例）
FLOMO_WEBHOOK_URL="https://flomoapp.com/iwh/xxxxxxxxxxxxxxxx"
```

**快速示例**

```bash
# 运行交互式配置（将在 skill 目录生成 .env）
./scripts/configure.sh

# 发送简单笔记
./scripts/flomo_send.sh "我的快速想法"

# 带标签
./scripts/flomo_send.sh "读书笔记" "#读书 #认知"

# 从剪贴板发送
./scripts/flomo_send.sh "$(pbpaste)" "#待读"

# 从管道发送
echo "来自管道的笔记" | ./scripts/flomo_send.sh
```

注意：`.env` 文件包含敏感信息（Webhook URL），请保持私密并在 `.gitignore` 中排除它。

## 项目结构

```
flomo-send/
├── SKILL.md              # Skill 定义（AI 使用）
├── README.md             # 本文件
├── scripts/
│   ├── configure.sh      # 交互式配置脚本
│   └── flomo_send.sh     # 发送笔记脚本
└── references/
    └── api.md            # API 详细文档
```

## License

MIT
