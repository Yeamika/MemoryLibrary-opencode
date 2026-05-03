# `.opencode/docx/` 文档索引

这个目录专门放 **OpenCode 客户端与 `.opencode/` 体系** 的长文档、配置说明和可复制 demo。

这些专题 `README.md` 已经尽量按**当前 OpenCode 客户端里 agent 实际可见的控制面**来写：也就是直接围绕当前可用的 `workspaceMcp`、`workspaceSkill`、`workspaceTool`、`workspaceOverview`、`reload` 与文件编辑能力来说明怎么操作，而不是要求先去翻源码。

## 推荐阅读顺序

1. `agent/README.md` —— 了解 agent 文件怎么写、怎么组织
2. `skill/README.md` —— 了解 skill 目录和 `SKILL.md` 怎么写
3. `tool/README.md` —— 了解 tool 文件怎么写、怎么注册
4. `mcp/README.md` —— 了解 MCP 条目怎么配置、什么时候 reload 不够

## 子目录说明

- `agent/` —— agent 配置文档与 agent demo
- `skill/` —— skill 配置文档与 `SKILL.md` demo
- `tool/` —— tool 配置文档与 `.ts` demo
- `mcp/` —— MCP 配置文档与 `opencode.json` 片段 demo

## 总览提醒

- `agent/`、`skill/`、`tool/`、`mcp/` 四个目录合起来，已经覆盖原先那份总览长文的大部分内容。
- 如果后续确实需要新的“跨主题总览文档”，建议重新写一份更短的索引文，而不是再把所有内容堆回一个大文件。

## 使用方式

- 先读每个子目录里的 `README.md`
- 再根据需要复制或改写对应的 `demo-*` 文件
- 如果 demo 要落到真实工作区，请放回 `.opencode/agent/`、`.opencode/skills/`、`.opencode/tools/` 或 `.opencode/opencode.json` 对应位置
- 如果你要的是“当前 agent 在客户端里到底该怎么操作”，优先看各专题 `README.md` 里的“当前 agent 侧操作方式”小节
- 不要把 workspace inventory 已更新误判成“当前 agent 一定看得到”

## demo 约定

- 当前这些 `demo-*` 文件不再使用玩具占位内容。
- `agent/` 下的 demo 使用通用的最小 agent 示例。
- `skill/`、`tool/`、`mcp/` 下的 demo 优先使用 OpenCode 现有测试资产可对照的结构。
- 如果真实示例涉及敏感信息，只做最小必要脱敏，并在子目录 `README.md` 中标明来源类型。

## 注意

- 这里的 demo 默认都是**安全示例**，不包含真实密码、token 或私密配置
- 真正涉及敏感写入时，仍应遵守上层 `.opencode/AGENTS.md` 里的授权与 reload 规则
- 如果 reload 后工作区 inventory 已变化，仍要区分“工作区已装载”与“当前 agent 会话里是否可见”这两层状态
