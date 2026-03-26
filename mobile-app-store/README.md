# Mobile App Store Workspace

This workspace implements the source-to-build pipeline for the K3s custom app store MVP.

## Directory Layout

- `sources/` upstream source checkouts (read-only baseline)
- `patches/` local patch sets (`<app-id>/*.patch`)
- `build/` temporary CI workspace
- `dist/` signed APK artifacts and signatures
- `metadata/` catalog index and app manifests
- `scripts/` pipeline scripts
- `ci/` CI pipeline definitions

## Pipeline Order

1. clone/pull source into `sources/<app>`
2. apply optional patches from `patches/<app>`
3. build in isolated runner to `build/<app>`
4. sign output and write to `dist/<app>/<version>/`
5. update `metadata/index.json`
6. publish artifacts and metadata to K3s app-catalog storage path

## First Concrete Pipeline

- Script: `scripts/build_florisboard.sh`
- Script: `scripts/build_lawnchair.sh`
- Script: `scripts/build_syncthing_android.sh`
- Script: `scripts/build_aegis.sh`
- Script: `scripts/build_k9_mail.sh`
- Script: `scripts/build_etar.sh`
- Script: `scripts/build_fossify_contacts.sh`
- Script: `scripts/build_fossify_phone.sh`
- Script: `scripts/build_fossify_messages.sh`
- Metadata updater: `scripts/publish_catalog.py`
- CI example: `ci/pipeline.florisboard.example.yaml`
- CI example: `ci/pipeline.lawnchair.example.yaml`
- CI example: `ci/pipeline.syncthing-android.example.yaml`
- CI example: `ci/pipeline.aegis.example.yaml`
- CI example: `ci/pipeline.k9-mail.example.yaml`
- CI example: `ci/pipeline.etar.example.yaml`
- CI example: `ci/pipeline.fossify-contacts.example.yaml`
- CI example: `ci/pipeline.fossify-phone.example.yaml`
- CI example: `ci/pipeline.fossify-messages.example.yaml`

Required signing env vars:
- `SIGNING_KEYSTORE_PATH`
- `SIGNING_KEY_ALIAS`
- `SIGNING_KEYSTORE_PASS`
- `SIGNING_KEY_PASS`
- optional detached signature key: `DETACHED_SIGN_KEY_PATH`

GitHub Actions secrets reference:
- `docs/SIGNING-SECRETS-SETUP.md`
- required: `SIGNING_KEYSTORE_B64`, `SIGNING_KEY_ALIAS`, `SIGNING_KEYSTORE_PASS`, `SIGNING_KEY_PASS`
- optional: `DETACHED_SIGN_KEY_B64`
