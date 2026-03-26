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

1. Core Module:
- `catalog` (API + parser)
- `download` (stream + hash)
- `install` (package installer bridge)
- `updates` (installed packages gegen catalog)
2. UI:
- Home (Liste)
- Details
- Downloads
- Installed/Updates

## Aktueller Stand

MVP Scaffold ist vorhanden:
- Kotlin + Compose App
- Catalog Fetch gegen `index.json`
- App-Liste + Refresh
- "Open APK URL" als Installations-Bridge-Grundlage

## Start in Android Studio

1. Ordner `apps/planetonyx-store` als Projekt oeffnen
2. `local.properties` mit SDK-Pfad setzen (Android Studio macht das i.d.R. selbst)
3. Run auf Testgeraet

## Definition of Done (MVP)

1. Zwei Apps aus dem eigenen Catalog installierbar
2. Checksum mismatch blockiert Installation
3. Update-Hinweis funktioniert fuer installierte App
4. Keine Google Play Services erforderlich
