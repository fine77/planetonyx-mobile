# PLANETONYX Mobile - App Portfolio und Build Queue

Stand: 2026-03-26
Ziel: App-Store gezielt mit den wirklich benoetigten Apps fuellen.

## 1) Prioritaet A (sofort in Store)

1. FlorisBoard
2. Lawnchair
3. Syncthing
4. AFWall+
5. Aegis
6. Fossify Contacts
7. Fossify Phone
8. Fossify Messages

Begruendung:
- Kernfunktion fuer daily use + Security Baseline
- klarer Nutzen fuer avicii/poco pilot
- passt zur bestehenden OSS-Policy ohne Play Store

## 2) Prioritaet B (nach Stabilisierung A)

1. Organic Maps
2. AppManager
3. Obtainium
4. Neo Store (oder Droid-ify/F-Droid Frontend)
5. Termux
6. Koler (Alternative Dialer)
7. OpenContacts (Alternative Contacts)

## 3) Ausnahme-Apps (nicht regulär in OSS-Store)

1. Facebook Messenger

Regel:
- bleibt manuell/auditiert (Policy-Exception)
- nicht als normaler OSS-Store Standardpfad behandeln

## 4) App-Store Befuellungsstrategie

Pro App immer gleich:
1. `precheck_only=true` fahren (Tag + Signing + Guard)
2. Full Build nur bei gruenem Precheck
3. Artifact + SHA + Signature im Catalog veroeffentlichen
4. Kurztest auf Geraet (Install/Update)

## 5) Definition "fertig im Store"

Eine App gilt als "im Store", wenn:
1. signiertes APK im Artifact-Pfad liegt
2. `index.json` korrekte Version + SHA + URL zeigt
3. Installation am Testgeraet erfolgreich war
4. Update-Check aus Store-Client funktioniert

## 6) No-Go Regeln

1. Keine Google Play Store Abhaengigkeit
2. Keine unsignierten APKs
3. Keine Full-Builds ohne erfolgreichen Precheck
4. Keine Mischung aus Incident-Reparatur und Architekturumbau

