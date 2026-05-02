# Workspace Git / Memory Map

This workspace uses a **root meta repo** plus multiple **child repos/worktrees**.

## Root meta repo purpose

The root git repo at `/workspace/OSG-Project/.git` is the workspace control plane.
It tracks:

- root `AGENTS.md` — workspace-wide memory baseline
- root `README.md` — workspace topology and operator notes
- `WORKSPACE_MAP.md` — repo ownership and memory routing
- `.opencode/skills/` and `.opencode/tools/` — local OpenCode skill/tool definitions
- `agent-skills/` — prompt and skill experiments that belong to the workspace itself

It does **not** absorb child project source history.

## Memory model

For this workspace, `AGENTS.md` files are memory files.

- root `AGENTS.md` = workspace-level memory baseline
- child `AGENTS.md` = scoped memory for that repo / directory subtree
- when both exist, read from parent to child
- the nearest relevant `AGENTS.md` carries the most specific local rules
- use the git history of the repo that owns that `AGENTS.md`

Do **not** duplicate a child repo's `AGENTS.md` into the root repo just to mirror history.

## Ownership table

| Path | Git owner | Memory source | Notes |
|---|---|---|---|
| `/workspace/OSG-Project/` root docs | root meta repo | root `AGENTS.md` | workspace-level rules only |
| `.opencode/skills/` | root meta repo | root `AGENTS.md` + skill files | local OpenCode skills |
| `.opencode/tools/` | root meta repo | root `AGENTS.md` | local OpenCode tools if added later |
| `agent-skills/` | root meta repo | root `AGENTS.md` | prompt / skill experiments |
| `OpenSessionGateway/` | child repo | `OpenSessionGateway/**/AGENTS.md` chain | standalone project repo |
| `nextcloud-mcp-tool/` | child repo | `nextcloud-mcp-tool/**/AGENTS.md` chain | standalone project repo |
| `Yeamika/opencode/upstream/` | child repo | `upstream/**/AGENTS.md` chain | upstream opencode repo |
| `Yeamika/opencode/local-yes/` | child repo | `local-yes/**/AGENTS.md` chain | local fork/work copy |
| `Yeamika/opencode/pr-reload/` | child repo | `pr-reload/**/AGENTS.md` chain | main working repo for this branch |
| `Yeamika/opencode/pr-attach-min/` | `pr-reload` worktree | `pr-attach-min/**/AGENTS.md` chain | linked worktree owned by `pr-reload` git dir |
| `tmp/`, `.config/`, `.workerspace/` | local-only, ignored by root meta repo | n/a | runtime / secret / disposable state |

## How to read memory history

### Root memory

```bash
git -C /workspace/OSG-Project log --follow -- AGENTS.md
git -C /workspace/OSG-Project show <commit>:AGENTS.md
```

### Child repo memory

```bash
git -C /workspace/OSG-Project/OpenSessionGateway log --follow -- doc/AGENTS.md
git -C /workspace/OSG-Project/Yeamika/opencode/pr-reload log --follow -- packages/app/AGENTS.md
git -C /workspace/OSG-Project/Yeamika/opencode/pr-attach-min log --follow -- packages/app/AGENTS.md
```

## Root repo guardrails

- keep root history focused on workspace memory, docs, prompts, and local automation
- do not track child repo source trees from the root repo
- do not commit secrets or account config from `.config/`
- keep disposable output in `tmp/` or other ignored paths
- when a task belongs to a child repo, commit memory there instead of copying it upward
