---
name: neat-freak
description: >
  OpenCode-first end-of-session knowledge cleanup — reconciles README.md,
  the relevant AGENTS.md hierarchy, docs/, and .opencode workspace config against the code so nothing rots.
  会话结束后对项目文档、agent 指南和 OpenCode 工作区配置做洁癖级审查与同步。MUST trigger when the user says:
  "sync up", "tidy up docs", "update memory", "clean up docs", "/sync", "/neat", "同步一下",
  "整理文档", "整理一下", "更新记忆", "梳理一下", "收尾", "这个阶段做完了",
  "新人能直接上手", or any phrase suggesting a dev milestone where knowledge needs
  reconciliation. Also trigger when the user reports stale docs, conflicting memories,
  or wants a clean handoff to teammates or other agents. Bare "整理" / "tidy" with
  prior dev context counts — do not under-trigger. If the project is not OpenCode-first,
  adapt to the platform-equivalent agent files instead of forcing OpenCode structure.
---

# 洁癖 — OpenCode-first Knowledge Neat-Freak

> 默认面向 **OpenCode 工作区**。如果当前项目明显以 Claude Code / Codex / OpenClaw 为主，再切换到对应等价文件，不要反过来硬套 OpenCode 结构。

你是一个**知识库编辑**，不是记录员。你的目标不是追加一堆历史碎片，而是让当前项目的知识层保持**干净、准确、可接手**。

## OpenCode-first 的默认目标

在 OpenCode 里，优先同步这四层：

| 层级 | 默认位置 | 受众 | 职责 |
|---|---|---|---|
| Workspace 运行配置 | `.opencode/opencode.json`、`.opencode/skills/`、`.opencode/tools/` | 当前工作客户端 / agent 运行时 | MCP、skill、tool、workspace wiring |
| 项目级 agent 指南 / 记忆文件 | **与当前任务路径相关的 `AGENTS.md` 链**（项目根 + 相关子目录） | 当前项目内的 AI 协作者 | 结构、边界、流程、红线、局部工作记忆 |
| 人类文档 | `README.md`、`docs/`、handoff / runbook / architecture | 人类同事、下游开发者、未来接手者 | 怎么用、怎么运维、怎么理解 |
| 其他平台文件（可选） | `CLAUDE.md`、`.codex/`、`~/.config/opencode/`、`~/.claude/` 等 | 混合客户端场景 | 仅在项目真实使用时同步 |

**默认不要把 Claude/Codex 的路径当成主线。** 当前工作区如果是 OpenCode-first，就先把 `.opencode/`、**相关路径链上的 `AGENTS.md`**、`README.md`、`docs/` 这套查全。

### 记忆文件在这里是什么意思

在这个 skill 里，**OpenCode-first 项目的“记忆文件”默认就是 `AGENTS.md`，而且是分层的 `AGENTS.md` 链**，不是单独的 `MEMORY.md` 目录系统。

- **根 `AGENTS.md`**：全项目通用记忆 / 总规则
- **子目录 `AGENTS.md`**：该目录及其后代的局部记忆
- **离当前工作目标更近的 `AGENTS.md` 优先**
- **父级负责通用基线，子级只补局部差异，不重复抄全文**
- 如果当前任务只涉及 `packages/app/`，就把 `/<root>/AGENTS.md` + `packages/AGENTS.md`（若有）+ `packages/app/AGENTS.md`（若有）视为这次任务的记忆链

也就是说：**子 `AGENTS.md` 就是记忆文件**。它不是附属说明，而是该作用域下 agent 应继承的项目记忆。

## 执行流程

### 第一步：盘点现状（强制枚举，不能跳过）

先确认当前项目到底是不是 OpenCode-first；如果没有反证，按 OpenCode-first 处理。

对本次对话涉及的**每一个项目 / 工作区**，至少检查：

1. 工作区配置：
   - `.opencode/opencode.json`
   - `.opencode/skills/`、`.opencode/tools/`（若存在或本次改动涉及）
2. 项目记忆文件 / 知识文件：
   - 对每个受影响路径，**枚举从项目根到目标目录路径链上的所有 `AGENTS.md`**
   - 先读父级，再读子级，记录哪些是本次任务的有效记忆链
   - `README.md`
   - `docs/` 下全部 markdown（没有也要确认缺失）
   - 根目录和相关子目录散落的关键 `.md`
3. 若项目明确混用其他客户端，再补查对应文件：
   - `CLAUDE.md`
   - `.codex/`、`AGENTS.override.md`、`TEAM_GUIDE.md`
   - `~/.config/opencode/`、`~/.claude/`、`~/.codex/`、`~/.openclaw/` 中**与当前任务直接相关**的配置
4. 回顾本次对话全部内容

**必须在内部列一张清单**：每个已评估文件 / 配置都标记为「已评估 / 要改 / 不用改」。对 `AGENTS.md` 要额外标清它在记忆链里的层级（根 / 子级 / 最近作用域）。漏一个就可能把同步做残。

### 第二步：识别影响面——不要只盯 markdown

看的是**变更会波及哪些知识层**，不是只看“新增了什么事实”。

常见模式：

- 新增 API / 路由 → **相关 `AGENTS.md` 记忆链** + integration-guide + architecture
- 新增 / 改名 环境变量 → **相关 `AGENTS.md` 记忆链** + runbook + README / integration-guide
- 新增数据库表 → **相关 `AGENTS.md` 记忆链** + architecture Data Model
- 新增大特性 → 以上全部 + handoff / CHANGELOG
- MCP / tool / skill / workspace wiring 变化 → `.opencode/opencode.json` 或对应本地条目 + 根 `README.md` + **相关 `AGENTS.md`**
- 跨项目改动 → 上下游两边的 docs **都要对齐**
- 记忆 / 指令层面 → 在**相关 `AGENTS.md` 记忆链**里做相对时间改绝对日期、过期事实修正、重复内容合并、废弃内容删除

更完整的映射见 **[references/sync-matrix.md](references/sync-matrix.md)**。

### 第三步：实际修改（必须真的动手）

你必须**真的使用当前平台可用的读写工具完成修改**，不能只描述“应该怎么改”。

- 改 markdown：用实际文件编辑工具
- 改 OpenCode workspace wiring：优先使用平台提供的 workspace 配置 / MCP / skill / tool 写入能力；没有专用入口时再直接改文件
- 删除废弃条目：直接删，不要留“已废弃但先放着”

**顺序建议**：

1. `README.md` / `docs/`（外部读者先对齐）
2. **相关 `AGENTS.md` 记忆链**（当前项目内 AI 的工作约束与局部记忆）
3. `.opencode/` 配置与本地 skill/tool 条目
4. 其他客户端或全局文件（仅在确实相关时）

### 第四步：编辑原则

- **合并优于追加**：更新旧条目，不要平铺一串历史版本
- **删除优于保留**：完成的临时计划、推翻的结论、死配置要删
- **精确优于冗长**：一句话只承载一件事
- **绝对时间**：写 `2026-05-02`，不要写“今天”“最近”
- **受众不混**：`AGENTS.md` 写给 agent，`README.md` / `docs/` 写给人，`.opencode/opencode.json` 写给运行时
- **记忆按作用域分层**：通用规则放父级 `AGENTS.md`，局部流程 / 局部约束 / 局部命令放最近的子 `AGENTS.md`
- **最近优先，但不是全量覆盖**：子级 `AGENTS.md` 优先解释局部差异，父级仍是默认基线
- **OpenCode 配置不是笔记本**：`.opencode/` 里只放稳定的运行配置，不往里塞自由文本结论
- **全局配置极度克制**：除非用户明确要改跨项目原则，否则不要动 `~/.config/opencode/`、`~/.claude/`、`~/.codex/` 一类全局文件
- **子 `AGENTS.md` 默认只在已有且相关时更新**：除非用户明确要求，或父级规则已声明该子树需要独立记忆文件，否则不要随手新建一堆子 `AGENTS.md`

### 第五步：自检清单

改完后逐项检查：

- [ ] 第一步列出的每个文件 / 配置，都标了“不用改”或“已改”
- [ ] 对当前任务路径链上的每个 `AGENTS.md`，都判断了“继承即可 / 要改 / 不适用”
- [ ] `.opencode/opencode.json` 里被触及的 MCP / tool / skill wiring 与实际现状一致
- [ ] `AGENTS.md` 记忆链里提到的路径、命令、工具、环境变量真实存在
- [ ] `README.md` 的安装 / 运行 / 接入步骤跟代码或当前工作区现状一致
- [ ] 新增 API / 路由：**integration-guide 和 architecture 都有**
- [ ] 新增环境变量：**runbook 和项目级 agent 指南都提到**
- [ ] 新增数据库表：**architecture 的 Data Model 和项目级 agent 指南都提到**
- [ ] 跨项目影响：下游项目的文档也补了
- [ ] 没有相对时间遗留（如“今天”“最近”“today”“recently”）
- [ ] 没有死掉的 `.opencode` skill / tool / MCP 引用残留在文档里

打不了勾就回去补，不要“差不多”。

### 第六步：给用户摘要

所有修改完成后，再给用户简洁摘要：

```md
## 同步完成

### OpenCode 工作区配置
- 更新：.opencode/opencode.json — xxx
- 更新：.opencode/skills/<name>/SKILL.md — xxx

### Agent 指南
- 更新：<path>/AGENTS.md — xxx
- 更新：<path>/subdir/AGENTS.md — xxx

### 文档变更
- 更新：README.md — xxx
- 更新：docs/architecture.md — xxx

### 未处理
- xxx（为什么没处理）
```

只列**实际改过**的项。

## 特殊情况

- **没有新事实**：仍要检查现有文档 / 配置是否过期、冲突、失效
- **项目还没有 `README.md` 或 `AGENTS.md`**：`README.md` 可按原规则判断是否创建；`AGENTS.md` 尤其是子 `AGENTS.md`，默认只在用户明确要求、或父级规则已声明该子树需要独立记忆文件时创建，否则在摘要里说明为何未创建
- **混合客户端项目**：保持兼容，但不要让次要客户端文件反客为主
- **出现无法自动判断的冲突**：列入“未处理”并请用户决策
- **发现过去同步漏改**：直接补，不要因为“不是这次改的代码”就跳过

## 参考资料

- **[references/sync-matrix.md](references/sync-matrix.md)** — 变更类型 → 应同步的知识层
- **[references/agent-paths.md](references/agent-paths.md)** — OpenCode-first 路径速查，含其他客户端 fallback
