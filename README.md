# GEIL - GNTECH Enterprise Infrastructure Library

Private production-style engineering documentation for designing, implementing, operating, securing, monitoring, troubleshooting, and scaling GNTECH Microsoft enterprise infrastructure.

## Local preview

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
mkdocs serve
```

## Build validation

```bash
. .venv/bin/activate
mkdocs build --strict
```

Do not publish secrets, passwords, customer data, private keys, certificate exports, VPN profiles, tenant IDs, or routable internal inventories.
