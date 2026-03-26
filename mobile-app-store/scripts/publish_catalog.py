#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


def load_index(path: Path) -> dict:
    if not path.exists():
        return {"generated_at": "", "store_version": "1.0", "apps": []}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(data, dict):
            apps = data.get("apps")
            if not isinstance(apps, list):
                data["apps"] = []
            if "store_version" not in data:
                data["store_version"] = "1.0"
            return data
    except Exception:
        pass
    return {"generated_at": "", "store_version": "1.0", "apps": []}


def main() -> int:
    p = argparse.ArgumentParser(description="Update PLANETONYX Mobile app catalog index")
    p.add_argument("--metadata-index", required=True)
    p.add_argument("--app-id", required=True)
    p.add_argument("--name", required=True)
    p.add_argument("--channel", required=True)
    p.add_argument("--version", required=True)
    p.add_argument("--artifact-url", required=True)
    p.add_argument("--sha256", required=True)
    p.add_argument("--signature-url", required=True)
    p.add_argument("--source-repo", required=True)
    p.add_argument("--license", required=True)
    p.add_argument("--maintainer-mode", required=True)
    args = p.parse_args()

    idx_path = Path(args.metadata_index)
    idx_path.parent.mkdir(parents=True, exist_ok=True)
    index = load_index(idx_path)
    apps = index.get("apps", [])

    new_item = {
        "id": args.app_id,
        "name": args.name,
        "channel": args.channel,
        "version": args.version,
        "artifact_url": args.artifact_url,
        "sha256": args.sha256,
        "signature_url": args.signature_url,
        "source_repo": args.source_repo,
        "license": args.license,
        "maintainer_mode": args.maintainer_mode,
    }

    replaced = False
    for i, app in enumerate(apps):
        if isinstance(app, dict) and app.get("id") == args.app_id and app.get("channel") == args.channel:
            apps[i] = new_item
            replaced = True
            break
    if not replaced:
        apps.append(new_item)

    index["apps"] = sorted(
        [x for x in apps if isinstance(x, dict)],
        key=lambda x: (str(x.get("id", "")).lower(), str(x.get("channel", "")).lower()),
    )
    index["generated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    idx_path.write_text(json.dumps(index, ensure_ascii=True, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"ok": True, "index": str(idx_path), "app_id": args.app_id, "channel": args.channel}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
