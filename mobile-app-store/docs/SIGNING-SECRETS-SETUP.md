# PLANETONYX Mobile - Signing Secrets Setup

This document defines the required GitHub Actions secrets for signed app builds.

## Required Secrets

- `SIGNING_KEYSTORE_B64`  
  Base64 content of the Android keystore file.
- `SIGNING_KEY_ALIAS`  
  Key alias inside the keystore.
- `SIGNING_KEYSTORE_PASS`  
  Keystore password.
- `SIGNING_KEY_PASS`  
  Key password.

## Optional Secret

- `DETACHED_SIGN_KEY_B64`  
  Base64 content of a PEM private key for detached `.sig` generation.

If omitted, pipeline writes a placeholder `.sig` file.

## Local Preparation

Encode keystore:
```bash
base64 -w0 release.keystore > SIGNING_KEYSTORE_B64.txt
```

Encode detached private key:
```bash
base64 -w0 detached-sign-key.pem > DETACHED_SIGN_KEY_B64.txt
```

## Runtime Behavior

Pipeline decodes secrets to:
- `/tmp/planetonyx-release.keystore`
- `/tmp/planetonyx-detached-sign.pem` (optional)

and exports:
- `SIGNING_KEYSTORE_PATH`
- `DETACHED_SIGN_KEY_PATH` (optional)

No signing material is committed to git.
