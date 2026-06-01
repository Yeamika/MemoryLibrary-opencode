# 任务清单

## 进行中

### GVMM 团队结构（GlassVein Endpoint 管理）

| 角色 | 会话 ID | 负责端点 | 状态 |
|------|---------|----------|------|
| **项目经理** | | | |
| GVMM | ses_197d4b582ffed8eMvRJj2WUXQV | 全局协调 | 活跃 |
| **监工 (GVS)** | | | |
| GVS-Console | ses_197cc56f9ffe6G51tx0ESCtYOV | endpoints/console/ | ✅ 已创建 GVW |
| GVS-Requestion | ses_197cc3c5bffe65OMp5rTxgFlFl | endpoints/requestion/ | ✅ 已创建 GVW |
| GVS-IM | ses_197cc2231ffeHFo04D6yKoXmag | endpoints/im/ | ✅ 已创建 GVW |
| GVS-Mailbox | ses_197cc0974ffeDnn5CczILmP2Mj | endpoints/mailbox/ | ✅ 已创建 GVW |
| GVS-SessionControl | ses_197cbebe1ffeKMerR8Q1mhBq8F | endpoints/session-control/ | ✅ 已创建 GVW |
| GVS-Timer | ses_197cbebdaffe2MWTcvuBhMkoEk | endpoints/timer/ | ✅ 已创建 GVW |
| **工人 (GVW)** | | | |
| GVW-Console | ses_197cb3668ffeTTGbam7gnKQFGm | endpoints/console/ | 活跃 |
| GVW-Requestion | ses_197c97e6effe9QbP7LiX31Mu83 | endpoints/requestion/ | 活跃 |
| GVW-IM | ses_197cb17e9ffecWFYZejjjYfgGP | endpoints/im/ | 活跃 |
| GVW-Mailbox | ses_197cb1046ffeg9W3K57vYiJZ2N | endpoints/mailbox/ | 活跃 |
| GVW-SessionControl | ses_197c9cfacffeCSWdQsdThaJQYW | endpoints/session-control/ | 活跃 |
| GVW-Timer | ses_197cb0984ffeGGwJnXlQV9aWIE | endpoints/timer/ | 活跃（TS→Rust 迁移） |

**职责划分：**
- GVMM：任务分派、跨端点协调、最终验收
- GVS-{Name}：文档整理、验收检查、定时巡检、进度汇报
- GVW-{Name}：只改代码，接收 mailbox 任务

## 堵塞中

## 已完成
- [✅] 建立 GVMM 团队结构——6 个 GVS 监工 + 7 个 GVW 工人（含 Cleanup）[GVMM]
- [✅] 清理弃用端点目录——已删除 `control/`、`viewer/`、`session/`[GVW-Cleanup]
- [✅] Console Endpoint 任务 #1 验收——边界条件测试 28 个 + README.md 文档[GVS-Console]
- [✅] 收口 opencode 叶子提交噪音——已在四个 worktree 中将 `AGENTS.md` 标记为 `skip-worktree`；叶子文件仍归各子 repo 管理[ses_hr]
- [✅] 设立 opencode 家族大根记忆——已新增 `Yeamika/opencode/AGENTS.md` 并把共享发布提示从 worktree 上提[ses_hr]
- [✅] 收口 shared registry 记忆——已将跨项目共用的 Verdaccio / registry 细节收束到 workspace `docs/`，子项目 `AGENTS.md` 仅保留入口提示[ses_hr]
- [✅] 收口 `.opencode` 记忆边界——已将运行环境细节下沉到最近子项目 `AGENTS.md`[ses_hr]
- [✅] 收口 AGENTS 记忆层级——已将根规则收束为全局基线，并把项目细则下沉到更近的子目录 AGENTS[ses_hr]
- [✅] 收紧 workspace 权限基线——已收口全局 edit/exbash 基线，并给 HR 开放全文件编辑[ses_hr]
- [✅] 根目录记忆规则收束——已同步 `.opencode/` 与 `.tmp/` 的维护规则[ses_xxx]
- [✅] 收束 migration 归属——已移除根目录符号链接并确认真实目录位于 `Yeamika/opencode/pr-reload/packages/opencode/migration/`[ses_xxx]
- [✅] 根目录收束整理——已完成根目录混合层级清理与边界收口[ses_xxx]
- [✅] 收束本地运行目录——已完成 `tmp` 改名、`.workerspace` 清理与 `artifacts/` 删除[ses_xxx]

## 待处理
- [⏳] 校对重建 agent 文件——待人工确认 `install-local`、`container-manager`、`catgirl` 是否与原版一致[ses_xxx]
