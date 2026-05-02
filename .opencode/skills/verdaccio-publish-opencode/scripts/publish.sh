#!/usr/bin/env bash
set -euo pipefail

ROOT="${OPENCODE_ROOT:-/workspace/OSG-Project/Yeamika/opencode/pr-reload}"
CFG="${NPM_LOCAL_UPLOADER_FILE:-$HOME/.config/npm-local-uploader.md}"
OUT="${OUT_DIR:-$(mktemp -d /tmp/opencode-verdaccio-publish.XXXXXX)}"
ART="${OPENCODE_ARTIFACT_ROOT:-}"
VERSION="${PUBLISH_VERSION:-0.0.0-local-yes-$(date -u +'%y%m%d%H%M')}"
NPMRC="${OUT}/verdaccio.npmrc"
SDK_FILE="$ROOT/packages/sdk/js/package.json"
PLUGIN_FILE="$ROOT/packages/plugin/package.json"

cleanup() {
  if [[ -f "${SDK_FILE}.bak.publish" ]]; then
    mv "${SDK_FILE}.bak.publish" "$SDK_FILE"
  fi
  if [[ -f "${PLUGIN_FILE}.bak.publish" ]]; then
    mv "${PLUGIN_FILE}.bak.publish" "$PLUGIN_FILE"
  fi
}

trap cleanup EXIT

if [[ ! -d "$ROOT" ]]; then
  printf 'opencode root not found: %s\n' "$ROOT" >&2
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
@opencode-ai:registry=${REGISTRY}
//${HOST}/:_auth=${AUTH}
//${HOST}/:username=${USERNAME}
//${HOST}/:email=localuploader@example.com
EOF

npm whoami --registry "$REGISTRY" --userconfig "$NPMRC" >/dev/null

pick() {
  local pattern="$1"
  local rows=()
  shopt -s globstar nullglob
  rows=($pattern)
  shopt -u globstar nullglob
  if [[ ${#rows[@]} -ne 1 ]]; then
    printf 'Expected exactly one artifact for pattern: %s\n' "$pattern" >&2
    exit 1
  fi
  printf '%s\n' "${rows[0]}"
}

if [[ -z "$ART" ]]; then
  pushd "$ROOT" >/dev/null
  OPENCODE_VERSION="$VERSION" bun ./packages/opencode/script/build.ts
  (cd ./packages/sdk/js && bun run build)
  git diff --exit-code -- packages/sdk/js/src/gen packages/sdk/js/src/v2/gen
  (cd ./packages/plugin && bun run build)

  npm pack ./packages/opencode/dist/opencode-windows-x64 --pack-destination "$OUT" >/dev/null
  npm pack ./packages/opencode/dist/opencode-linux-arm64 --pack-destination "$OUT" >/dev/null
  npm pack ./packages/opencode/dist/opencode-linux-x64 --pack-destination "$OUT" >/dev/null

  rm -rf ./packages/opencode/dist/opencode-ai
  mkdir -p ./packages/opencode/dist/opencode-ai
  cp -r ./packages/opencode/bin ./packages/opencode/dist/opencode-ai/bin
  cp ./packages/opencode/script/postinstall.mjs ./packages/opencode/dist/opencode-ai/postinstall.mjs
  cp ./LICENSE ./packages/opencode/dist/opencode-ai/LICENSE
  node <<'NODE'
const fs = require('fs')
const path = require('path')
const root = path.resolve('./packages/opencode')
const dist = path.join(root, 'dist')
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'))
const win = JSON.parse(fs.readFileSync(path.join(dist, 'opencode-windows-x64', 'package.json'), 'utf8'))
const linuxX64 = JSON.parse(fs.readFileSync(path.join(dist, 'opencode-linux-x64', 'package.json'), 'utf8'))
const linux = JSON.parse(fs.readFileSync(path.join(dist, 'opencode-linux-arm64', 'package.json'), 'utf8'))
fs.writeFileSync(
  path.join(dist, 'opencode-ai', 'package.json'),
  JSON.stringify(
    {
      name: 'opencode-ai',
      version: win.version,
      license: pkg.license,
      bin: { opencode: './bin/opencode' },
      scripts: { postinstall: 'node ./postinstall.mjs' },
      optionalDependencies: {
        [win.name]: win.version,
        [linuxX64.name]: linuxX64.version,
        [linux.name]: linux.version,
      },
    },
    null,
    2,
  ) + '\n',
)
NODE
  npm pack ./packages/opencode/dist/opencode-ai --pack-destination "$OUT" >/dev/null

  cp "$SDK_FILE" "${SDK_FILE}.bak.publish"
  SDK_FILE="$SDK_FILE" OPENCODE_VERSION="$VERSION" node <<'NODE'
const fs = require('fs')
const file = process.env.SDK_FILE
const version = process.env.OPENCODE_VERSION
const pkg = JSON.parse(fs.readFileSync(file, 'utf8'))
pkg.version = version
const map = (value) => {
  if (typeof value === 'string') {
    const item = value.replace('./src/', './dist/').replace(/\.ts$/, '')
    return { import: item + '.js', types: item + '.d.ts' }
  }
  if (!value || typeof value !== 'object') return value
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, map(item)]))
}
pkg.exports = map(pkg.exports)
fs.writeFileSync(file, JSON.stringify(pkg, null, 2) + '\n')
NODE
  npm pack ./packages/sdk/js --pack-destination "$OUT" >/dev/null
  mv "${SDK_FILE}.bak.publish" "$SDK_FILE"

  cp "$PLUGIN_FILE" "${PLUGIN_FILE}.bak.publish"
  PLUGIN_FILE="$PLUGIN_FILE" OPENCODE_VERSION="$VERSION" node <<'NODE'
const fs = require('fs')
const file = process.env.PLUGIN_FILE
const version = process.env.OPENCODE_VERSION
const pkg = JSON.parse(fs.readFileSync(file, 'utf8'))
pkg.version = version
pkg.dependencies['@opencode-ai/sdk'] = version
pkg.exports = Object.fromEntries(
  Object.entries(pkg.exports).map(([key, value]) => {
    const item = value.replace('./src/', './dist/').replace(/\.ts$/, '')
    return [key, { import: item + '.js', types: item + '.d.ts' }]
  }),
)
fs.writeFileSync(file, JSON.stringify(pkg, null, 2) + '\n')
NODE
  npm pack ./packages/plugin --pack-destination "$OUT" >/dev/null
  mv "${PLUGIN_FILE}.bak.publish" "$PLUGIN_FILE"

  popd >/dev/null
  ART="$OUT"
fi

WIN="$(pick "$ART/**/opencode-windows-x64-${VERSION}.tgz")"
LINUX_ARM64="$(pick "$ART/**/opencode-linux-arm64-${VERSION}.tgz")"
LINUX_X64="$(pick "$ART/**/opencode-linux-x64-${VERSION}.tgz")"
SDK="$(pick "$ART/**/opencode-ai-sdk-${VERSION}.tgz")"
PLUGIN="$(pick "$ART/**/opencode-ai-plugin-${VERSION}.tgz")"
CLI="$(pick "$ART/**/opencode-ai-${VERSION}.tgz")"

publish() {
  local file="$1"
  npm publish "$file" --registry "$REGISTRY" --userconfig "$NPMRC" --access public --tag latest
}

publish "$WIN"
publish "$LINUX_ARM64"
publish "$LINUX_X64"
publish "$SDK"
publish "$PLUGIN"
publish "$CLI"

npm view "opencode-windows-x64@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"
npm view "opencode-linux-arm64@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"
npm view "opencode-linux-x64@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"
npm view "@opencode-ai/sdk@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"
npm view "@opencode-ai/plugin@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"
npm view "opencode-ai@${VERSION}" version --registry "$REGISTRY" --userconfig "$NPMRC"

printf '\nPublished opencode packages at version %s\nArtifacts: %s\n' "$VERSION" "$ART"
