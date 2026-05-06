# Workspace 共享文档目录

## 作用范围

- 适用于 `docs/` 及其子目录；更深层 `AGENTS.md` 优先。

## 定位

- 这里用于存放 workspace 级共享运行说明、跨项目共用的基础设施约定和非 OpenCode 客户端专题文档。
- `.opencode/docx/` 只放 OpenCode 客户端自身说明；不要把 workspace 运行知识再塞回 `.opencode/`。

## 工作规则

- 文档面向人和 agent 共同阅读，但这里不是运行时配置目录。
- 跨多个项目共用、又不适合写回根 `AGENTS.md` 的稳定事实，优先放在这里。
- 某个项目独有的规则，仍应回到该项目最近的 `AGENTS.md` 或项目自己的 docs。
- 凭据、token、密码等敏感信息禁止写入这里。
