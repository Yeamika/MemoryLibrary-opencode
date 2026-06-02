---
name: opencode-test-before-gha
description: 在触发 opencode GitHub Actions / local publish 前运行本地回归与类型检查，确保请求里带上可复现验证结果。
---

# opencode-test-before-gha

用于 `Yeamika/opencode/pr-reload` 这类 opencode 发布/触发 GHA 前的本地验证流程。

## 适用场景

- 准备推送分支并触发 GitHub Actions。
- 准备请求 maintainer 执行 `opencode local publish`。
- opencode 代码已有提交或即将提交，需要先给出本地测试结果。

## 基本规则

- 在 opencode repo 根目录确认 `git status --short`，不要把 `.tmp/`、下载产物或无关文件纳入提交/发布请求。
- 测试命令默认在 `packages/opencode` 下运行。
- 先跑与改动相关的定向测试，再跑类型检查。
- 任一测试或类型检查失败时，停止 GHA/publish 请求，先报告 blocker。
- 发布请求或 mailbox 里必须写明实际运行过的命令和结果。

## 推荐命令

从 repo 根目录进入包目录：

```bash
cd /workspace/OSG-Project/Yeamika/opencode/pr-reload/packages/opencode
```

远端执行器、read/hashline、exbash、搜索工具、snapshot 相关改动，优先运行：

```bash
bun test \
  test/tool/read_remote.test.ts \
  test/tool/exbash.test.ts \
  test/tool/remote_path.test.ts \
  test/server/exbash-snapshot.test.ts \
  test/tool/grep.test.ts
```

然后运行：

```bash
bun typecheck
```

## 按改动追加的测试

- LSP 配置/生命周期：`bun test test/lsp/lifecycle.test.ts test/lsp/index.test.ts`
- patch / apply_patch / REC metadata：`bun test test/tool/apply_patch.test.ts`
- session processor / retry 状态：`bun test test/session/processor-effect.test.ts`
- TUI shell / PTY attach 行为：按相关文件补充 `test/cli/tui/...` 下的对应测试。

## 请求 GHA / publish 前检查

在发送请求前记录：

```bash
git status --short
git log --oneline origin/pr/reload-soft-workspace-clean..HEAD
```

请求内容至少包含：

- repo 路径与分支；
- HEAD 或待发布 commit 列表；
- 已运行的 `bun test ...` 命令；
- `bun typecheck` 结果；
- `.tmp/` 未提交、仅作本地产物目录的说明（如存在）。
