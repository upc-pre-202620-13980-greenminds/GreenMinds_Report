# Azure runtime and demonstration data — November 12, 2026

## Scope

This supplement records the Azure validation environment for IAM. It does not replace
historical Sprint 1 Render/Aiven evidence or claim the whole AV2 delivery is complete.
The owner requested new demonstration data instead of waiting for the old provider.

API: https://ca-ecomind-api.icybush-bd135296.westus2.azurecontainerapps.io

Swagger: https://ca-ecomind-api.icybush-bd135296.westus2.azurecontainerapps.io/swagger-ui.html

## Verified data

Four reserved demonstration accounts/profiles, one family with a parent and two children,
one accepted friendship, two communities, one community goal, one sample publication,
one sample event, one minigame, four published quests and six checkbox steps were stored
in the private Azure PostgreSQL database. Subsequent GET requests verified the data.
The sample student completed one quest and two steps, receiving 20 ecopoints; progress
was read back from the API. Names and content identify these as `Demo` records.
No old accounts, passwords or history were migrated. No environmental measurements or
real community participation are claimed by these fixtures.

Account passwords are independently generated and stored privately outside the repository.
The one-time SQL job used the application role and TLS `verify-full`, inserted only missing
demo accounts in a transaction, and was removed after success. Other sample records were
created through authenticated API commands. Source Render/Aiven services were not changed.

## Email configuration and status

Azure Email Communication Services and a linked managed domain were provisioned. Domain,
SPF, DKIM, DKIM2 and DMARC verification returned `Verified`. The provider connection string
is generated into Key Vault through ARM and resolved into an ACA native secret; it is not
stored in the report or source. The IAM `EmailService` port and localized EN/es-419 templates
are preserved, with Resend remaining an available provider.

The managed domain is limited to 5 messages/minute and 10/hour. Microsoft announced ACS
Email retirement on September 30, 2028; current email onboarding remains available but is
subject to change. This is a course validation environment, not a permanent-provider claim.
Provider acceptance and mailbox receipt must be verified separately. A timeout is an unknown
send outcome, because it does not cancel delivery.

The first mail-enabled runtime uses source `632111ca72c8b3c228f21c237172f8232ed41610`
and immutable image `sha256:5de17b9c2efadbcda57fe997ec6c0a192450d6b87b754666a3901186f45b342d`.
Its revision `ca-ecomind-api--0000001` was Healthy/Running. Full H2/PostgreSQL tests and
both image builds passed in [CI](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/actions/runs/43249454205).

Actual mailbox and API checks on November 12:

| Check | Observed result |
| --- | --- |
| Registration and English verification email | 201; received in Gmail at 10:53 Lima |
| Verify the received code | 201 |
| Sign in and read protected account | 200 |
| Spanish recovery email | 200 acknowledgement; received in Gmail at 10:58 Lima |
| Confirm reset using the received token | 204 |
| Sign in with the previous password | 401 |
| Sign in with the new password | 200 |
| Reuse the consumed recovery token | 422 |
| Logout and request a protected resource after discarding the JWT | 204, then 401 |

Logout retains the existing stateless contract; already issued JWTs are not revoked
server-side. Secrets, received codes and personal recovery URLs remain outside the report.
Gmail removed the original custom-scheme anchor. The follow-up introduces a public HTTPS
handoff in the same backend, followed by the existing Android URI, with no reset on GET.

Both messages now share the actual EcoMind logo, the app's green palette, an accessible
text layout, EN/Spanish copy and plain-text alternatives. The logo is a bundled inline
PNG rather than a remote tracking request. The branded revision and handoff passed
19 focused tests and desktop/mobile fixture rendering checks; final runtime receipt
is recorded below. A fixture preview is not evidence of mailbox delivery.

The [Azure diagrams](../../diagrams/azure-2026-11-12/architecture-evidence.md) provide
editable draw.io sources and self-contained SVG views of the application, deployment
and delivery/secret boundaries. They supplement historical diagrams and show the
implemented modular monolith rather than separately deployed domain services.

## Final branded runtime

The final branded revision `ca-ecomind-api--0000002` is Healthy/Running and serves
100% of traffic. Source `930cdcda590afa2a8d4a12f156527b6f5680c625` passed full H2/PostgreSQL
verification and both image builds in [CI](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/actions/runs/43257139726). The deployed Linux AMD64 image
runs as `10001:10001` and is pinned to `sha256:9cda70edabf84f4cd3ad7acb2b22a608f571bac0b40044a603635f9012dfa46b`.

The new English verification and Spanish recovery messages were received in Gmail.
**Both initially arrived in spam**, and Gmail blocked the inline image there. The owner’s
known test messages were manually marked as not spam for layout inspection; the actual
bundled 888-pixel logo then loaded and rendered at 222 pixels. This is not proof of
automatic inbox placement or a fix for sender reputation. A verified custom sending
domain and further deliverability checks remain advisable before broader use.

The received verification code returned 201. The recovery button opened the public HTTPS
helper in the browser and preserved the same token in the existing Android URI. Reset
confirmation returned 204, old-password sign-in 401, new-password sign-in 200 and token
reuse 422. Logout returned 204, followed by 401 after client token disposal. The public
helper returned 200 in Spanish, malformed/missing tokens returned 400, and POST to the
helper and unauthenticated account access returned 401. The helper is absent from the
business OpenAPI document. The first probe during revision transition timed out; the
repeat after Healthy/Running passed every check. Installed-app behavior on a physical
Android device remains unverified.

All four demonstration accounts still authenticated after rollout, with one family,
two communities and four quests read back from the API. The new deployment did not
replace the private database. Private videos and personal mailbox screenshots stay
outside the repositories and do not constitute participant App Validation evidence.

The [machine-readable validation](azure-iam-validation-2026-11-12.json) records exact source,
image, checks and limitations without credentials.

## Provider references

- [Retirement and onboarding notice](https://learn.microsoft.com/azure/communication-services/acs-retirement-and-breaking-changes-guide).
- [Email quotas](https://learn.microsoft.com/azure/communication-services/concepts/service-limits#email).
- [Azure email pricing](https://azure.microsoft.com/pricing/details/communication-services/).

Private demonstration videos remain outside the repository and do not replace the academic
App Validation, About the Product or About the Team deliverables. Physical-device execution
is not established by API, CI or emulator checks.
