# PLANETONYX Mobile - Android Avicii Tailnet OSS Pilot

Version: 1.0  
Date: 2026-03-26  
Owner: PlanetOnyx Operations  
Scope: OnePlus `avicii` (privacy-hardened test device with controlled WAN), later transfer pattern to Xiaomi Poco X3 Pro
Project Name: PLANETONYX Mobile

## 1. Objective

Build a low-noise, privacy-hardened Android device for internal operations:

- no Google Apps package
- OSS-first application stack
- strict network control (deny-by-default)
- K3s service usage via Tailnet (priority path)
- daily usability (Messenger allowed as explicit exception)

This project is a pilot profile, not a full replacement for GrapheneOS-grade security.

## 2. Non-Goals

- no claim of Pixel/GrapheneOS security parity
- no banking/DRM/Wallet hardening scope
- no open inbound WAN service exposure from the device
- no broad "custom ROM redesign" during pilot incident windows
- no Google Play Store usage in this project

## 3. Device and OS Baseline

Primary pilot device:
- OnePlus `avicii` (2020 generation, 12 GB RAM class)

Target build path:
- LineageOS build path for `avicii` (self-build capable)
- preferred baseline: LineageOS for microG or equivalent microG-capable setup
- root path: Magisk (post-flash, controlled module set)

## 4. Security and Network Principles

1. Default network posture: deny-by-default.
2. Controlled WAN access is allowed for approved apps.
3. Tailnet-first access to internal services and K3s endpoints.
4. SSH only with key auth; no password auth.
5. Minimum app permissions; keep background execution only where required.
6. Single proprietary exception allowed: Facebook Messenger.

## 5. App Policy

OSS baseline apps:
- Launcher: Lawnchair (Pixel-style profile)
- Keyboard: FlorisBoard
- Contacts: OpenContacts (fallback: Fossify Contacts)
- Dialer: Fossify Phone or Koler
- SMS: Fossify Messages or QKSMS
- Sync: Syncthing
- Firewall: AFWall+
- Package sources: F-Droid + Obtainium
- Maps: Organic Maps
- Auth OTP: Aegis

Explicit non-OSS exception:
- Facebook Messenger (business/communication requirement)

App source hard rule:
- never use Google Play Store on this pilot profile
- allowed sources: F-Droid, Obtainium, signed direct release channels only

Optional/advanced (stability-dependent):
- Magisk audio module (Dolby Atmos class) only after base stability proof
- Pixel Camera port allowed, but no required WAN permissions

## 6. Data and Sync Architecture

Sync target model:
- Phone folders -> Syncthing -> K3s receiver -> PVC -> NFS backend

Primary sync folders:
- `DCIM/Camera`
- `Pictures`
- `Movies`
- export folder for Contacts/SMS/Tasks backups

Rule:
- Android device does not write directly to NFS mounts.
- All storage synchronization is application-level via Syncthing.

## 7. SSH Operating Model

Supported:
- Termux + OpenSSH (`sshd`) for admin access

Mandatory controls:
- key-only authentication
- disable password login
- limit ingress to Tailnet (preferred) or strict LAN allowlist
- no broad WLAN exposure
- no inbound WAN exposure

## 8. AFWall+ Baseline Policy

Default:
- block all apps unless explicitly allowed (controlled WAN model)

Allowlist (initial, WAN allowed for approved apps):
- Tailscale
- Syncthing
- Messenger
- microG components needed for required app functionality
- system DNS/NTP required for stable operation

Blocklist (initial):
- Pixel Camera port WAN access by default
- all unused apps and services

Profile handling:
- separate profiles for WLAN and mobile data (even if SIM absent now)
- export policy snapshot after each stable milestone

## 9. Implementation Phases

Phase A: Base ROM and boot stability
- flash OS baseline
- verify boot/reboot, WLAN, camera, audio, battery behavior

Phase B: Core stack and hardening
- install Magisk, Lawnchair, FlorisBoard, Tailnet, AFWall+, Syncthing
- enforce deny-by-default network policy

Phase C: Internal service integration
- bind internal workflows to Tailnet/K3s endpoints
- validate sync chain to K3s/NFS through Syncthing
- keep WAN allowed only for explicitly approved apps

Phase D: Soak test and metrics
- run 7-day stability window
- collect battery/network/failure metrics

Phase E: Transfer package for Poco
- convert validated profile into reusable rollout checklist

## 10. Acceptance Criteria (Pilot Exit Gate)

All criteria must pass for 7 consecutive days:

1. No critical crash/reboot loops.
2. Tailnet connectivity stable after reboot.
3. Syncthing media sync successful to K3s target.
4. Messenger usable (messages/notifications) within policy.
5. AFWall+ rules persist and block unapproved traffic.
6. No unexplained outbound traffic spikes.
7. WAN access works only for allowlisted apps; blocked apps stay blocked.

## 11. Risk Register (Pilot)

Top risks:
- root/module instability after updates
- microG behavior drift across app versions
- AFWall UID mapping changes after reinstall/update
- vendor camera/audio regressions on custom ROM builds

Mitigations:
- freeze known-good versions during soak window
- maintain rollback package (boot image + last known-good ROM)
- export AFWall policy and Syncthing config backups

## 12. Change Control

During pilot incidents:
- restore run-state first
- no unrelated module/launcher/theme experiments
- one change at a time with verification evidence

Documentation required per change:
- what changed
- why changed
- validation result
- rollback status

## 13. Deliverables

1. Hardened avicii pilot profile (documented).
2. App allowlist/blocklist matrix.
3. AFWall baseline export and recovery notes.
4. Syncthing folder map for K3s target.
5. Poco migration checklist (derived from pilot).
6. OTA backend MVP design reference:
   - `/root/about-site/docs/K3S-ANDROID-OTA-MVP-DESIGN.md`
7. Custom app store MVP design reference:
   - `/root/about-site/docs/K3S-CUSTOM-APP-STORE-MVP.md`

## 14. App and Network Matrix (Baseline v1)

| App / Component | WAN | Tailnet | Policy | Reason |
|---|---|---|---|---|
| Tailscale | allow | allow | allow | Tailnet control/data path required |
| Syncthing | allow | allow | allow | Device sync and peer connectivity |
| Facebook Messenger | allow | optional | allow | Explicit business exception |
| microG core services | allow (minimal) | optional | allow (restricted) | Required compatibility for selected apps |
| FlorisBoard | block | block | block | No network requirement |
| Lawnchair | block | block | block | No network requirement |
| OpenContacts / Fossify Contacts | block | optional | block by default | Local contacts app, sync handled separately |
| Fossify Phone / Koler | block | block | block | Dialer does not require data path |
| Fossify Messages / QKSMS | block | block | block | Local SMS app, no cloud dependency |
| Organic Maps | optional | block | block by default | Enable WAN only if online tiles needed |
| Aegis | block | block | block | OTP app, offline by design |
| Pixel Camera port | block | block | block | No WAN required; telemetry suppression |
| Termux SSH (`sshd`) | block | allow | tailnet-only | Admin access only via Tailnet/LAN allowlist |
| F-Droid | allow | optional | allow | OSS app updates |
| Obtainium | allow | optional | allow | Source-based app updates |
| System DNS/NTP | allow | n/a | allow (system only) | Time and resolver stability |

Policy notes:
- `allow` means explicitly whitelisted in AFWall+.
- `block` means not whitelisted (deny-by-default).
- Tailnet-only services must not receive broad WAN allow rules.

## 15. AFWall+ Baseline Profile v1 (Implementation)

### 15.1 Preparation Order

1. Install and open AFWall+.
2. Enable firewall mode and set default deny.
3. Create profiles:
- `WIFI_BASELINE`
- `MOBILE_BASELINE` (keep for future even if no SIM currently)
4. Keep IPv4 and IPv6 filtering enabled.

### 15.2 Rule Model

Default:
- block every app unless explicitly allowlisted.

Always allow (both profiles):
- Tailscale
- Syncthing
- Messenger
- F-Droid
- Obtainium

Conditionally allow:
- microG core only if required by active apps
- Organic Maps only if online map fetch is needed

Always block:
- Pixel Camera port
- Lawnchair
- FlorisBoard
- Aegis
- Contacts/Dialer/Messages apps (unless a specific sync feature needs net)

System allowances:
- allow required system DNS/NTP only
- no generic "allow all system apps" shortcut

### 15.3 SSH Rule

- If Termux `sshd` is used:
  - allow only on Tailnet profile usage path
  - no broad WAN inbound
  - keep key-only auth in sshd config

### 15.4 Validation Checklist

After applying rules, verify:
1. Tailscale connects after reboot.
2. Syncthing sync works to K3s receiver.
3. Messenger messages/notifications work.
4. Pixel Camera cannot reach WAN.
5. Blocked apps show no active network traffic.
6. Internal K3s services remain reachable via Tailnet.

### 15.5 Export and Recovery

1. Export AFWall profile after successful validation:
- `WIFI_BASELINE-v1`
- `MOBILE_BASELINE-v1`
2. Store export in project evidence path and backup.
3. On restore:
- import profile
- re-check app UID mapping
- run validation checklist again before production use

## 16. Syncthing to K3s Mapping v1

### 16.1 Topology

- Device (send-only folders) -> Syncthing receiver in K3s -> PVC -> NFS backend
- No direct Android NFS mount.

### 16.2 Folder Mapping

| Device Folder | Syncthing Folder ID | K3s Target Path (PVC mount) | Mode |
|---|---|---|---|
| `DCIM/Camera` | `phone-dcim-camera` | `/data/mobile-ingest/phone/dcim-camera` | Send-only (phone) |
| `Pictures` | `phone-pictures` | `/data/mobile-ingest/phone/pictures` | Send-only (phone) |
| `Movies` | `phone-movies` | `/data/mobile-ingest/phone/movies` | Send-only (phone) |
| `Documents/Exports/Contacts` | `phone-contacts-export` | `/data/mobile-ingest/phone/contacts-export` | Send-only (phone) |
| `Documents/Exports/Messages` | `phone-messages-export` | `/data/mobile-ingest/phone/messages-export` | Send-only (phone) |
| `Documents/Exports/Tasks` | `phone-tasks-export` | `/data/mobile-ingest/phone/tasks-export` | Send-only (phone) |

### 16.3 Receiver Rules (K3s side)

1. Receiver is `Receive Only`.
2. Versioning enabled on receiver (trashcan/simple versioning).
3. Daily integrity check for changed files and stale sync errors.
4. Disk threshold alerts integrated into existing monitoring.

### 16.4 Retention Baseline

- Media folders: keep full history on NFS by storage policy.
- Export folders: keep rolling 90 days minimum.
- No silent deletion from receiver side without explicit retention job.

### 16.5 Validation

1. Create one test file in each mapped folder on device.
2. Verify arrival in exact K3s target path.
3. Verify unchanged hash after transfer.
4. Verify retry behavior after temporary network loss.

## 17. Auto-Update Model (Playstore-like UX, no Play Store app)

### 17.1 Goal

- Central update view with pending updates, version delta, and install status.
- Daily automatic checks and one-tap update flow.
- Keep hard rule: no Google Play Store app on device.

### 17.2 Update Stack

1. F-Droid client (or Droid-ify/Neo-Store frontend) for F-Droid repositories.
2. Obtainium for GitHub/GitLab/direct-release apps.
3. AppManager for audit/export of installed APK versions and signatures.

### 17.3 Recommended UX Configuration

- Set one dedicated "Updates" folder on home screen:
  - F-Droid/Droid-ify
  - Obtainium
  - AppManager
- Enable daily background checks in F-Droid frontend and Obtainium.
- Enable notifications:
  - `updates available`
  - `update failed`
  - `signature mismatch`
- Keep battery optimization disabled for update managers.

### 17.4 Policy by App Type

- OSS apps from F-Droid repos:
  - Auto-check daily
  - Auto-install if signature and repo match policy
- OSS apps from direct upstream releases:
  - Obtainium auto-check daily
  - Auto-install allowed only for trusted maintainers
- Proprietary exception (Messenger):
  - Update path must stay explicit and audited (no silent unknown-source chain)
  - Record source + version in change notes

### 17.5 Safety Controls

1. Enforce signature verification (never downgrade to unsigned/unknown signer).
2. Block installer permissions for non-approved updater apps.
3. Weekly export of package list (`name`, `version`, `signer`) via AppManager.
4. If update source changes signer unexpectedly: block and review manually.

### 17.6 Operational Baseline

- Check window: daily at fixed time.
- Install window: optional nightly maintenance window.
- Failure handling:
  - retry once automatically
  - if still failing, keep current version and raise local notification

## 18. Preconfigured Update Sources (All Integrated Apps)

### 18.1 Source Matrix

| App | Source | Update Manager | Check | Install Mode |
|---|---|---|---|---|
| Lawnchair | GitHub Releases (official maintainers) | Obtainium | daily | auto-install |
| FlorisBoard | F-Droid repo | F-Droid frontend | daily | auto-install |
| OpenContacts / Fossify Contacts | F-Droid repo | F-Droid frontend | daily | auto-install |
| Fossify Phone / Koler | F-Droid repo | F-Droid frontend | daily | auto-install |
| Fossify Messages / QKSMS | F-Droid repo | F-Droid frontend | daily | auto-install |
| Syncthing | F-Droid repo | F-Droid frontend | daily | auto-install |
| AFWall+ | F-Droid repo | F-Droid frontend | daily | auto-install |
| Organic Maps | F-Droid repo | F-Droid frontend | daily | auto-install |
| Aegis | F-Droid repo | F-Droid frontend | daily | auto-install |
| Termux | F-Droid repo | F-Droid frontend | daily | auto-install |
| Tailscale | GitHub Releases (official) | Obtainium | daily | auto-install |
| AppManager | F-Droid repo | F-Droid frontend | daily | auto-install |
| Obtainium | F-Droid repo | F-Droid frontend | daily | auto-install |
| F-Droid frontend (Droid-ify/Neo-Store/F-Droid) | F-Droid repo | self-update | daily | manual-confirm |
| Facebook Messenger (exception) | trusted signed APK channel (audited) | manual + reminder | daily reminder | manual-install |
| Pixel Camera port (optional) | pinned trusted release source | Obtainium | weekly | manual-confirm |

### 18.2 Base Configuration Profile

Set once after fresh flash:

1. F-Droid frontend:
- add required repos
- enable daily index refresh
- enable update notifications
- auto-install for whitelisted OSS apps

2. Obtainium:
- add official release URLs for Lawnchair and Tailscale
- enable daily checks
- require signature match
- auto-install only for trusted maintainers

3. AppManager:
- weekly export of installed package inventory (`app`, `version`, `signer`)
- alert on signer change

### 18.3 Messenger Exception Rule

- Keep hard rule: no Google Play Store app.
- Messenger updates are handled as audited manual exception.
- Each Messenger update requires:
  1. source verification
  2. signature verification
  3. changelog note in device operation log
