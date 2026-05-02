# Agent 路径速查（OpenCode-first）

默认先按 **OpenCode** 查；只有项目明确混用其他客户端时，才继续补查对应平台文件。

## OpenCode（默认主线）

| 用途 | 路径 |
|---|---|
| 全局配置 | `~/.config/opencode/` |
| 工作区配置 | 项目根 `.opencode/opencode.json` |
| 本地 skills | `.opencode/skills/<name>/SKILL.md` |
| 本地 tools | `.opencode/tools/` |
| 项目级 agent 指南 / 记忆文件 | **路径链上的 `AGENTS.md`**（项目根 + 相关子目录，可层级嵌套） |
| 人类文档 | `README.md`、`docs/` |
| 兼容扫描的 skill 目录 | `.claude/skills/`、`.codex/skills/`、`~/.claude/skills/`、`~/.codex/skills/` |

要点：

- OpenCode **没有 Claude 式独立 memory 目录**；跨会话项目知识默认落在**相关路径链上的 `AGENTS.md`**、`README.md`、`docs/` 和稳定的 `.opencode` 配置中
- `.opencode/opencode.json` 是运行配置，不是自由笔记本；只记录稳定 wiring，不记录临时结论
- 如果当前任务涉及 MCP / skills / tools，除了读文件，也要核对当前工作区实际加载状态

### OpenCode 里的“记忆文件”到底是什么

在 OpenCode-first 工作流里，`AGENTS.md` 不是单纯说明文，而是**项目记忆文件**：

- **根 `AGENTS.md`** = 全局项目记忆 / 共通约束
- **子目录 `AGENTS.md`** = 局部记忆文件，覆盖该目录子树的局部规则
- **记忆读取顺序** = 从父到子
- **生效优先级** = 离当前目标最近的 `AGENTS.md` 优先，但父级默认仍生效

因此，当任务落在某个子目录时，要把**沿路径遇到的所有 `AGENTS.md`** 当成这次任务的记忆链，而不是只看根文件。

## Claude Code（仅在项目真实使用时补查）

| 用途 | 路径 |
|---|---|
| 跨会话记忆（全局） | `~/.claude/projects/<encoded-project-path>/memory/` |
| 记忆索引文件 | `~/.claude/projects/<...>/memory/MEMORY.md` |
| 全局指令 | `~/.claude/CLAUDE.md` |
| 项目级指令 | 项目根 `CLAUDE.md`（可层级嵌套） |
| Skills 目录 | `~/.claude/skills/<name>/SKILL.md` |

记忆文件通常带 YAML frontmatter：`name`、`description`、`type`。

## OpenAI Codex（仅在项目真实使用时补查）

| 用途 | 路径 |
|---|---|
| 跨会话指令（全局） | `~/.codex/AGENTS.md` 或 `$CODEX_HOME/AGENTS.md` |
| 项目级指令 | 项目根 `AGENTS.md`（可层级嵌套） |
| 项目级 override | `AGENTS.override.md` |
| Skills 目录 | `~/.codex/skills/<name>/SKILL.md` 或项目内 `.codex/skills/<name>/` |

Codex 没有独立 memory 索引；项目事实通常直接维护在 `AGENTS.md`，也可按目录层级拆分。
如果项目里有 `TEAM_GUIDE.md` 或 `.agents.md`，也一并检查。

## OpenClaw（仅在项目真实使用时补查）

| 用途 | 路径 |
|---|---|
| 用户级 skills | `~/.openclaw/skills/<name>/SKILL.md` |
| 项目级 skills | `.openclaw/skills/<name>/SKILL.md` |
| Workspace skills | 当前 workspace 的 `skills/` 目录 |

OpenClaw 也没有独立 memory 索引；项目知识通常仍落在项目根 markdown 中。

## 如果当前 agent 没有独立记忆系统

跳过“记忆目录”检查，把精力放在：

- 项目级 agent 指南 / 记忆链（`AGENTS.md` / `CLAUDE.md` / 等价文件）
- `README.md`
- `docs/`
- 当前客户端实际生效的 workspace / project 配置

这仍然是有效同步；文档和项目级指令才是最低保障。

## 混合客户端共存策略

如果项目长期同时服务多个客户端：

- 保留一个**主权威体系**（例如 `AGENTS.md` 记忆链或 `CLAUDE.md` 体系）
- 其他平台文件只保留最小跳转或同步副本，避免三份内容各写各的
- `README.md` 和 `docs/` 保持平台中立，不拆多份
