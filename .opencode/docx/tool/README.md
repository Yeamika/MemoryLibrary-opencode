# OpenCode Tool 配置说明

本文说明 **`.opencode/tools/`** 下的本地工具文件怎么写、怎么被扫描、什么时候该用 `workspaceTool` 和 `reload`。

## 0. 当前 agent 侧的实际操作方式

按当前 OpenCode 客户端里 agent 可见的控制面，tool 的真实操作顺序应优先写成这样：

```text
workspaceTool({ mode: "read", scope: "local" })
workspaceTool({ mode: "write", filePath: "/abs/path/to/tool.ts" })
reload()
workspaceOverview({ scope: "local" })
```

补充规则：

- `workspaceTool.read` 可以看 `local` 或 `global`
- `workspaceTool.write` / `delete` 只应改当前工作区的 `local`
- 本地写入或删除 tool 后，应立刻 `reload`
- reload 后，再用 `workspaceOverview(local)` 或再次 `workspaceTool.read` 验证是否生效
- `workspaceOverview` / `workspaceTool.read` 验证的是**工作区装载状态**，不等于当前 agent 所在 session 一定已经能直接调用该 tool

## 1. 源码里的实际行为

- OpenCode 会扫描 `.opencode/{tool,tools}/*.{js,ts}`
- 默认只扫描**顶层** `.js` / `.ts` 文件
- 默认**不递归扫描**更深层目录
- 工具模块的导出方式会影响最终工具 ID：
  - `export default { ... }` → 工具 ID 默认取文件名
  - `export const foo = { ... }` → 工具 ID 变成 `<文件名>_foo`

## 2. 推荐目录结构

```text
.opencode/tools/
  list-workspace-agents.ts
  sync-memory-index.ts
```

## 3. 什么时候该用 tool

适合 tool 的内容：

- 需要稳定输入 / 输出的可调用接口
- 需要被 agent 直接当作工具调用的能力
- 相比 skill，更偏“执行接口”而不是“工作流说明”

不适合 tool 的内容：

- 主要给人读的流程说明 → 更适合 skill
- 长期角色身份 → 更适合 agent

## 4. 新增 tool 的步骤

1. 先用 `workspaceTool({ mode: "read", scope: "local" })` 看当前工作区已有 tool
2. 在工作区外或临时位置准备一个 `.ts` / `.js` 文件
3. 编写工具导出
4. 如需第三方依赖，更新同级 `.opencode/package.json`
5. 用 `workspaceTool({ mode: "write", filePath: "/abs/path/to/tool.ts" })` 写入
6. 执行 `reload()`
7. 再用 `workspaceOverview({ scope: "local" })` 或 `workspaceTool.read` 检查工具是否出现

## 5. 最小骨架

```ts
export default {
  description: "<一句话说明工具用途>",
  args: {},
  execute: async () => {
    return "<工具输出>"
  },
}
```

## 6. 依赖说明

- 如果工具顶层 `import` 第三方依赖，应写进同级 `.opencode/package.json`
- OpenCode 会等待依赖安装完成后再加载自定义工具

## 7. 示例文件

请看同目录下的：

- `demo-echo_dir.ts`

这个文件对齐的是 OpenCode reload 测试里使用的最小 tool 结构。

它展示的是一个真正可加载的 workspace tool，而不是另外编出来的占位骨架。
