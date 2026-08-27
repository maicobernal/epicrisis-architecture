#!/usr/bin/env bash
set -euo pipefail

architecture_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

required=(
  index.html
  01-componentes.html
  02-secuencias.html
  03-flujos-datos.html
  04-seguridad.html
  05-firestore.html
  06-trazabilidad.html
  README.md
  source-map.md
)

for file in "${required[@]}"; do
  test -s "${architecture_dir}/${file}"
done

for html in "${architecture_dir}"/*.html; do
  rg -q '<!DOCTYPE html>' "${html}"
  rg -q '<meta name="viewport"' "${html}"
  rg -q '<svg' "${html}" || [[ "$(basename "${html}")" == "index.html" ]]
  rg -q '</html>' "${html}"
  if rg -n '<script|javascript:|https?://[^" ]+\.js' "${html}"; then
    echo "JavaScript no permitido en ${html}" >&2
    exit 1
  fi
done

for link in 01-componentes.html 02-secuencias.html 03-flujos-datos.html 04-seguridad.html 05-firestore.html 06-trazabilidad.html; do
  rg -Fq "href=\"${link}\"" "${architecture_dir}/index.html"
done

rg -Fq 'runtime_enabled=false' "${architecture_dir}/README.md"
rg -Fq 'tenant_registry_status=provisioning' "${architecture_dir}/README.md"

echo "Architecture portal validated: ${#required[@]} required files"
