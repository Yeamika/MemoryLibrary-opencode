#!/usr/bin/env bash
set -euo pipefail

ROOT="${OSG_ROOT:-/workspace/OSG-Project/OpenSessionGateway}"
CFG="${NPM_LOCAL_UPLOADER_FILE:-$HOME/.config/npm-local-uploader.md}"
OUT="${OUT_DIR:-$(mktemp -d /tmp/osg-verdaccio-publish.XXXXXX)}"
VERSION="${PUBLISH_VERSION:-0.0.0-osg-local-$(date -u +'%y%m%d%H%M')}"
NPMRC="${OUT}/verdaccio.npmrc"

if [[ ! -d "$ROOT" ]]; then
  printf 'OSG root not found: %s\n' "$ROOT" >&2
  exit 1
fi

readarray -t CFG_ROWS < <(CFG_PATH="$CFG" node <<'NODE'
const fs = require('fs')
const path = process.env.CFG_PATH
if (!fs.existsSync(path)) process.exit(2)
const text = fs.readFileSync(path, 'utf8')
const pick = (name) => {
  const row = text.match(new RegExp(`^-\\s*${name}:\\s*(.+)$`, 'm'))
  return row ? row[1].trim() : ''
}
console.log(pick('registry'))
console.log(pick('username'))
console.log(pick('password'))
NODE
)

if [[ ${#CFG_ROWS[@]} -lt 3 && -z "${REGISTRY:-}" ]]; then
  printf 'Missing Verdaccio credentials file: %s\n' "$CFG" >&2
  exit 1
fi

REGISTRY="${REGISTRY:-${CFG_ROWS[0]:-}}"
USERNAME="${NPM_USERNAME:-${CFG_ROWS[1]:-}}"
PASSWORD="${NPM_PASSWORD:-${CFG_ROWS[2]:-}}"

if [[ -z "$REGISTRY" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
  printf 'Registry, username, and password are required.\n' >&2
  exit 1
fi

HOST="${REGISTRY#http://}"
HOST="${HOST#https://}"
HOST="${HOST%/}"
AUTH="$(node -e "process.stdout.write(Buffer.from(process.argv[1] + ':' + process.argv[2]).toString('base64'))" "$USERNAME" "$PASSWORD")"

mkdir -p "$OUT"
cat > "$NPMRC" <<EOF
registry=${REGISTRY}
@opensessiongateway:registry=${REGISTRY}
@opencode-ai:registry=${REGISTRY}
//${HOST}/:_auth=${AUTH}
//${HOST}/:username=${USERNAME}
//${HOST}/:email=localuploader@example.com
EOF

npm whoami --registry "$REGISTRY" --userconfig "$NPMRC" >/dev/null

pushd "$ROOT" >/dev/null
PUBLISH_VERSION="$VERSION" OUT_DIR="$OUT" REGISTRY="$REGISTRY" NPM_CONFIG_USERCONFIG="$NPMRC" node ./scripts/local-packages.mjs publish
popd >/dev/null

printf '\nPublished OSG packages at version %s\nArtifacts: %s\n' "$VERSION" "$OUT"
