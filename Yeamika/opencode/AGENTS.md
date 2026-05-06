# opencode 家族共享记忆

## 作用范围

- 适用于 `Yeamika/opencode/` 及其子目录；更深层 `AGENTS.md` 优先。

## 目录定位

- 这里是 opencode 家族工作树的大根，不是单一 worktree 仓库。
- 当前子目录如 `local-yes/`、`pr-attach-min/`、`pr-reload/`、`upstream/` 应按各自独立 worktree / repo 处理。

## 工作规则

- 进入具体 worktree 前，先读本文件，再读目标 worktree 最近的 `AGENTS.md`。
- opencode 家族共享约定放在本文件；某个 worktree 独有的编码、测试、branch、实验性流程，放回对应子 `AGENTS.md`。
- 不要把单个 worktree 的局部规则反向堆回本文件。

## 共享发布

- 跨项目共享的 Verdaccio / registry 约定见 workspace 根目录 `docs/workspace-publish-registry.md`。
- opencode 家族本地发包优先使用 `verdaccio-publish-opencode`；整体验证与发布链路优先使用 `release-local`。

## Worktree / Branch 摘要

- `local-yes/` → branch `local-yes`
  - 用途：承载本地集成、发布链路和环境相关验证的工作树。
  - 当前状态：最近用于构建 / 发布链路相关调整与验证；更细动态进度看对应提交历史或后续 `TASKS.md`。
- `pr-attach-min/` → branch `pr/attach-minimal`
  - 用途：承载 attach / detached TUI / 最小接入链路相关改动与验证。
  - 当前状态：最近吸收 detached TUI config / instance lookup 相关修正；局部动态进度应留在该 worktree 自己的任务清单里。
- `pr-reload/` → branch `pr/reload-soft-workspace-clean`
  - 用途：承载 reload、workspace clean、权限模型与相关回归验证。
  - 当前状态：已吸收 exbash / exbash_executor、workspace 权限与会话环境相关改动；详细动态进度见 `pr-reload/TASKS.md`。
- `upstream/` → branch `dev`
  - 用途：保持上游 `dev` 基线，作为对照和同步参考工作树。
  - 当前状态：默认不混入私有实验性改动；如果某项规则只适合上游基线，应在这里验证后再决定是否向其他 worktree 扩散。
