---
name: npm-publish
description: npm / Verdaccio 发布辅助信息；由 Workflow-Runner 按流程文件调用。
---

# npm-publish

用于 npm / Verdaccio 发布步骤的辅助 skill。

规则：

- 只处理 npm publish 相关步骤，不负责下载、构建、安装、reload 或运行时验证。
- 优先按调用方给定的流程文件执行，不自行扩展流程。
- 发布前确认 registry、package 路径、version 和认证来源已明确。
- 不输出 token、password、cookie、`.npmrc`、registry auth 等敏感信息。
- 发布失败时停止并报告 blocker，不擅自改源码、改 git config、commit 或 force-push。
