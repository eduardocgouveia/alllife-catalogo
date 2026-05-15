#!/usr/bin/env bash
# Sincroniza os arquivos do catálogo do entregável (canônico) com este repo público.
# Uso: ./sync.sh [mensagem-commit]

set -e

SRC="/Users/eduardogouveia/Documents/ATACAMA DIGITAL/05-CLIENTES/All-Life-Institute/04-ENTREGAVEL/CATALOGO-PRODUTOS-SERVICOS_2026-05-11/2026-05-11"
DST="$(cd "$(dirname "$0")" && pwd)"
MSG="${1:-chore: sync from entregavel}"

if [ ! -d "$SRC" ]; then
  echo "✗ Pasta original não encontrada: $SRC"
  exit 1
fi

echo "→ copiando de: $SRC"
echo "→ destino:     $DST"

rsync -av --delete \
  --exclude='.git/' \
  --exclude='.gitignore' \
  --exclude='README.md' \
  --exclude='sync.sh' \
  --exclude='.DS_Store' \
  "$SRC/" "$DST/"

cd "$DST"

if [ -z "$(git status --porcelain)" ]; then
  echo "✓ Nada novo. Repo já está sincronizado."
  exit 0
fi

git add -A
git commit -m "$MSG"
git push origin main

echo "✓ Sync concluído e enviado pro GitHub."
echo "→ https://eduardocgouveia.github.io/alllife-catalogo/"
