# PLANETONYX Store App (MVP -> v1)

## Ziel

Eine eigene Android-App als Frontend fuer den self-hosted App Catalog:
- kein Google Play Store
- nur signierte Pakete
- Updates aus `appstore.srv.planetonyx.net`

## Produktname

- App-Name: `PLANETONYX Store`
- Paket-ID Vorschlag: `net.planetonyx.store`

## MVP-Funktionen (Pflicht)

1. Catalog laden (`/index.json`)
2. App-Liste mit Suche/Filter (Name, Version, Channel)
3. App-Detailseite mit:
- Version
- Changelog-Link
- Source-Repo-Link
- SHA256
4. Download + SHA256-Pruefung vor Installation
5. Installation ueber Android Package Installer
6. Manuelle Update-Pruefung fuer installierte Apps

## Sicherheitsmodell

1. Nur HTTPS-Endpunkt des eigenen Catalogs zulassen
2. SHA256 vor Installation verifizieren (hartes Fail bei Mismatch)
3. Optional in v1: zusaetzliche Signaturpruefung (`.sig`) gegen bekannten Public Key
4. Keine stillen Hintergrundinstallationen

## UX-Fokus

1. Sehr klare Statusanzeige: `Verfuegbar`, `Installiert`, `Update verfuegbar`, `Fehlgeschlagen`
2. Einfache Fehlertexte (DNS/Timeout/Checksum)
3. Offline-freundlich: letzter Catalog lokal cachen

## API-Vertrag (MVP)

- Basis: `https://appstore.srv.planetonyx.net`
- Catalog: `GET /index.json`
- Artefakte: `GET /artifacts/apps/<app-id>/<version>/<app-id>.apk`

## Technische Basis (empfohlen)

1. Android native (Kotlin + Jetpack Compose)
2. HTTP: `OkHttp`
3. JSON: `kotlinx.serialization`
4. Background update check: `WorkManager`
5. Local cache: `Room` oder einfacher File-Cache fuer MVP

## Roadmap

## Phase 1 (MVP)

1. Catalog lesen und anzeigen
2. Download + SHA256 + Installer
3. Update-Check auf App-Ebene

## Phase 2 (v1)

1. Hintergrund-Update-Check mit Notification
2. Signaturpruefung mit Public Key
3. Channel-Umschaltung (`stable`, `beta`)

## Phase 3 (v1.1)

1. Mehrere Repos (intern + optional extern)
2. Delta-Updates (wenn sinnvoll)
3. Telemetrie nur lokal/self-hosted (opt-in)

## Nicht-Ziele (aktuell)

1. Eigene Binary-Diff Engine
2. Silent Install ohne User-Interaktion
3. Play-Services-Abhaengigkeiten

