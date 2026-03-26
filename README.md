# PLANETONYX Mobile

Self-hosted Android mobile platform for privacy-focused devices without Google Play Store.

## Model Profiles

- `profiles/oneplus-avicii`
- `profiles/xiaomi-poco-x3-pro`

## Core Modules

- `manifests/58-mobile-ota-mvp.yaml` (OTA API + NFS artifacts)
- `manifests/59-mobile-app-catalog-mvp.yaml` (Custom app catalog)
- `mobile-app-store/` (source -> patch -> build -> sign -> publish)
- `apps/planetonyx-store/` (Android App Store client)
- `docs/` (operating model, OTA and app-store architecture)

## Naming Convention

- Project: `PLANETONYX Mobile`
- Device channels are separated by model and channel (`stable`, `beta`, `canary`)
- Artifacts path pattern:
  - `artifacts/<model>/<channel>/<build>/...` for OTA
  - `artifacts/apps/<app-id>/<version>/...` for app catalog

## Security Rules

- Never use Google Play Store in this project.
- Publish signed artifacts only.
- Keep signing keys out of git.

## App Store Client

- Product spec: `docs/PLANETONYX-STORE-APP-MVP.md`
- Implementation workspace: `apps/planetonyx-store/`
