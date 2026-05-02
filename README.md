# OSG Project Lab

This workspace tracks the current maintainer + osg-test lab topology.

## Primary Test Container

- container: `CONNT-osg-test`
- hostname: `osg-test-main`
- SSH alias inside Docker network: `osg-test`
- SSH port: `22`
- user: `node`
- password: `ConntTest@2026!`

Use `CONNT-osg-test` as the main test container.
Do not modify the maintainer/local host environment for setup, installs, or runtime experiments.
Package installs, ad-hoc tools, runtime validation, and environment experiments must happen inside the test containers.

## Current Test Containers

- `CONNT-osg-test`
  - hostname: `osg-test-main`
  - SSH alias: `osg-test`
  - OpenCode port: `9521`
- `CONNT-osg-test-2`
  - hostname: `osg-test-2`
  - SSH alias: `osg-test-2`
  - OpenCode port: `9521`
- `CONNT-osg-test-3`
  - hostname: `osg-test-3`
  - SSH alias: `osg-test-3`
  - OpenCode port: `9521`

All three test containers are attached to the same Docker network and can reach each other directly by name.
No host port mapping is used for SSH or OpenCode.

## Access From Maintainer

From `opencode-maintainer-opencode-1`:

```bash
ssh node@osg-test
ssh node@osg-test-2
ssh node@osg-test-3
```

Enter the password above when prompted.

## Template Compose

- compose file: `D:\Docker\Composes\OSG-Project\compose.yml`
- this file is generic and only defines one runtime template
- create any number of osg-test containers by reusing the same compose file with different:
  - compose project names
  - container names
  - hostnames / network aliases
  - workspace / runtime volume names
  - workdir values
  - SSH enable / password values

Current live instances were created from that template with different runtime parameters instead of hardcoding a fixed container count into compose.

## Workspace Layout

- `.opencode/` — workspace-local OpenCode config, local tools, and installed skills
- `.config/nextcloud_mcp.json` — Nextcloud MCP account config referenced by the workspace
- `OpenSessionGateway/` — main OpenSessionGateway codebase
- `Yeamika/` — local OpenCode forks / worktrees used in this lab
- `nextcloud-mcp-tool/` — local Nextcloud MCP server source
- `agent-skills/` — skill and prompt experiments for agent workflows
- `tmp/` — disposable artifacts and staging output

## Workspace Git Layout

The workspace root now has a **local meta repo** at `/workspace/OSG-Project/.git`.

- root git tracks workspace-level memory and local agent assets only
- child project repos keep their own source history
- root `AGENTS.md` is the workspace memory baseline
- child `AGENTS.md` files are scoped memory for their own repo / directory subtree
- use `WORKSPACE_MAP.md` to determine which repo owns a path and which git history to read

The root meta repo intentionally ignores:

- child repos under `OpenSessionGateway/`, `nextcloud-mcp-tool/`, and `Yeamika/`
- local account/runtime state under `.config/`, `.workerspace/`, and `tmp/`
- local bundle artifacts at the workspace root

## Workspace Automation

Project-level OpenCode config lives in `.opencode/opencode.json`.

### MCP Servers

- `osg_ssh` — SSH access to `osg-test`, `osg-test-2`, and `osg-test-3`
- `nextcloud` — launches `nextcloud-mcp-tool/dist/index.js` with `NEXTCLOUD_MCP_CONFIG=/workspace/OSG-Project/.config/nextcloud_mcp.json`

### Local Skills

- `neat-freak` — end-of-session knowledge cleanup for `README.md`, project instructions, and related workspace docs; trigger with `/neat`, `整理一下`, or `同步一下`
- `verdaccio-publish` — legacy Verdaccio publish entrypoint
- `verdaccio-publish-opencode` — publish OpenCode packages to the local Verdaccio registry
- `verdaccio-publish-osg` — publish OpenSessionGateway packages to the local Verdaccio registry

After changing workspace-level config, documentation, or skill inventory, run `neat-freak` to keep root docs and agent instructions aligned.
