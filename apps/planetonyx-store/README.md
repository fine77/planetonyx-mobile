# PLANETONYX Store App

Android Client fuer den PLANETONYX App Catalog.

## Scope

- Catalog lesen
- APK laden
- Checksum verifizieren
- Installation ueber System Installer
- Updates anzeigen

## Datenfluss

1. App ruft `https://appstore.srv.planetonyx.net/index.json` ab
2. User waehlt App-Version
3. Download von `artifact_url`
4. SHA256-Abgleich gegen Catalog
5. Installer-Intent starten

## Build-Plan

1. Android Studio Projekt initialisieren (Kotlin, Compose, minSdk passend zu Zielgeraet)
2. Core Module:
- `catalog` (API + parser)
- `download` (stream + hash)
- `install` (package installer bridge)
- `updates` (installed packages gegen catalog)
3. UI:
- Home (Liste)
- Details
- Downloads
- Installed/Updates

## Definition of Done (MVP)

1. Zwei Apps aus dem eigenen Catalog installierbar
2. Checksum mismatch blockiert Installation
3. Update-Hinweis funktioniert fuer installierte App
4. Keine Google Play Services erforderlich

