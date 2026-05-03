# OpenCode MCP 配置说明

本文说明 `.opencode/opencode.json` 里的 `mcp` 条目怎么组织、什么时候应该走 `workspaceMcp`、什么时候普通 reload 不够。

## 0. 当前 agent 侧的实际操作方式

按当前 OpenCode 客户端里 agent 可见的控制面，MCP 的真实操作顺序应优先写成这样：

```text
workspaceMcp({ mode: "read", scope: "local" })
workspaceMcp({ mode: "write", name: "demo", value: "{\"type\":\"remote\",\"url\":\"http://host.docker.internal:8811/mcp\"}" })
reload()
workspaceOverview({ scope: "local" })
```

补充规则：

- `workspaceMcp.read` 可以看 `local` 或 `global`
- `workspaceMcp.write` / `delete` 只应改当前工作区的 `local`
- `value` 传的是**一个 JSON 对象字符串**，不是整个 `opencode.json`
- 本地写入或删除 MCP 后，应立刻 `reload`
- reload 后，再用 `workspaceOverview(local)` 或再次 `workspaceMcp.read` 验证是否生效
- `workspaceOverview` / `workspaceMcp.read` 验证的是**工作区装载状态**，不等于当前 agent 所在 session 一定已经能看到该 MCP 相关能力

## 1. MCP 放在哪里

- MCP 条目通常写在 `.opencode/opencode.json` 的 `mcp` 字段下
- `mcp/` 这个文档目录本身只是**说明区和 demo 区**，不是实际运行时读取目录

## 2. 推荐做法

优先顺序：

1. 用已授权控制面 `workspaceMcp` 读写条目
2. 变更后执行 `reload`
3. 再用 overview / 状态检查确认是否已生效

原因：

- 这样更贴合当前平台支持的路径
- 也更容易保持文件状态和运行状态一致

## 3. 什么时候 reload 不够

默认要把 `reload` 理解成**热重载**：

- 它会刷新工作区视图和可重载配置
- 但**不会**替换当前上下文系统进程已经持有的环境变量
- 它也**不保证**当前 agent 所在 session 立刻获得新的工具可见性；如果 inventory 已更新但当前 agent 仍看不到相关能力，应将其视为会话 / 上下文可见性问题

如果 MCP 变更依赖：

- 新环境变量
- 新进程参数
- 真正的后台进程重启

那就不能假设普通 reload 一定足够，应明确提示这个限制。

## 4. 新增 MCP 的步骤

1. 先用 `workspaceMcp({ mode: "read", scope: "local" })` 看当前工作区已有 MCP
2. 确认条目名称
3. 准备 `type`、连接参数或命令参数，并整理成单个 JSON 对象字符串
4. 用 `workspaceMcp({ mode: "write", name, value })` 写入
5. 执行 `reload()`
6. 用 `workspaceOverview({ scope: "local" })` 或再次 `workspaceMcp.read` 检查状态

## 5. 示例文件

请看同目录下的：

- `demo-remote.json`

这个文件对齐的是 OpenCode reload 测试里使用的最小 MCP 条目结构。

它表示的是**单个 MCP 条目 value 对象**，适合直接拿去做 `workspaceMcp.write` 的 JSON 值参考。

如果你要把它放回 `.opencode/opencode.json`，再把这个对象挂到 `mcp.<name>` 下即可。
