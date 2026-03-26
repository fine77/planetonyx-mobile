# PLANETONYX Mobile - K3s Custom App Store MVP

Version: 1.0  
Date: 2026-03-26  
Scope: Internal app catalog and source-to-build pipeline for Android devices without Google Play Store
Project Name: PLANETONYX Mobile

## 1. Goal

Provide a self-hosted app distribution model with:

- centralized app catalog
- controlled update sources
- optional source patching
- signed artifact output
- rollout-ready metadata for multiple devices

## 2. Hard Rules

1. No Google Play Store dependency.
2. Source and build provenance must be traceable.
3. No unsigned APK publication.
4. Keep upstream and local patches clearly separated.
5. Respect licenses and trademark constraints per app.

## 3. MVP Components

1. `app-catalog-api` on K3s:
- serves catalog index and per-app metadata
- exposes install/update URLs for approved artifacts

2. Artifact storage:
- shared storage path under `mobile-ota` PVC (`/data/artifacts/apps`)

3. CI pipeline:
- `clone -> patch -> build -> sign -> publish -> update catalog`

4. Client use:
- Obtainium/F-Droid frontend consumes URLs from catalog metadata

## 4. Data Model (Catalog)

`index.json` top-level:
- `generated_at`
- `store_version`
- `apps` list with:
  - `id`
  - `name`
  - `channel`
  - `version`
  - `artifact_url`
  - `sha256`
  - `signature_url`
  - `source_repo`
  - `license`
  - `maintainer_mode` (`upstream` or `planetonyx-patched`)

## 5. CI Workspace Layout

Base path:
- `/root/about-site/projects/k3s-srv-rebuild/mobile-app-store`

Subdirs:
- `sources/` cloned upstream repositories
- `patches/` local patch sets per app
- `build/` temporary build workspace
- `dist/` signed output artifacts
- `metadata/` catalog JSON and manifest files
- `scripts/` automation scripts
- `ci/` pipeline definitions

## 6. Build and Publish Flow

1. Pull/clone upstream source to `sources/<app>`.
2. Apply optional patch set from `patches/<app>`.
3. Build APK in isolated runner.
4. Sign APK with release key.
5. Compute checksum and signature file.
6. Publish to artifact path.
7. Update catalog metadata and expose via API.

## 7. Security Controls

1. Signing keys never stored in git.
2. Build runners use least privilege.
3. Signature and checksum must match before catalog publish.
4. Publish is blocked on signer mismatch.

## 8. MVP Exit Criteria

1. Catalog endpoint returns valid app index.
2. At least one app artifact can be downloaded and signature-verified.
3. CI run produces signed artifact and updates catalog metadata.
4. Client device updates app via approved source path without Play Store.
