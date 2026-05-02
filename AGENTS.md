# OSG-Project Workspace Instructions

## Scope

- This file applies to `/workspace/OSG-Project`.
- The workspace root is a lab wrapper for multiple projects and tools, not a single deployable package.
- Prefer making implementation changes inside the relevant subproject instead of treating the root as the product source tree.

## Workspace Map

- `.opencode/` — workspace-local OpenCode config, installed skills, and local tools
- `.config/nextcloud_mcp.json` — Nextcloud MCP account config used by the workspace
- `OpenSessionGateway/` — main OpenSessionGateway codebase
- `Yeamika/` — local OpenCode forks / worktrees used in this lab
- `nextcloud-mcp-tool/` — local Nextcloud MCP server source
- `agent-skills/` — skill and prompt experiments
- `tmp/` — disposable artifacts and staging output

## Active Automation

- MCP servers: `osg_ssh`, `nextcloud`
- Local skills: `neat-freak`, `verdaccio-publish`, `verdaccio-publish-opencode`, `verdaccio-publish-osg`

## Workspace Git / Memory Context

- The workspace root now has its own **meta repo** at `/workspace/OSG-Project/.git`.
- That root repo tracks only workspace-level memory and local agent assets: root `AGENTS.md`, root `README.md`, `WORKSPACE_MAP.md`, `.opencode/skills/`, `.opencode/tools/`, and `agent-skills/`.
- Child project repos (`OpenSessionGateway/`, `nextcloud-mcp-tool/`, `Yeamika/opencode/*`) keep their own git history and are **not** absorbed into the root repo.
- In this workspace, **`AGENTS.md` files are memory files**:
  - root `AGENTS.md` = workspace-wide memory baseline
  - child `AGENTS.md` = scoped memory for that repo / directory subtree
  - when multiple apply, read from parent to child and let the nearest file provide the most specific local rules
- When a task belongs to a child repo, read that repo's `AGENTS.md` chain and use **that repo's git history** for memory lookup; do not copy the child memory into the root repo.
- See `WORKSPACE_MAP.md` for the path → repo → memory ownership map.

## Working Rules

- Update root `README.md` when container topology, MCP wiring, or root skill inventory changes.
- Update this file when the workspace structure, default working areas, or root-level guardrails change.
- Update `WORKSPACE_MAP.md` when root git scope, child repo ownership, or AGENTS memory routing changes.
- If a change is confined to a subproject, follow that subproject's own `AGENTS.md` / docs and keep root documentation focused on workspace-level facts.
- There is no root `docs/` directory right now; keep workspace-level guidance in `README.md` and this file unless the root gains enough surface area to justify a docs tree.
- After workspace-level documentation or config changes, run `neat-freak` (`/neat`, `整理一下`, `同步一下`) to keep the workspace knowledge tidy.
- Do not modify the maintainer/local host environment for setup, installs, or runtime experiments unless the user explicitly overrides this rule.
- Perform installs, ad-hoc tooling, runtime validation, and environment experiments only inside the target test containers.

## Container Default

- Use `CONNT-osg-test` as the primary test container unless a task explicitly targets `osg-test-2` or `osg-test-3`.
- See `README.md` for SSH details, passwords, and current lab topology.
