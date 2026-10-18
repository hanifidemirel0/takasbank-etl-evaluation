import sys

FIXES = [
    ("rapordan kaynakta lineage", "rapordan kaynağa lineage"),
    ("rapordan kaynakla lineage", "rapordan kaynağa lineage"),
    ("dbt kaynağı tanımlı zamanlayıcı", "dbt kaynağı olarak tanımlı zamanlayıcı"),
    ("Exadata staging ve ODS katmanına çoğalttır", "Exadata staging ve ODS katmanına çoğaltır"),
]

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
for old, new in FIXES:
    text = text.replace(old, new)
open(path, "w", encoding="utf-8").write(text)
