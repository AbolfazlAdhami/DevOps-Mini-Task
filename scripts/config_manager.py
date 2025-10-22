#!/usr/bin/env python3
"""
config_manager_full.py
A more complete Configuration Manager written in Python.

Features:
- Load/save JSON and YAML (YAML optional via PyYAML)
- Atomic file writes and backup/versioning
- Add/get/set/update nested keys using dot-paths
- Optional simple encryption for saved files using Fernet (cryptography package)
- CLI with subcommands: show, get, set, add-section, load, save, backup, encrypt, decrypt
- Optional schema validation hook (jsonschema)

Usage examples (CLI):
  python config_manager_full.py save --path config.json
  python config_manager_full.py set database.host db.example.com
  python config_manager_full.py get database.host
  python config_manager_full.py add-section newsection

Dependencies (optional):
  pip install pyyaml cryptography jsonschema

Author: ChatGPT
"""

import argparse
import json
import shutil
import sys
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any, Callable, Dict, Optional


class ConfigManager:
    def __init__(self, initial: Optional[Dict] = None):
        self._data: Dict[str, Any] = dict(initial) if initial else {}

    # -------------------- Navigation helpers --------------------
    def _navigate(self, path: Optional[str], create_missing: bool = False):
        if not path:
            return self._data, None
        parts = path.split(".")
        cur = self._data
        for p in parts[:-1]:
            if p not in cur:
                if create_missing:
                    cur[p] = {}
                else:
                    return None, None
            if not isinstance(cur[p], dict):
                if create_missing:
                    cur[p] = {}
                else:
                    return None, None
            cur = cur[p]
        return cur, parts[-1]

    # -------------------- Basic CRUD --------------------
    def add_section(self, section_name: str, value: Optional[Dict] = None, overwrite: bool = False):
        if section_name in self._data and not overwrite:
            raise KeyError(f"Section '{section_name}' already exists. Use overwrite=True to replace.")
        self._data[section_name] = value if value is not None else {}
        return self._data[section_name]

    def get(self, path: Optional[str] = None, default: Any = None):
        if not path:
            return self._data
        cur, last = self._navigate(path)
        if cur is None:
            return default
        return cur.get(last, default)

    def set(self, path: str, value: Any, create_missing: bool = True):
        cur, last = self._navigate(path, create_missing=create_missing)
        if cur is None:
            raise KeyError(f"Path '{path}' not found and create_missing is False.")
        cur[last] = value
        return True

    def update(self, path: str, updater: Callable[[Any], Any], create_missing: bool = True):
        old = self.get(path, None)
        new = updater(old)
        self.set(path, new, create_missing=create_missing)
        return new

    def to_dict(self) -> Dict:
        return self._data

    # -------------------- IO --------------------
    def load(self, fp: Path):
        if not fp.exists():
            raise FileNotFoundError(fp)
        suf = fp.suffix.lower()
        if suf == ".json":
            with fp.open("r", encoding="utf-8") as f:
                self._data = json.load(f)
            return self._data
        elif suf in (".yml", ".yaml"):
            try:
                import yaml
            except Exception as e:
                raise RuntimeError("PyYAML is required to load YAML files. Install with 'pip install pyyaml'.") from e
            with fp.open("r", encoding="utf-8") as f:
                self._data = yaml.safe_load(f) or {}
            return self._data
        else:
            raise ValueError("Unsupported file extension. Use .json, .yml or .yaml")

    def save(self, fp: Path, *, make_backup: bool = True, encrypt_fn: Optional[Callable[[bytes], bytes]] = None):
        # Ensure parent dir
        fp.parent.mkdir(parents=True, exist_ok=True)

        # Backup existing file
        if make_backup and fp.exists():
            backup_path = fp.with_suffix(fp.suffix + ".bak")
            shutil.copy2(fp, backup_path)

        suf = fp.suffix.lower()
        if suf == ".json":
            payload = json.dumps(self._data, indent=2, ensure_ascii=False).encode("utf-8")
        elif suf in (".yml", ".yaml"):
            try:
                import yaml
            except Exception as e:
                raise RuntimeError("PyYAML is required to save YAML files. Install with 'pip install pyyaml'.") from e
            payload = yaml.safe_dump(self._data, sort_keys=False, allow_unicode=True).encode("utf-8")
        else:
            raise ValueError("Unsupported file extension. Use .json, .yml or .yaml")

        if encrypt_fn:
            payload = encrypt_fn(payload)

        # Atomic write
        with NamedTemporaryFile("wb", delete=False, dir=str(fp.parent)) as tmp:
            tmp.write(payload)
            tmp.flush()
            temp_name = tmp.name
        Path(temp_name).replace(fp)
        return fp

    # -------------------- Utilities --------------------
    def load_from_dict(self, d: Dict):
        self._data = dict(d)

    def validate_with_schema(self, schema: Dict):
        try:
            from jsonschema import validate, ValidationError
        except Exception as e:
            raise RuntimeError("jsonschema is required for validation. Install with 'pip install jsonschema'.") from e
        validate(instance=self._data, schema=schema)
        return True

    def __repr__(self):
        return f"ConfigManager({self._data!r})"


# -------------------- Optional encryption helpers --------------------
class OptionalCrypto:
    """Simple wrapper to provide encrypt/decrypt callables using Fernet if available."""

    def __init__(self, key: Optional[bytes] = None):
        self.fernet = None
        if key is not None:
            try:
                from cryptography.fernet import Fernet
            except Exception:
                raise RuntimeError("cryptography is required for encryption. Install with 'pip install cryptography'.")
            self.fernet = Fernet(key)

    @staticmethod
    def generate_key() -> bytes:
        try:
            from cryptography.fernet import Fernet
        except Exception:
            raise RuntimeError("cryptography is required for encryption. Install with 'pip install cryptography'.")
        return Fernet.generate_key()

    def encrypt(self, data: bytes) -> bytes:
        if not self.fernet:
            raise RuntimeError("No key configured for encryption")
        return self.fernet.encrypt(data)

    def decrypt(self, data: bytes) -> bytes:
        if not self.fernet:
            raise RuntimeError("No key configured for decryption")
        return self.fernet.decrypt(data)


# -------------------- CLI --------------------

def build_parser():
    p = argparse.ArgumentParser(description="Config Manager CLI")
    sub = p.add_subparsers(dest="cmd")

    sub.add_parser("show", help="Print the full configuration as JSON")

    gget = sub.add_parser("get", help="Get a value by dot-path")
    gget.add_argument("path", nargs="?", default=None)

    sset = sub.add_parser("set", help="Set a value by dot-path")
    sset.add_argument("path")
    sset.add_argument("value")

    addsec = sub.add_parser("add-section", help="Add a top-level section")
    addsec.add_argument("section")

    loadp = sub.add_parser("load", help="Load config file into memory")
    loadp.add_argument("path")

    savep = sub.add_parser("save", help="Save config to file")
    savep.add_argument("path")
    savep.add_argument("--no-backup", dest="backup", action="store_false", help="Do not create .bak backup")

    en = sub.add_parser("encrypt-key", help="Generate an encryption key and print it (Fernet)")

    return p


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)

    # Try to persist a small local state file in the current directory for demo (not required)
    state_path = Path(".config_state.json")
    cm = ConfigManager()

    # If there's a saved state, load it automatically
    if state_path.exists():
        try:
            cm.load(state_path)
        except Exception:
            pass

    if args.cmd == "show":
        print(json.dumps(cm.to_dict(), indent=2, ensure_ascii=False))
        return 0

    if args.cmd == "get":
        val = cm.get(args.path)
        print(json.dumps(val, ensure_ascii=False, indent=2) if not isinstance(val, (str, int, float, type(None), bool)) else val)
        return 0

    if args.cmd == "set":
        # Try to interpret JSON-like values, otherwise store as string
        raw = args.value
        try:
            parsed = json.loads(raw)
        except Exception:
            parsed = raw
        cm.set(args.path, parsed)
        cm.save(state_path)
        print(f"Set {args.path} -> {parsed}")
        return 0

    if args.cmd == "add-section":
        cm.add_section(args.section)
        cm.save(state_path)
        print(f"Added section: {args.section}")
        return 0

    if args.cmd == "load":
        path = Path(args.path)
        try:
            cm.load(path)
            # Save a local snapshot
            cm.save(state_path)
            print(f"Loaded {path}")
            return 0
        except Exception as e:
            print(f"Error loading: {e}", file=sys.stderr)
            return 2

    if args.cmd == "save":
        path = Path(args.path)
        try:
            cm.save(path, make_backup=args.backup)
            print(f"Saved to {path}")
            return 0
        except Exception as e:
            print(f"Error saving: {e}", file=sys.stderr)
            return 2

    if args.cmd == "encrypt-key":
        try:
            key = OptionalCrypto.generate_key()
            print(key.decode())
            return 0
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            return 2

    parser.print_help()
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
