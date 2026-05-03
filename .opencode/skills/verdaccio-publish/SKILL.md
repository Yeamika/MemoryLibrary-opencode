---
name: verdaccio-publish
description: Legacy Verdaccio publish entrypoint. Prefer the dedicated OSG or opencode publish skills.
---

# verdaccio-publish

This skill is kept as a compatibility alias.

Prefer one of these dedicated skills instead:

- `verdaccio-publish-osg`
- `verdaccio-publish-opencode`

Use `verdaccio-publish-osg` when publishing OpenSessionGateway packages.
Use `verdaccio-publish-opencode` when publishing opencode packages.

Both dedicated skills ship with bundled `scripts/publish.sh` helpers for one-click publish.

Credential source for both flows:

- `~/.config/npm-local-uploader.md`

Format:

```md
# npm-local-uploader

- registry: <registry_url>
- username: <username>
- password: <password>
```

Do not mix publish with install, remote reload, or demo validation.
