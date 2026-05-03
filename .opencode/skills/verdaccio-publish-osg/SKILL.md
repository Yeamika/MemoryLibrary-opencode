---
name: verdaccio-publish-osg
description: Build, pack, and publish OpenSessionGateway packages to the local Verdaccio registry.
---

# verdaccio-publish-osg

Use this skill only for publishing OpenSessionGateway packages.
Do not mix in remote install, reload, or runtime validation.

## What this skill publishes

- `@opensessiongateway/protocol-library`
- `@opensessiongateway/client-library`
- `@opensessiongateway/server-plugin-sdk`
- `@opensessiongateway/client-opencode-plugin-v2`
- `@opensessiongateway/server`

## Bundled one-click script

Run:

```bash
bash "/workspace/OSG-Project/.opencode/skills/verdaccio-publish-osg/scripts/publish.sh"
```

## Defaults

- repo root: `/workspace/OSG-Project/OpenSessionGateway`
- version: `0.0.0-osg-local-<utc yymmddHHMM>`
- credential file: `~/.config/npm-local-uploader.md`

## Supported environment overrides

- `OSG_ROOT` — override repo root
- `PUBLISH_VERSION` — force a specific publish version for all OSG packages
- `REGISTRY` — override Verdaccio registry URL
- `NPM_USERNAME` / `NPM_PASSWORD` — override credential file values
- `OUT_DIR` — override the temp artifact directory

## Script behavior

1. Read Verdaccio credentials.
2. Temporarily rewrite package versions and internal dependency pins.
3. Build the publishable packages.
4. Pack tarballs into a temp directory.
5. Publish tarballs to Verdaccio in dependency order.
6. Verify published versions with `npm view`.
7. Restore the modified package manifests.

## When to use it

- You want a fresh local Verdaccio publish straight from the current OSG workspace.
- You want one command instead of manually packing and publishing each package.

## When not to use it

- You only need to install from Verdaccio.
- You are validating runtime behavior on test machines.
- You need a public npm release workflow.
