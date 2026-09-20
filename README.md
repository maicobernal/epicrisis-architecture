# Arquitectura de Epicrisis

Portal técnico autocontenido para entender plataforma Epicrisis moderna. Fuente de verdad:
`service/`, Terraform y contratos aceptados en ADR. Sistema legacy aparece sólo como frontera de
migración.

## Abrir

- Producción: <https://maicobernal.github.io/epicrisis-architecture/>.
- Local: abrir [`index.html`](index.html) en navegador moderno.
- Sin build, servidor ni JavaScript. Cada diagrama es HTML + SVG inline.

## Contenido

| Vista | Pregunta respondida |
|---|---|
| [`01-componentes.html`](01-componentes.html) | ¿Qué componentes GCP y aplicaciones existen? |
| [`02-secuencias.html`](02-secuencias.html) | ¿Cómo ocurren login, ingesta y generación? |
| [`03-flujos-datos.html`](03-flujos-datos.html) | ¿Qué datos atraviesan cada etapa y dónde persisten? |
| [`04-seguridad.html`](04-seguridad.html) | ¿Cuáles son fronteras de confianza y controles? |
| [`05-firestore.html`](05-firestore.html) | ¿Cómo se organiza modelo Firestore? |
| [`06-trazabilidad.html`](06-trazabilidad.html) | ¿Qué archivo de código respalda cada afirmación? |
| [`07-cicd.html`](07-cicd.html) | ¿Cómo una PR entrega backend, frontend e infraestructura a DEV? |
| [`source-map.md`](source-map.md) | Fuente Markdown de trazabilidad para revisión en Git |

## Convenciones

- Cyan: cliente/orquestación.
- Verde: servicios de aplicación.
- Violeta: persistencia.
- Ámbar: servicios GCP/Workspace administrados.
- Rosa: identidad, seguridad y límites de confianza.
- Naranja: eventos, Pub/Sub y Cloud Tasks.
- Flecha continua: llamada síncrona.
- Flecha punteada: escritura, evento o control asíncrono.

## Alcance y estado

- Arquitectura objetivo implementada en `service/` y declarada en Terraform.
- DEV tiene runtime desplegable. PROD clínico permanece pre-live: `runtime_enabled=false` y
  `tenant_registry_status=provisioning` en IaC. Diagramas muestran topología objetivo y marcan
  explícitamente estado PROD; no afirman que recursos clínicos estén activos.
- No incluye secretos, tokens, PHI, IDs de paciente, URLs firmadas ni valores de configuración
  sensibles.
- Clasificación de publicación: public-safe. Detalle operativo interno, evidencias live y datos de
  seguridad sensibles permanecen fuera de esta carpeta.
- Repo público `maicobernal/epicrisis-architecture` es mirror generado. Fuente editable y review
  permanecen en esta carpeta; workflow despliega sólo después de merge a `develop`.
- Fecha de corte documental: 2026-09-20.

## Mantenimiento

Actualizar diagramas en mismo PR cuando cambie cualquiera de estos contratos:

1. módulos o `terraform.tfvars` de `service/packages/infra/`;
2. controllers, guards, repositories o codecs del backend;
3. inventario `tenant-data-inventory.ts`;
4. ADR de multitenancy, Forms, delivery o registro clínico fuente;
5. rutas de Hosting, Pub/Sub, Cloud Tasks o Cloud Run.

Antes de merge: ejecutar `bash architecture/validate.sh`.
