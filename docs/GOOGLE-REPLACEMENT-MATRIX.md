# PLANETONYX Mobile - Google Replacement Matrix

Stand: 2026-03-26
Ziel: Google-Apps durch OSS-first Apps ersetzen und in den PLANETONYX App Store bringen.

## 1) Kernersatz pro Google-Bereich

1. Keyboard (Gboard) -> FlorisBoard
2. Launcher (Pixel Launcher) -> Lawnchair
3. Contacts (Google Kontakte) -> Fossify Contacts
4. Phone (Google Telefon) -> Fossify Phone
5. SMS (Google Messages) -> Fossify Messages
6. Authenticator -> Aegis
7. File Sync / Cloud Sync (Google Drive Sync use-case) -> Syncthing Android
8. App Updates / App Discovery (Play Store use-case) -> PLANETONYX Store App + optional Obtainium
9. Maps -> Organic Maps
10. Browser (Chrome) -> Fennec
11. Mail (Gmail) -> K-9 Mail + FairEmail (optional second candidate)
12. Calendar (Google Kalender) -> Etar
13. Photos/Gallery (Google Photos) -> Fossify Gallery
14. Notes (Google Keep) -> Quillpad
15. Tasks (Google Tasks) -> Tasks.org
16. Password Manager (Google Passwortmanager) -> KeePassDX
17. Voice/Meeting (Google Meet) -> Jitsi Meet
18. Docs/Office (Google Docs basic use-case) -> Collabora Office

## 2) Ausnahme/Policy

1. Facebook Messenger bleibt `manual_exception`.
2. Keine Play-Store-Abhaengigkeit.
3. Jede App muss signiert im Store-Flow sein (SHA + Sig + Metadata).

## 3) Rollout-Reihenfolge fuer Store-Befuellung

1. Wave A1 (kommunikation + core UX): Fossify Contacts, Fossify Phone, Fossify Messages
2. Wave A2 (daily productivity): K-9 Mail, Etar, Tasks.org, KeePassDX
3. Wave B1 (media/navigation): Fossify Gallery, Organic Maps, Jitsi Meet
4. Wave B2 (power/ops): Termux, AppManager, Obtainium
