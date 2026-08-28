# Trazabilidad de arquitectura

Mapa de afirmaciones hacia fuentes ejecutables. ADR explica intención; código/IaC confirma contrato.

| Área | Fuente primaria | Evidencia |
|---|---|---|
| Topología GCP | `service/packages/infra/envs/{dev,prod}/{main,platform}.tf` | módulos Firestore, Firebase/GCIP, Cloud Run, Pub/Sub, Tasks, Storage, monitoring y networking |
| Estado PROD | `service/packages/infra/envs/prod/terraform.tfvars` | `runtime_enabled=false`, registry `provisioning`, tres workloads y rutas internas |
| Aislamiento tenant | `service/packages/backend/src/infra/firestore/tenant-scoped-firestore.ts` | paths forzados bajo `tenants/{HospitalCode}` |
| Inventario Firestore | `service/packages/backend/src/infra/firestore/tenant-data-inventory.ts` | 19 colecciones tenant y subcolecciones `revisions`/`result` |
| Rules | `service/packages/backend/firestore.rules` | deny-all para clientes; Admin SDK no depende de Rules |
| Identidad humana | `service/packages/backend/src/identity/` | Firebase token, `firebase.tenant`, registry, membership y guards |
| Identidad servicio | `service/packages/backend/src/identity/infra/google-service-oidc-verifier.ts` | OIDC, audience y principal esperados para Pub/Sub/Tasks |
| API | `service/packages/backend/src/**/api/*.controller.ts` | rutas públicas, clínicas e internas |
| Fuente clínica | `service/packages/backend/src/ingestion/infra/firestore-raw-form-response.repository.ts` | create-only, hash e idempotencia |
| Ingesta | `service/packages/backend/src/ingestion/` | Pub/Sub push, allowlist Form, mapping, raw, epicrisis y dispatch |
| Generación | `service/packages/backend/src/documents/` | transform, DOCX, drafts, versiones, PDF y entrega |
| Modelo core | `service/packages/backend/src/infra/firestore/codecs/*.ts` | schemas versionados, exact-key, estados, revisiones y timestamps |
| Storage | `service/packages/infra/modules/storage/` | buckets versionados, IAM mínimo, sin list para runtimes clínicos |
| IAM | `service/packages/infra/modules/iam/` | service accounts por workload, `signBlob` y `signJwt` mínimos |
| Delivery | `service/docs/adr/0003-cloud-build-delivery.md`, `service/docs/adr/0005-automated-dev-delivery.md` | Cloud Build publica y despliega digest en DEV; Terraform conserva infraestructura y plan aprobado |
| Forms/DWD | `service/docs/adr/0002-forms-dwd-ownership.md` | DWD sin keys, subject/mapping server-side, scopes mínimos |
| Multitenancy | `service/docs/adr/0001-single-project-multi-hospital.md` | proyecto único por ambiente, tenants GCIP y paths clínicos |
| Raw source | `service/docs/adr/0004-raw-form-responses-as-clinical-source.md` | respuesta cruda inmutable y cadena de correcciones |

## Regla de interpretación

Cuando documentación histórica contradice código actual, priorizar en orden:

1. seguridad y contratos runtime probados;
2. Terraform de ambiente y módulos;
3. ADR aceptados;
4. planes y documentos históricos.
