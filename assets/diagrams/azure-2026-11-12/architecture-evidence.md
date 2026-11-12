# EcoMind Azure architecture — 12 November 2026

These current-state diagrams supplement the existing Sprint 1 architecture evidence. They do not replace the historical Render/Aiven diagrams and do not represent migration of the previous database. New demonstration records were created in Azure through the API.

## Deployment follow-up

The original diagrams below show the initial manually provisioned snapshot. The
[DevOps follow-up](../../evidence/iam-account-access/azure-devops-2026-11-12.md)
documents the later develop-to-Azure automation and its separate execution evidence.
The old diagram labels stating that automatic CD was not configured are historical;
they must not be read as the latest pipeline state.

## Views and editing

| File | Purpose |
| --- | --- |
| `ecomind-azure-architecture.drawio` | Editable three-page source |
| `ecomind-azure-container.drawio` | C4 Container view of the current mobile/API scope |
| `ecomind-azure-deployment.drawio` | Public ingress, private database network and global resources |
| `ecomind-azure-delivery.drawio` | Deployment, image authorization, secrets and observability |

The diagrams were created with the draw.io plugin using XML and its Azure shape search. Official Azure2 icons are referenced by their exact draw.io library URLs in `icon-sources.json`. The diagram source contains labels and resource metadata only, never credential values. Open the editable `.drawio` source in diagrams.net. The SVG exports embed their icons and an editable copy of the diagram.

## Evidence and architectural decisions

| Criterion | Source/evidence | Status and limitation |
| --- | --- | --- |
| Match the implemented decomposition | Backend modules and current infrastructure source | One Java 21 / Spring Boot monolith containing IAM, Users, Quests, Community, Gamification, Learning and Monetization. Modules are not separately deployed services. |
| Separate software ownership and hosting | Current client/backend sources and existing report C4 source | Both mobile applications, backend and shared database are inside EcoMind ownership. Email is an external managed dependency. The container view deliberately excludes unchanged landing, payment and map flows. |
| Use current regional networking | `infra/azure/foundation.bicep` and verified deployed resources | West US 2 VNet `10.42.0.0/16`; ACA delegated subnet `10.42.0.0/23`; PostgreSQL delegated subnet `10.42.2.0/28`. PostgreSQL public access is disabled. The global private DNS zone is linked to the VNet; no DNS Private Resolver is claimed. |
| Represent actual database protection | Application configuration and completed database validation | PostgreSQL 17, B1ms, 32 GiB, database `ecomind`, application role `ecomind_app`; verify-full TLS 1.3 was tested. |
| Keep identity and secrets claims precise | `application.bicep`, `application-resources.bicep`, `email.bicep` | UAMI `id-ecomind-api-pull` has AcrPull only at registry scope. ARM resolves Key Vault values into ACA native secrets during deployment. Runtime has no vault-wide read role. The mail connection string is generated server-side, not manually displayed in the diagram. |
| Represent the actual deployment process | GitHub CI run and verified ACA revision | CI tests and builds images. An operator explicitly builds/pushes/deploys the reviewed source. Automatic production CD/OIDC is not configured. New revision `ca-ecomind-api--0000001` is Healthy/Running with source `632111ca72c8b3c228f21c237172f8232ed41610`. |
| Separate configuration from delivery evidence | Azure mail resources and Gmail verification reported by the deployment owner | ACS mail adapter is active and the first registration verification message reached the Gmail inbox. This statement alone does not claim all password recovery, logout or client flows have passed. |
| Preserve honest operational scope | Completed deployment/job evidence | Temporary bootstrap/demo jobs completed and were removed. Unused failed-attempt East US 2 networking is omitted from the active path. Budget alerts are not a spending cap. |

Runtime image digest: `sha256:5de17b9c2efadbcda57fe997ec6c0a192450d6b87b754666a3901186f45b342d`.

Validation source: [backend CI run](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/actions/runs/43249454205).

The current managed email domain has a low default quota of five emails/minute and ten/hour. Azure Communication Services Email has a documented retirement date of 30 September 2028; that is a future provider lifecycle concern, not a claim that this deployment requires migration before the course's final delivery. References retained from the implementation documentation: [managed-domain quotas](https://learn.microsoft.com/azure/communication-services/concepts/service-limits#email) and [retirement notice](https://learn.microsoft.com/azure/communication-services/acs-retirement-and-breaking-changes-guide).

## Source provenance

Infrastructure source: [Azure feature branch](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/tree/feature/azure-container-apps/infra/azure). The hashes below identify the diagram-authoring snapshot; later template or documentation updates may differ.

| Source | SHA-256 |
| --- | --- |
| `infra/azure/foundation.bicep` | `ed86ec3ffb35a4bcb690af30e2d93e76ff0462e156bd67e101206375786aca06` |
| `infra/azure/network.bicep` | `3a848fcde6d4514d5687a89f847d488d43e50c12262acd67871f039c737e7e90` |
| `infra/azure/application.bicep` | `42e9975f20c5e8a14cd03569122810468c8b363522051bb9629e47cf34ee8efb` |
| `infra/azure/application-resources.bicep` | `49fcecc60fc4ddc85bd53492de27201eed0ade71e3445419fbbe372878abb6a4` |
| `infra/azure/email.bicep` | `1c8f68fd4243906aa9c91662465292eadd774cb300c81c81103ca307c16ec1d1` |
| `docs/azure-container-apps.md` | `aa2d330a0afcd9b63437c5dd07083f4430333c54359f19c891bd8b89f7adf3d2` |
| `docs/azure-email.md` | `b1d3bb95cc41ca099ef244398286ddfa0efe6506e51437fecc6256ba8e53247e` |

Academic preflight used the isolated CC238 course context, the current 202620 requirements as governing authority, the EcoMind report's existing `assets/diagrams/c4Containers.dsl` for historical comparison, and the architecture/design guidance in the course skills. The software design review kit's textual extraction was consulted for layering and service boundaries; this does not claim a complete visual review of every slide or an AV2 compliance certification. Delivery readiness remains a separate audit.

## Review

XML identifiers, parent/source/target references and file structure are checked locally. Visual review takes place in the real draw.io editor, with overlap/routing corrections applied to the source and recreated through the plugin. Export and independent review results are recorded in `validation.md` alongside these files.
