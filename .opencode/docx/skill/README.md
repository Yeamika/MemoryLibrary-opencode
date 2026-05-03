# OpenCode Skill 配置说明

本文说明 **`.opencode/skills/`** 下的 skill 目录怎么组织、`SKILL.md` 怎么写、什么时候该配 `references/` 或 `scripts/`。

## 0. 当前 agent 侧的实际操作方式

按当前 OpenCode 客户端里 agent 可见的控制面，skill 的真实操作顺序应优先写成这样：

```text
workspaceSkill({ mode: "read", scope: "local" })
workspaceSkill({ mode: "write", directoryPath: "/abs/path/to/skill-dir" })
reload()
workspaceOverview({ scope: "local" })
```

补充规则：

- `workspaceSkill.read` 可以看 `local` 或 `global`
- `workspaceSkill.write` / `delete` 只应改当前工作区的 `local`
- 本地写入或删除 skill 后，应立刻 `reload`
- reload 后，再用 `workspaceOverview(local)` 或再次 `workspaceSkill.read` 验证是否生效
- `workspaceOverview` / `workspaceSkill.read` 验证的是**工作区装载状态**，不等于当前 agent 所在 session 一定已经能看到该 skill

## 1. 源码里的实际行为

- OpenCode 会扫描 `.opencode/{skill,skills}/**/SKILL.md`
- `SKILL.md` frontmatter 至少应稳定提供：
  - `name`
  - `description`
- `SKILL.md` 正文会被加载为 skill 内容
- skill 的实际名称来自 `name`，**不是目录名**
- 如果两个 skill 的 `name` 相同，后加载的 skill 会覆盖先前同名 skill，并产生重复警告

## 2. 推荐目录结构

```text
.opencode/skills/
  tidy-workspace-map/
    SKILL.md
  sync-memory/
    SKILL.md
    references/
      sync-matrix.md
    scripts/
      publish.sh
```

## 3. 什么时候该用 skill

适合 skill 的内容：

- 会重复执行的工作流
- 可以写成“何时使用 → 步骤 → 输出要求”的流程
- 需要复用的整理、发布、检查、同步、巡检逻辑

不适合 skill 的内容：

- 长期角色身份定义 → 更适合 `agent/`
- 机器可调用接口 → 更适合 `tools/`

## 4. 新增 skill 的步骤

1. 先用 `workspaceSkill({ mode: "read", scope: "local" })` 看当前工作区已有 skill
2. 在工作区外或临时位置准备一个 skill 目录，目录里放好 `SKILL.md`
3. 如需长表格、参考材料，补 `references/`
4. 如需 helper 脚本，补 `scripts/`
5. 用 `workspaceSkill({ mode: "write", directoryPath: "/abs/path/to/skill-dir" })` 写入
6. 执行 `reload()`
7. 用 `workspaceOverview({ scope: "local" })` 或再次 `workspaceSkill.read` 验证

## 5. 最小模板

```md
---
name: <skill-name>
description: <一句话描述 skill 用途>
---

# <Skill 标题>

## 何时使用
- 

## 执行步骤
1. 
2. 
3. 

## 输出要求
- 
```

## 6. 示例文件

请看同目录下的：

- `demo-reload-demo-skill-SKILL.md`

这个文件对齐的是 OpenCode reload 测试里使用的最小 skill 结构。

它适合用来展示：最小 `SKILL.md` 长什么样、workspace skill demo 一般怎么写。
