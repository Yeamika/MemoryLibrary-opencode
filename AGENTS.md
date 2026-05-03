# Workspace 元文件

## 作用范围

- 适用于当前 workspace 根目录。
- 这里是一个 workspace meta repo，用于维护工作区记忆与 `.opencode/` 元资产，不是单一产品源码目录。
- 具体实现变更优先放到对应子项目中完成；子项目保留各自 git 历史。

## `.opencode/` 文件夹

- `.opencode/` 是当前 OpenCode workspace 的元资产目录，也是一个可热重载的上下文系统。
- 这里用于存放工作区级的 agent、skills、tools、文档与运行时配置。
- 具体目录说明见 `.opencode/AGENTS.md`。

## `AGENTS.md` 树（渐进式披露）

```text
AGENTS.md
└── .opencode/AGENTS.md
    └── .opencode/docx/AGENTS.md
```

- 根 `AGENTS.md`：workspace 总记忆。
- `.opencode/AGENTS.md`：OpenCode 元目录记忆。
- `.opencode/docx/AGENTS.md`：OpenCode 长文档与 demo 记忆。
- 读取时按父 → 子渐进式披露，越近越具体。

## `AGENTS.md` 作为记忆

- `AGENTS.md` 是当前作用域的记忆文件，不是普通说明文档。
- 结构、边界、流程、命名约定变化时，应同步更新对应作用域的 `AGENTS.md`。
- 长说明与实例优先放 `.opencode/docx/`。

## 活动边界

- 默认只在记忆图书馆核心区工作：根 `AGENTS.md`、根 `README.md`、`WORKSPACE_MAP.md`、`.opencode/`。
- `OpenSessionGateway/`、`Yeamika/`、`nextcloud-mcp-tool/`、`migration/` 属于子项目或外部工作区；除非任务明确要求，否则不要进入这些目录修改内容。
- `.config/`、`.tmp/`、`.opencode/artifacts/` 和根目录打包产物属于本地运行态或临时产物；除非任务明确要求，否则不要把它们当作记忆文件维护对象。
- 如果任务需要跨出记忆图书馆核心区，应先说明将进入哪个目录、为什么需要进入，再继续执行。

## `TASKS.md`

- `TASKS.md` 用于当前目录的动态任务清单，不属于稳定记忆。
- 需要共享任务进度时，应在对应目录维护 `TASKS.md`，并按“进行中 / 堵塞中 / 已完成 / 待处理”组织。
- agent 开始该目录工作前，应先更新对应 `TASKS.md`；完成后及时同步状态。
- 不把动态任务清单写进 `AGENTS.md`，避免污染会被自动注入的上下文。
- 推荐条目模板：`[logo]任务标题——当前状态[ses_xxx]`
- 其中 `[ses_xxx]` 表示当前占线、正在执行或最后更新该条目的会话。
- 推荐 `logo`：`[🔄]` 进行中、`[⛔]` 堵塞中、`[✅]` 已完成、`[⏳]` 待处理。
- `[🔄]` 进行中任务只需要更新 `TASKS.md` 占位即可，不要求立即 commit。
- `[⛔]` 堵塞中、`[✅]` 已完成、`[⏳]` 待处理任务在更新 `TASKS.md` 后应提交一次 commit，并在 commit 中写明原因、结果或待处理说明。

```md
# 任务清单

## 进行中
- [🔄] 编写测试脚本——正在进行中[ses_xxx]

## 堵塞中
- [⛔] 编写测试脚本——等待测试环境恢复[ses_xxx]

## 已完成
- [✅] 编写测试脚本——已完成并通过验证[ses_xxx]

## 待处理
- [⏳] 编写测试脚本——待处理[ses_xxx]
```

## Git 提交

- 根 meta repo 只跟踪 workspace 级记忆与 `.opencode/` 元资产。
- 每次有意义的更改后，都可以单独提交一次 commit。
- 提交时默认使用当前 agent 名称作为提交身份；如果当前环境不能单独设置 author，至少在 commit message 中显式带上 agent 名称。
