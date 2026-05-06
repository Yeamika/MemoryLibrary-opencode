# Workspace Shared Publish / Registry Notes

## Scope

This document records publish and registry facts shared across projects in this workspace.

## Shared Verdaccio

- The workspace local Verdaccio server is `http://host.docker.internal:4873`.
- This server stores only a small set of locally published packages; it is not a full npm mirror.
- Large numbers of GET / PUT requests to `4873` in logs do not automatically indicate failure.
- `401` responses from `4873` do not automatically mean bad credentials; the request may have been routed to a local registry that does not host the target package.

## Credentials

- Credentials must come from `~/.npmrc`, `~/.config/npm-local-uploader.md`, or runtime environment variables.
- Never write credentials into committed repo files, including `AGENTS.md`, `README.md`, `docs/`, or `.opencode/`.

## Project-specific publish entrypoints

- OpenSessionGateway project: prefer `verdaccio-publish-osg` for local OSG package publishing.
- opencode project worktrees: prefer `verdaccio-publish-opencode` for local opencode package publishing.
- When the task is to run the full release / verify / publish flow rather than package-only publish, prefer `release-local`.
