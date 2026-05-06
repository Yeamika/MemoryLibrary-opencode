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
