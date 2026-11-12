# IAM acceptance and AV2 checks

Checked on 2026-11-08. This checklist covers Mauricio’s assigned IAM work: HU-058, HU-059 and
the registration terms screen, together with the course requirements applicable to that increment.

## November 12 Azure follow-up

The historical checks below retain their original dates. The [Azure runtime record](azure-runtime-2026-11-12.md)
now establishes public OpenAPI availability, real verification/recovery mailbox receipt,
password reset, rejection of the previous password, rejection of a reused reset token and
logout followed by unauthorized access without a JWT. Current client feature branches
point to Azure. New synthetic demonstration data replaces the attempted legacy-data
migration. The branded mail layout and HTTPS handoff are tracked separately in that record.
This historical runtime record predates the client integration described below.
Physical-device execution remains open; this is not an AV2 closure.

The [current client integration record](azure-clients-2026-11-12.md) supersedes the historical
implementation status below: terms v1.2 and Azure defaults are implemented in both apps,
and controlled-link emulator validation is separate from the still-unconfirmed current
ACS mail operation. Historical real-mail receipt is retained with its original source.

## Sources and interpretation

- Team request: connect password recovery and logout to their APIs; complete the registration
  terms screen. The team discussion assigns IAM to Mauricio.
- Report: HU-058 and HU-059 in [User Stories](../../../README.md#241-user-stories).
- Current course statement: `Trabajo Final_1ACC0238_202620.pdf`, V4.0, pp.33–35.
- Week 7: `1ACC0238-t&c v3.pdf`, slide 3, requires readable and accessible terms plus explicit
  acceptance before use. It does not provide an approved EcoMind legal policy.
- Figma: the current [sign-up](https://www.figma.com/design/nQ8aSe0ovKrqrfQpvV21TC/EcoMind-Designs?node-id=2-1415)
  and [settings](https://www.figma.com/design/nQ8aSe0ovKrqrfQpvV21TC/EcoMind-Designs?node-id=284-5264)
  frames support visual continuity, not proof of execution.

The statement requires core mobile functionality for AV2 and all Product Backlog functionality
for TB2. Its AV2 gate also requires the complete backend deployed publicly with documentation.
The rubric sheet named AV2 contains inconsistent TB2 labels; no unambiguous weights are inferred
from those labels.

## IAM tasks from the team request and report acceptance

| Requirement | Observed evidence | State | Remaining action |
|---|---|---|---|
| HU-058, scenario 1: request recovery from sign-in | Forgot-password navigation, normalized email and request API call are implemented. Backend BDD records delivery through a recording email adapter. | Implemented; production delivery unverified | Verify an approved test inbox receives the real message and its link opens the installed app. |
| HU-058, scenario 2: generic recovery response (report alignment under review) | The backend returns the same request response for registered and unknown addresses; Android uses a generic confirmation. Unit, screen and BDD tests cover that contract. | API behavior verified locally; report correction under review | Review the scenario alignment in report PR #12; the previous wording disclosed unknown addresses. |
| HU-058, scenario 3: change password and sign in again | Native API test resets the password and signs in; API checks reject the old password and a consumed token. The link parser, invalid-link states, weak-password and confirmation checks are tested. | Verified locally | Repeat the journey with the deployed backend and real email. |
| HU-059, scenario 1: logout and return to sign-in | Bearer-authenticated logout accepts empty `204`; local credentials are cleared even after request failure. The delayed API test presses Back during logout and recreates the activity. | Verified locally | Repeat on a physical device with the deployed API. |
| HU-059, scenario 2: protected destinations require a new login | Logout clears saved tab stacks, graph state and balances. Native recreation remains on sign-in; API access without a token returns `401`. | Verified locally | Confirm device Back and relaunch behavior in physical-device evidence. |
| Registration terms: readable screen reachable from sign-up | A scrollable terms screen and return navigation preserve the registration form. Two dedicated instrumented tests verify that valid registration is blocked before acceptance and after acceptance is withdrawn. | Version 1.0 copy and readable navigation verified in the new increment | Integrate Android PR #15; preserve manual privacy-request limits. |

The baseline report described an explicit error for an unknown email address. The existing
backend instead acknowledges both cases to avoid disclosing registered accounts. Report PR #12
proposes aligning scenario 2 with that contract. This is an explicit correction under review,
not evidence that the old disclosure behavior was implemented.

Logout uses the existing stateless contract: Android discards credentials; the backend does not
revoke previously issued JWTs. No server-side revocation, consent version or consent audit record
is attributed to this increment.

Named tests and final outputs are linked in the [implementation record](README.md#recorded-verification)
and [native test output](native-tests.txt). The 2026-11-05 results cover Android `931a785`, not
subsequent unrelated changes. Passing tests are not evidence of legal approval or real email delivery.

## Integration and conventions

- Android PR [#8](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/8)
  and backend PR [#25](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/pull/25)
  are merged into `develop`. The report change is under review in PR
  [#12](https://github.com/upc-pre-202620-13980-greenminds/GreenMinds_Report/pull/12).
- Commits use the personal author `Mauricio Pajes <mpajes2006@gmail.com>`, feature branches,
  English Conventional Commit subjects and `develop` as the integration target.
- Recovery uses the existing domain/repository, application use-case, infrastructure/Retrofit and
  interface/ViewModel layers, with Hilt, `StateFlow` and typed navigation as in the course examples.
- The recovery, sign-in, logout and terms labels use resources: default English (`en_US`) and
  Latin American Spanish (`es_419`,
  Android directory `values-b+es+419`). Split resource XML filenames are valid; their presence
  alone does not establish translation or accessibility quality for the entire application.

- Recovery credentials stay in memory and are not put in navigation routes or saved state.
- Integrated Android revision checked: `e137d95`. `testDebugUnitTest`, `assembleDebug` and
  `assembleDebugAndroidTest` passed, with 54 JVM tests and no failures, errors or skips. The
  [integrated result](integrated-validation.json) preserves this scope separately from the
  earlier native results. Later native runs on test-only increment `e74125b` passed 14 tests:
  11 existing state/content/navigation tests, both explicit-acceptance checks and the local API
  journey against backend `988a49a`. The fixture tutorial was pre-completed to isolate IAM.
  [Native output](native-integrated-tests.txt) and [test PR #14](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/14)
  preserve this evidence.

## Course requirements applicable to this IAM increment

| Requirement | Evidence | State |
|---|---|---|
| Core mobile flows consume the existing REST API | Recovery request/confirmation and authenticated logout are connected. | Verified locally; real delivery from the deployed environment remains pending. |
| Class architecture and project GitFlow | Existing use-case/repository/ViewModel layers, Hilt, typed navigation, feature branches and personal authorship are preserved. | Verified for this increment. |
| Default English and locale resources | Recovery, sign-in, logout and terms resources exist in default English and `values-b+es+419`, with matching keys. | Resource parity verified; physical-device accessibility and locale checks remain pending. |
| Terms are readable and explicitly accepted | Readable screen, preserved form and two passing acceptance-guard tests. | Version 1.0 completed and verified in Android PR #15. |
| Sprint evidence is traceable | Report section 4.2.2 and the implementation record link commits, tests, contracts and captures. | IAM contribution recorded; this is not a claim that the entire Sprint 2 is complete. |
| Real execution evidence | Emulator captures and recorded native/API checks exist. | Physical-device verification remains pending. |

## Public-environment check

The release configuration identifies `https://ecomind-backend-yxp7.onrender.com/api/v1/`.
On 2026-11-08, requests with TLS verification enabled to that host’s `/v3/api-docs` returned no HTTP response
before the 60-second timeout and a 25-second IPv4 retry. This is a failed availability
verification from this environment; it does not establish why the service did not respond.
No credentials were used and no production configuration was changed. An accessible OpenAPI
and a real recovery-email journey remain required evidence.

The [manual check record](manual-checks.md) gives the exact remaining production, physical-device
and legal checks without marking them complete.

## Closure criteria

IAM can be demonstrated locally now. It must not be represented as fully ready for delivery
while production recovery delivery and physical-device execution remain unverified. The
[2026-11-10 increment](terms-and-email-2026-11-10.md) completes the terms content and records
mail integration checks separately from real delivery. Repository integration alone does not prove production delivery or physical-device behavior.
