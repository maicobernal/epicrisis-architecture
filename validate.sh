#!/usr/bin/env bash
set -euo pipefail

architecture_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v rg >/dev/null 2>&1; then
  contains_regex() { rg -q -- "$1" "$2"; }
  contains_fixed() { rg -Fq -- "$1" "$2"; }
  report_regex() { rg -n -- "$1" "$2"; }
else
  contains_regex() { grep -Eq -- "$1" "$2"; }
  contains_fixed() { grep -Fq -- "$1" "$2"; }
  report_regex() { grep -En -- "$1" "$2"; }
fi

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
  contains_regex '<!DOCTYPE html>' "${html}"
  contains_regex '<meta name="viewport"' "${html}"
  contains_regex '<svg' "${html}" || [[ "$(basename "${html}")" == "index.html" || "$(basename "${html}")" == "06-trazabilidad.html" ]]
  contains_regex '</html>' "${html}"
  if report_regex '<script|javascript:|https?://[^" ]+\.js' "${html}"; then
    echo "JavaScript no permitido en ${html}" >&2
    exit 1
  fi
done

for link in 01-componentes.html 02-secuencias.html 03-flujos-datos.html 04-seguridad.html 05-firestore.html 06-trazabilidad.html; do
  contains_fixed "href=\"${link}\"" "${architecture_dir}/index.html"
done

contains_fixed 'runtime_enabled=false' "${architecture_dir}/README.md"
contains_fixed 'tenant_registry_status=provisioning' "${architecture_dir}/README.md"

echo "Architecture portal validated: ${#required[@]} required files"
