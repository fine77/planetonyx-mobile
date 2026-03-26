#!/usr/bin/env bash
set -euo pipefail

# PLANETONYX Mobile - FlorisBoard source/build/sign/publish pipeline (MVP)
#
# Required tools:
# - git
# - java (for gradle)
# - apksigner (Android build-tools)
# - sha256sum
#
# Required env vars:
# - FLORIS_VERSION (example: 0.5.2)
# - SIGNING_KEYSTORE_PATH
# - SIGNING_KEY_ALIAS
# - SIGNING_KEYSTORE_PASS
# - SIGNING_KEY_PASS
#
# Optional env vars:
# - APPSTORE_BASE_URL (default: https://appstore.srv.planetonyx.net)
# - ARTIFACT_ROOT (default: /data/artifacts/apps)
# - SOURCE_REPO (default: https://github.com/florisboard/florisboard.git)
# - SOURCE_REF (default: v${FLORIS_VERSION})
# - DETACHED_SIGN_KEY_PATH (PEM private key for .sig generation)

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_ID="florisboard"
APP_NAME="FlorisBoard"
LICENSE="Apache-2.0"
MAINTAINER_MODE="${MAINTAINER_MODE:-upstream}"
CHANNEL="${CHANNEL:-stable}"
FLORIS_VERSION="${FLORIS_VERSION:-}"
APPSTORE_BASE_URL="${APPSTORE_BASE_URL:-https://appstore.srv.planetonyx.net}"
ARTIFACT_ROOT="${ARTIFACT_ROOT:-/data/artifacts/apps}"
SOURCE_REPO="${SOURCE_REPO:-https://github.com/florisboard/florisboard.git}"

if [[ -z "${FLORIS_VERSION}" ]]; then
  echo "ERROR: FLORIS_VERSION is required (example: 0.5.2)"
  exit 1
fi

SOURCE_REF="${SOURCE_REF:-v${FLORIS_VERSION}}"
SRC_DIR="${BASE_DIR}/sources/${APP_ID}"
PATCH_DIR="${BASE_DIR}/patches/${APP_ID}"
BUILD_DIR="${BASE_DIR}/build/${APP_ID}"
DIST_DIR="${BASE_DIR}/dist/${APP_ID}/${FLORIS_VERSION}"
META_DIR="${BASE_DIR}/metadata"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: missing command '$1'"; exit 1; }
}

require_cmd git
require_cmd sha256sum
require_cmd apksigner
require_cmd java

for v in SIGNING_KEYSTORE_PATH SIGNING_KEY_ALIAS SIGNING_KEYSTORE_PASS SIGNING_KEY_PASS; do
  if [[ -z "${!v:-}" ]]; then
    echo "ERROR: missing env var ${v}"
    exit 1
  fi
done

mkdir -p "${BASE_DIR}/sources" "${BASE_DIR}/build" "${BASE_DIR}/dist" "${META_DIR}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}" "${DIST_DIR}"

echo "[1/7] source sync"
if [[ ! -d "${SRC_DIR}/.git" ]]; then
  git clone --depth 1 "${SOURCE_REPO}" "${SRC_DIR}"
fi
git -C "${SRC_DIR}" fetch --tags --force
if ! git -C "${SRC_DIR}" rev-parse -q --verify "${SOURCE_REF}^{commit}" >/dev/null; then
  echo "ERROR: SOURCE_REF '${SOURCE_REF}' not found in ${SOURCE_REPO}"
  echo "Known recent tags:"
  git -C "${SRC_DIR}" tag -l 'v*' --sort=-v:refname | head -n 12 | sed 's/^/  - /'
  exit 1
fi
git -C "${SRC_DIR}" checkout -f "${SOURCE_REF}"

echo "[2/7] source copy to build workspace"
rsync -a --delete --exclude ".git" "${SRC_DIR}/" "${BUILD_DIR}/"

echo "[3/7] optional patches"
if [[ -d "${PATCH_DIR}" ]]; then
  shopt -s nullglob
  for p in "${PATCH_DIR}"/*.patch; do
    echo "  applying $(basename "$p")"
    git -C "${BUILD_DIR}" init >/dev/null 2>&1
    git -C "${BUILD_DIR}" apply "$p"
  done
  shopt -u nullglob
fi

echo "[4/7] gradle build"
(
  cd "${BUILD_DIR}"
  chmod +x ./gradlew
  ./gradlew --no-daemon assembleRelease
)

UNSIGNED_APK="$(find "${BUILD_DIR}" -type f -name '*release*.apk' | head -n 1 || true)"
if [[ -z "${UNSIGNED_APK}" ]]; then
  echo "ERROR: release APK not found in build output"
  exit 1
fi

SIGNED_APK="${DIST_DIR}/${APP_ID}.apk"
SIG_FILE="${SIGNED_APK}.sig"
SHA_FILE="${SIGNED_APK}.sha256"

echo "[5/7] sign apk"
cp -f "${UNSIGNED_APK}" "${SIGNED_APK}"
apksigner sign \
  --ks "${SIGNING_KEYSTORE_PATH}" \
  --ks-key-alias "${SIGNING_KEY_ALIAS}" \
  --ks-pass "pass:${SIGNING_KEYSTORE_PASS}" \
  --key-pass "pass:${SIGNING_KEY_PASS}" \
  "${SIGNED_APK}"

echo "[6/7] checksum + detached signature placeholder"
SHA256="$(sha256sum "${SIGNED_APK}" | awk '{print $1}')"
printf "%s  %s\n" "${SHA256}" "$(basename "${SIGNED_APK}")" > "${SHA_FILE}"
if [[ -n "${DETACHED_SIGN_KEY_PATH:-}" && -f "${DETACHED_SIGN_KEY_PATH}" ]] && command -v openssl >/dev/null 2>&1; then
  openssl dgst -sha256 -sign "${DETACHED_SIGN_KEY_PATH}" -out "${SIG_FILE}" "${SIGNED_APK}"
else
  printf "SIGNATURE_PLACEHOLDER_FOR_%s_%s\n" "${APP_ID}" "${FLORIS_VERSION}" > "${SIG_FILE}"
fi

echo "[7/7] publish metadata update"
python3 "${BASE_DIR}/scripts/publish_catalog.py" \
  --metadata-index "${META_DIR}/index.json" \
  --app-id "${APP_ID}" \
  --name "${APP_NAME}" \
  --channel "${CHANNEL}" \
  --version "${FLORIS_VERSION}" \
  --artifact-url "${APPSTORE_BASE_URL}/artifacts/apps/${APP_ID}/${FLORIS_VERSION}/${APP_ID}.apk" \
  --sha256 "${SHA256}" \
  --signature-url "${APPSTORE_BASE_URL}/artifacts/apps/${APP_ID}/${FLORIS_VERSION}/${APP_ID}.apk.sig" \
  --source-repo "${SOURCE_REPO}" \
  --license "${LICENSE}" \
  --maintainer-mode "${MAINTAINER_MODE}"

echo "DONE: ${SIGNED_APK}"
echo "SHA256: ${SHA256}"
