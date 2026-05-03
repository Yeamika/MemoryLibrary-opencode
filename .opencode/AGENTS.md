# OpenCode 元目录

- 作用范围：适用于 `.opencode/` 及其子目录；更深层 `AGENTS.md` 优先。
- 一个 OpenCode Server 可以承载多个 workspace。每个 workspace 都有自己的上下文系统与运行时配置，会话始终依附于某个具体 workspace。
- `.opencode/` 用于存放 OpenCode 工作区元资产，不是产品源码目录。

## 目录说明

- `opencode.json`：工作区运行时配置。
- `docx/`：OpenCode 客户端说明、配置方法与示例。
- `agent/`：agent prompt 定义文件。
- `skills/`：本地 skill 定义。
- `tools/`：本地工具定义。

## 可热重载上下文系统

- `.opencode/` 是一个可热重载的上下文系统。
- `opencode.json` 不允许直接更改，必须通过可信接口修改。
- `agent/`、`skills/`、`tools/` 中的内容属于这个上下文系统的一部分。
