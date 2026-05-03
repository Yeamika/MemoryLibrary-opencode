# OpenCode Agent 配置说明

本文说明 **`.opencode/agent/`** 下的 agent 文件怎么组织、怎么写、怎么让它在 OpenCode 里被识别。

## 0. 当前 agent 侧的实际操作方式

按当前 OpenCode 客户端里 agent 可见的上下文来看：

- 当前**没有** `workspaceAgent` 这种专用控制面
- 所以 agent 文件不能像 skill / tool / MCP 那样走专用写接口
- 更新 prompt 的常用路径是：直接修改 `.opencode/agent/*.md`，然后执行 `reload()`，最后用文件读取结果复查

这里最重要的一点是：**不要把 `workspaceSkill` / `workspaceTool` 的操作方式误套到 agent 上。**

## 1. 源码里的实际行为

- OpenCode 会扫描 `{agent,agents}/**/*.md`
- 每个 markdown 文件：
  - YAML frontmatter → agent 配置
  - 正文 → agent 的 `prompt`
- agent 标识符默认来自**相对路径去掉扩展名后的结果**
  - `release-local.md` → `release-local`
  - `release/local.md` → `release/local`

## 2. 推荐写法

### 推荐目录

```text
.opencode/agent/
  code-review.md
  release-check.md
```

### 推荐规则

- 优先使用**单文件单 agent**
- 文件名尽量直接等于 agent 名称
- 除非确实需要分组，否则先不要用过深的子目录
- 跨多个 agent 的共同硬规则放在上层 `.opencode/AGENTS.md`
- 详细编写说明放在当前这份 `docx/agent/README.md`，不要再在 `.opencode/agent/` 里额外放目录级 `AGENTS.md`

## 3. frontmatter 常用字段

源码支持的常用字段包括：

- `description`
- `model`
- `variant`
- `temperature`
- `top_p`
- `mode`（`subagent` / `primary` / `all`）
- `hidden`
- `color`
- `steps`
- `permission`
- `disable`

说明：

- 未知字段会被归到 `options`
- frontmatter 里的 `name` 虽然能覆盖默认名称推导，但**不建议常用**
- 为降低歧义，建议显式写 `mode`
- 当前客户端行为上，`mode: primary` 的 agent **不应期待被主动探测为可运行的 subagent**
- 如果你希望某个 agent 能被上层 agent 主动发现并以子 agent 方式运行，优先使用 `mode: subagent`
- 只有在确实同时承担主 / 子两种入口角色时，再考虑 `mode: all`

## 4. 新增 agent 的步骤

1. 在 `.opencode/agent/` 新建一个 `.md` 文件
2. 补 frontmatter
3. 在正文里写 system prompt
4. 执行 `reload()` 请求工作区刷新 prompt 相关状态
5. 用 `read` 复查 frontmatter 与正文是否符合预期
6. 用 git 管理历史

说明：

- 当前平台没有 `workspaceAgent` 控制面
- `workspaceOverview` 目前也不是 agent 清单浏览器，所以 agent 变更主要靠文件级检查，而不是靠 overview 验证
- 如果你修改的是 agent prompt，本身就应把“改 `.md` 文件 + `reload()`”视为标准更新路径
- 但 `reload()` 依然只是工作区热重载请求；如果当前会话没有如预期反映更新，应按上层 `.opencode/AGENTS.md` 的规则处理可见性限制

## 5. 一个最小模板

```md
---
description: <一句话说明这个 agent 什么时候用>
mode: subagent
---

# <Agent 名称>

## 主要职责
- 

## 输入
- 

## 输出
- 

## 禁止事项
- 
```

## 6. 示例文件

请看同目录下的：

- `demo-subagent.md`

这个文件提供的是一个通用、最小、可直接复制改写的 subagent 示例。
