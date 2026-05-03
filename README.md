# Workspace Memory Library

这个仓库是一个通用的 workspace meta repo，用于存放工作区级记忆文件与 `.opencode/` 元资产。

## 目标

- 维护根级 `AGENTS.md` 记忆
- 维护 `WORKSPACE_MAP.md` 的路径 / repo / memory 归属说明
- 维护 `.opencode/` 下的 OpenCode 元目录与客户端文档

## 典型结构

```text
/
├── AGENTS.md
├── README.md
├── WORKSPACE_MAP.md
└── .opencode/
    ├── AGENTS.md
    └── docx/
```

实际 workspace 根目录中仍可能同时存在子项目目录、本地配置目录与临时运行目录；这些内容不属于通用记忆库主体，也不应纳入根 meta repo 的维护主线。

## 不应该放什么

- 子项目产品源码
- 本地凭据、密码、token
- 临时运行垃圾与构建产物
- 只适用于单个私有环境的接线配置

## 使用方式

- 根 `AGENTS.md` 负责 workspace 级记忆
- `.opencode/AGENTS.md` 负责 OpenCode 元目录说明
- `.opencode/docx/` 负责长文档、配置方法与示例
- 目录级动态任务清单使用 `TASKS.md`，不写进 `AGENTS.md`
