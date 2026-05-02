---
name: verdaccio-publish-opencode
description: Build, pack, and publish opencode packages to the local Verdaccio registry.
---

# verdaccio-publish-opencode

Use this skill only for publishing opencode packages.
Do not mix in remote install, reload, or runtime validation.

## What this skill publishes

- `opencode-windows-x64`
- `opencode-linux-x64`
- `opencode-linux-arm64`
- `@opencode-ai/sdk`
- `@opencode-ai/plugin`
- `opencode-ai`

## Bundled one-click script

Run:

```bash
bash "/workspace/OSG-Project/.opencode/skills/verdaccio-publish-opencode/scripts/publish.sh"
```

## Defaults

- repo root: `/workspace/OSG-Project/Yeamika/opencode/pr-reload`
- version: `0.0.0-local-yes-<utc yymmddHHMM>`
- credential file: `~/.config/npm-local-uploader.md`

## Supported environment overrides

- `OPENCODE_ROOT` — override repo root
- `PUBLISH_VERSION` — force a specific publish version
- `REGISTRY` — override Verdaccio registry URL
- `NPM_USERNAME` / `NPM_PASSWORD` — override credential file values
- `OUT_DIR` — override the temp artifact directory
- `OPENCODE_ARTIFACT_ROOT` — skip local build and publish prebuilt tarballs from a directory tree

## Script behavior

1. Read Verdaccio credentials.
2. Build the CLI targets, SDK package, and plugin package.
3. Pack tarballs using the same package structure as the `build-full-packages` workflow.
4. Publish tarballs to Verdaccio in dependency order.
5. Verify published versions with `npm view`.
6. Restore any temporarily modified package manifests.

## When to use it

- You want a fresh local Verdaccio publish straight from the current opencode workspace.
- You want to publish a downloaded build artifact tree without repeating manual npm commands.

## When not to use it

- You only need to install from Verdaccio.
- You are validating runtime behavior on test machines.
- You need the public npm release workflow.
