# PLANETONYX Mobile - Avicii K3s Service Map

Stand: 2026-03-26
Zielgeraet Phase 1: OnePlus AC2003 (`avicii`)
Phase 2 spaeter: Xiaomi Poco X3 Pro (`vayu`)

## 1) Live K3s Baseline (abgefragt)

1. Cluster-Nodes: alle `Ready` (cp01/cp02/cp03/wk01/wk02)
2. Ingress-Adresse: `10.188.50.17` (Traefik)
3. Relevante Namespaces fuer Smartphone:
- `apps`
- `media`
- `monitoring` (nur lesend/ops)

## 2) Smartphone -> K3s Abbildung

1. Foto-/Video-Backup
- Phone-App: Syncthing
- Ziel in Plattform: K3s-Sync-Receiver/NFS-Chain (bestehendes Mapping)
- Zweck: Ersatz fuer Google Photos Cloud Sync

2. Dokumente/Office/Dateien
- Phone-App: Browser/Nextcloud-Client (spaeter)
- K3s Endpoint: `nextcloud.srv.planetonyx.net`
- Zweck: Ersatz fuer Google Drive Use-Case

3. Medien (Video/Request)
- Phone-App: Jellyfin App
- K3s Endpoints:
  - `jellyfin.srv.planetonyx.net`
  - `jellyfin-arr.srv.planetonyx.net`
- Zweck: internes Streaming + Request-Workflow

4. Suche/Knowledge
- Phone-App: Browser + optional custom store integration
- K3s Endpoint: `searxng.srv.planetonyx.net`
- Zweck: Suchfunktion ohne Google Search App

5. Dokumentenarchiv
- Phone-App: Browser
- K3s Endpoint: `paperless.srv.planetonyx.net`
- Zweck: Beleg-/Dokumentzugriff mobil

6. Fotoverwaltung intern
- Phone-App: Browser / spaeter native client
- K3s Endpoint: `immich.srv.planetonyx.net`
- Zweck: interner Foto-Stack

7. Operations/Portal (optional nur admin)
- Phone-App: Browser
- K3s Endpoints:
  - `cmdb.srv.planetonyx.net`
  - `portainer.srv.planetonyx.net`
  - `grafana.srv.planetonyx.net`
- Zweck: Admin/Ops, nicht fuer normalen Daily-Use

## 3) App-Ersatzstatus fuer avicii (Phase 1)

1. Bereits gut abgedeckt:
- Keyboard: FlorisBoard
- Launcher: Lawnchair
- OTP: Aegis
- Sync: Syncthing
- Calendar: Etar
- Maps: Organic Maps (noch Build-Pipeline nachziehen)

2. Noch final zu schliessen:
- Mail: K-9 Pipeline stabilisieren (Java 21 Requirement bereits umgesetzt)
- Contacts/Phone/SMS: Fossify Trio in Store-Pipeline bringen
- Browser: Fennec in Pipeline bringen
- Gallery: Fossify Gallery in Pipeline bringen

## 4) Phase-1 Release Guardrail

1. `avicii` bleibt einziges aktives Test-/Releasegeraet.
2. `poco` bleibt geplant, aber erst nach stabilem Phase-1 Gate.
3. Neue Features zuerst gegen `avicii` validieren, dann Transfer-Checklist fuer `poco`.
