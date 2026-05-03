# OpenCode 客户端文档目录说明

## 作用范围

- 本文件适用于当前工作区的 `.opencode/docx/` 目录及其子目录，除非更深层的 `AGENTS.md` 另有覆盖。

## 用途

- 这里用于存放 **OpenCode 客户端本身** 的长文档、配置说明、行为说明和实例文档。
- 如果主题是 `.opencode/` 配置方法、agent / skill / tool 的组织方式、reload 行为、memory 机制，且内容已经超出 `README.md` 或目录级 `AGENTS.md` 适合承载的长度，就放到这里。

## 放什么

- OpenCode 客户端配置方法
- `.opencode/` 目录结构说明
- agent / skill / tool / memory 的详细实例
- 面向协作者的上手资料、专题说明、长文参考

## 不放什么

- 子项目自己的业务文档
- 与 OpenCode 客户端无关的普通工作区杂项文档
- 密码、token、账号配置等敏感信息
- 临时聊天记录式笔记

## 使用规则

- 这里放“长文档”和“详细实例”，不替代上层 `.opencode/AGENTS.md` 的总规则作用。
- 如果某条规则必须稳定影响协作者行为，应同步回最近作用域的 `AGENTS.md`，不要只藏在长文里。
- 新增文档时，文件名尽量语义化，能从文件名直接看出主题。
- 如果某组长文档形成专题，可以在更深层目录继续使用 `AGENTS.md` 做局部说明。
- `demo-*` 文件默认应使用**真实可追溯的示例**：优先直接复制当前工作区真实文件，或复制 `Yeamika/opencode/pr-reload` 中已存在的测试 demo / fixture；不要再写脱离源码的玩具占位 demo。
- 如果真实示例里含有敏感信息，只保留结构并做最小必要脱敏，同时在对应 `README.md` 里写清楚来源路径。

## 当前推荐结构

```text
.opencode/docx/
  AGENTS.md
  README.md
  agent/
    README.md
    demo-subagent.md
  skill/
    README.md
    demo-reload-demo-skill-SKILL.md
  tool/
    README.md
    demo-echo_dir.ts
  mcp/
    README.md
    demo-remote.json
```

- `README.md` 用来解释该主题怎么读、怎么用、怎么配置。
- `demo-*` 文件用于提供可直接复制或改写的最小实例。
- 如果主题已经被拆到专题子目录，就不要再额外保留一份高度重复的总览长文。
