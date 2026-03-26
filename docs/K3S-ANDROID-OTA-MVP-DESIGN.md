# PLANETONYX Mobile - K3s Android OTA MVP Design

Version: 1.0  
Date: 2026-03-26  
Scope: OTA backend for multiple Android devices (starting with `avicii`) hosted on K3s
Project Name: PLANETONYX Mobile

## 1. Goal

Provide a self-hosted OTA platform on K3s to simplify ROM updates across multiple devices:

- centralized update manifests
- signed artifact distribution
- staged rollout and rollback control
- observable update success/failure metrics

## 2. Principles

1. Restore-safe operations, no ad-hoc OTA payload hotfixing in incidents.
2. Signed-only updates (release keys mandatory).
3. Device/channel isolation (`avicii` and future devices separated).
4. Tailnet-priority access to OTA endpoints.
5. No Google Play dependency in OTA path.

## 3. MVP Architecture

Core components:

1. `ota-api` (Deployment + Service)
- serves update metadata per device/channel/version
- validates client request shape

2. `ota-artifacts` (object storage)
- MinIO (S3-compatible) or equivalent
- stores OTA ZIP/payload + signatures + metadata files

3. `ota-control` (optional lightweight service)
- rollout gates (`canary`, `beta`, `stable`)
- hold/rollback flags

4. `ota-ops` (CI/CD pipeline)
- build ROM
- sign artifacts
- publish to object store
- publish/update manifest

5. Observability
- logs to Loki
- metrics to Influx/Prometheus
- Grafana dashboard for rollout status

## 4. Namespace and Base K8s Layout

Namespace:
- `mobile-ota`

Suggested resources:
- `Deployment/Service`: `ota-api`
- `Deployment/Service`: `minio` (or external object store endpoint)
- `ConfigMap`: rollout policy + channel settings
- `Secret`: S3 creds, signing pipeline tokens
- `Ingress`: `ota.srv.planetonyx.net` (Tailnet restricted where possible)
- `PVC`: artifact/cache volumes

## 5. API Contract (MVP)

Endpoint (example):
- `GET /v1/ota/check?device=avicii&channel=stable&build=2026.03.25`

Response (no update):
```json
{
  "ok": true,
  "update_available": false,
  "device": "avicii",
  "channel": "stable",
  "current_build": "2026.03.25"
}
```

Response (update available):
```json
{
  "ok": true,
  "update_available": true,
  "device": "avicii",
  "channel": "stable",
  "target_build": "2026.03.26",
  "version_name": "0.2.3",
  "artifact_url": "https://ota.srv.planetonyx.net/artifacts/avicii/stable/2026.03.26/update.zip",
  "sha256": "REPLACE_WITH_REAL_HASH",
  "size_bytes": 2147483648,
  "signature_url": "https://ota.srv.planetonyx.net/artifacts/avicii/stable/2026.03.26/update.zip.sig",
  "changelog_url": "https://ota.srv.planetonyx.net/changelog/avicii/2026.03.26.md",
  "rollout": {
    "ring": "stable",
    "percent": 25
  }
}
```

Client report endpoint:
- `POST /v1/ota/report`
- fields: `device_id`, `device`, `from_build`, `to_build`, `status`, `error_code`, `ts_utc`

## 6. Manifest Model

Manifest path pattern:
- `s3://ota-manifests/<device>/<channel>/manifest.json`

MVP keys:
- `device`
- `channel`
- `current_target`
- `artifact_url`
- `sha256`
- `signature_url`
- `min_battery_percent`
- `requires_charging`
- `rollout_percent`
- `hold` (boolean)

## 7. Channel and Rollout Policy

Channels:
- `canary`
- `beta`
- `stable`

Recommended rollout:
1. `canary`: 5-10%
2. `beta`: 25-50%
3. `stable`: 100%

Pause conditions:
- install failure rate above threshold
- boot-loop reports
- signature mismatch reports

Rollback:
- set `hold=true`
- repoint `current_target` to last known-good build
- publish rollback changelog note

## 8. CI/CD Flow

1. Build ROM (device-specific).
2. Sign ROM artifacts with release keys.
3. Generate checksums and signature files.
4. Upload artifacts to object store path.
5. Update manifest JSON for target channel.
6. Trigger cache invalidation / manifest refresh.
7. Emit release event to observability.

## 9. Security Controls

1. OTA checks must verify signature and checksum.
2. TLS mandatory for API and artifact endpoints.
3. Secrets only in Kubernetes Secrets (no git storage).
4. Artifact bucket write access only from CI.
5. API rate limiting and request logging enabled.

## 10. Device Integration Notes

Prerequisite:
- ROM updater client must support custom OTA endpoint contract.

If native updater does not support custom backend:
- create a lightweight updater companion app/service
- companion handles check/download/verify/install handoff

## 11. Ops Dashboard (MVP)

Panels:
- `updates_available_by_device`
- `update_success_rate_24h`
- `update_failures_by_error_code`
- `rollout_progress_by_channel`
- `rollback_events`

## 12. MVP Exit Criteria

1. `avicii` can query OTA endpoint and receive correct manifest.
2. Signed update installs successfully on test ring.
3. Failure report reaches backend and is visible in dashboard.
4. Rollback switch works within one manifest publish cycle.
5. No secrets leaked in repo/manifests/logs.

## 13. Next Step Implementation Checklist

1. Create `mobile-ota` namespace and baseline manifests.
2. Deploy `ota-api` stub + MinIO (or bind external S3 endpoint).
3. Implement `/v1/ota/check` and `/v1/ota/report`.
4. Add CI job: build -> sign -> upload -> manifest publish.
5. Connect logs/metrics to Grafana panels.
6. Add custom app catalog service (`appstore.srv.planetonyx.net`) and source-based app pipeline:
   - `/root/about-site/docs/K3S-CUSTOM-APP-STORE-MVP.md`
   - `/root/about-site/projects/k3s-srv-rebuild/manifests/59-mobile-app-catalog-mvp.yaml`
