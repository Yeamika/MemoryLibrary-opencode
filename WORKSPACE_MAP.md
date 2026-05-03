# Workspace Git / Memory Map

这个文件用于说明：**哪个 repo 拥有哪个路径，以及该路径应读取哪条 `AGENTS.md` 记忆链**。

## 根 meta repo 的职责

根 repo 只跟踪 workspace 级记忆与 `.opencode/` 元资产，例如：

- 根 `AGENTS.md`
- 根 `README.md`
- `WORKSPACE_MAP.md`
- `.opencode/AGENTS.md`
- `.opencode/docx/`
- 需要保留的空目录占位（如 `.gitkeep`）

## 记忆模型

- 根 `AGENTS.md`：workspace 级记忆基线
- 子目录 `AGENTS.md`：该子树的 scoped memory
- 多层同时存在时，按父 → 子读取，越近越具体

## 通用归属表

| Path | Git owner | Memory source | Notes |
|---|---|---|---|
| workspace root docs | root meta repo | root `AGENTS.md` | workspace 级规则与记忆 |
| `.opencode/` | root meta repo | root `AGENTS.md` → `.opencode/AGENTS.md` | OpenCode 元目录 |
| `.opencode/docx/` | root meta repo | root `AGENTS.md` → `.opencode/AGENTS.md` → `.opencode/docx/AGENTS.md` | 长文档、示例、配置说明 |
| child project repo | child repo | child repo 自己的 `AGENTS.md` 链 | 产品实现与项目内记忆 |
| `.config/`、`.workerspace/`、`tmp/` | local-only | n/a | 本地配置、运行态与临时产物 |

## 使用规则

- 不把子项目源码历史吸收到根 meta repo。
- 需要了解某个路径的记忆时，先用本文件判断归属，再去读对应 repo 的 `AGENTS.md` 链。
- 目录结构或 ownership 变化时，应同步更新本文件。
