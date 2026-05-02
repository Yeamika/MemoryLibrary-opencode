---
name: verdaccio-publish
description: Publish updated OpenSessionGateway npm packages to the local Verdaccio registry.
---

# verdaccio-publish

Use this skill only for npm publish.
Do not mix in remote install, reload, or demo validation work.

Registry endpoints:

- LAN: `http://desktop-phi:4873/`
- local direct: `http://127.0.0.1:4873/`
- reverse proxy: `http://nanokoli.agentapu.tiso.top/npmreg/`

Publisher account:

- npm username: `localuploader`

Preferred publish target from this workspace:

- use `http://nanokoli.agentapu.tiso.top/npmreg/`
Reason: this environment may not resolve `desktop-phi`, and `127.0.0.1` may not point at Verdaccio from inside the current workspace.

Suggested flow:

1. Bump package versions before publish if the same version may already exist on Verdaccio.
2. Build the packages that will be published.
   - `packages/protocol-library`
   - `packages/client-library`
   - `packages/server-plugin-sdk`
   - `packages/client-opencode-plugin-v2`
   - `server` with `npm run build:package`
3. Pack tarballs instead of publishing from inside the repo package directories.
   Reason: the repo `.npmrc` may override scoped registries.
4. Write a temporary npm userconfig such as `/tmp/osg-verdaccio.npmrc` with:
   - default registry set to the publish target
   - `@opensessiongateway:registry` set to the same target
   - `@opencode-ai:registry` set to the same target if needed
   - auth for `localuploader`
5. Validate with `npm whoami --userconfig /tmp/osg-verdaccio.npmrc`.
6. Publish tarballs from `/tmp` with explicit `--registry`, `--userconfig`, and `--tag latest`.

Known working pattern:

```bash
npm_config_registry=http://nanokoli.agentapu.tiso.top/npmreg/ npm publish \
  "/abs/path/to/pkg.tgz" \
  --registry http://nanokoli.agentapu.tiso.top/npmreg/ \
  --userconfig "/tmp/osg-verdaccio.npmrc" \
  --access public \
  --tag latest
```

When writing the temporary userconfig, prefer this shape:

```ini
registry=http://nanokoli.agentapu.tiso.top/npmreg/
@opensessiongateway:registry=http://nanokoli.agentapu.tiso.top/npmreg/
@opencode-ai:registry=http://nanokoli.agentapu.tiso.top/npmreg/
//nanokoli.agentapu.tiso.top/npmreg/:_auth=<base64 username:password>
//nanokoli.agentapu.tiso.top/npmreg/:email=<publisher email>
```

Publish order that works well:

1. `@opensessiongateway/protocol-library`
2. `@opensessiongateway/client-library`
3. `@opensessiongateway/server-plugin-sdk`
4. `@opensessiongateway/client-opencode-plugin-v2`
5. `@opensessiongateway/server`

Checks after publish:

```bash
npm view @opensessiongateway/protocol-library@<version> version --registry http://nanokoli.agentapu.tiso.top/npmreg/
npm view @opensessiongateway/client-opencode-plugin-v2@<version> version --registry http://nanokoli.agentapu.tiso.top/npmreg/
npm view @opensessiongateway/server@<version> version --registry http://nanokoli.agentapu.tiso.top/npmreg/
```

Important notes:

- Installing packages is a separate workflow. Keep this skill publish-only.
- Default to `--tag latest` for publishes from this workflow.
- If publish fails with registry mismatch, do not publish from the repo package directory. Re-run from `/tmp` against packed tarballs.
- If large binary tarballs fail through the reverse proxy with `413 Request Entity Too Large`, retry against `http://host.docker.internal:4873/` with a matching temporary userconfig.
- If install later needs public npm packages like `ws` or `@koishijs/core`, do not point the default install registry at Verdaccio unless that mirror is known to proxy them.
