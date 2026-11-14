# IAM account access

This evidence covers HU-058, HU-059 and the registration terms screen. It does not establish that
Sprint 2, the complete backend scope or the AV2 delivery is finished.

HU-058 uses the backend's generic recovery acknowledgement. The criteria update was
merged in [report PR #12](https://github.com/upc-pre-202620-13980-greenminds/GreenMinds_Report/pull/12).
Android and Flutter use Azure, shared terms version 1.2 and the same recovery contract.
Flutter [PR #2](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Flutter/pull/2)
preserves the confirmation ID when retrying after a lost response. Current client
integration is recorded in the [client follow-up](azure-clients-2026-11-12.md).

## Implemented behavior

| Scope | Behavior |
|---|---|
| HU-058: request recovery | Android and Flutter normalize the email and call `POST /api/v1/authentication/password-recovery/request`. The `200` response uses the same message whether or not an account exists. |
| HU-058: reset password | The recovery link opens `ecomind://authentication/reset-password?token=<recovery-token>`. Confirmation calls `POST /api/v1/authentication/password-recovery/confirm` and accepts `204` with no body. Invalid, expired or consumed tokens map to `PASSWORD_RESET_TOKEN_INVALID` (`422`); a weak password maps to `PASSWORD_POLICY_VIOLATION` (`400`). |
| HU-059: logout | Android and Flutter call `POST /api/v1/authentication/logout` with the current Bearer token, accept an empty `204` response and clear the stored session. Local cleanup also runs after a network failure or coroutine cancellation. Protected navigation is replaced by sign-in after logout. |
| Registration terms | The placeholder is replaced with a readable terms screen using the existing EcoMind components. Both clients use the shared terms and privacy text, version 1.2, described in the [client follow-up](azure-clients-2026-11-12.md). This change does not add server-side storage of consent or a terms version. |

The backend uses stateless access tokens. Logout does not revoke the token on the server; the
client discards its session. Password-reset completion and local session cleanup are separate
steps so a cleanup retry does not consume the recovery token again.

## Design references

- [Current sign-up frame](https://www.figma.com/design/nQ8aSe0ovKrqrfQpvV21TC/EcoMind-Designs?node-id=2-1415).
- [Current settings frame](https://www.figma.com/design/nQ8aSe0ovKrqrfQpvV21TC/EcoMind-Designs?node-id=284-5264).

These frames are visual references from the current team file. The new states retain the existing
logo, form fields, buttons, colors and typography. A Figma reference alone does not prove
working application behavior or user validation.

## Recorded verification

The following results were collected on 2026-11-05 for Android `931a785` and the backend
revision identified below. They are retained separately from the later integrated check.

| Check | Result | Scope |
|---|---|---|
| Android JVM tests | 33 tests; 0 failures, 0 errors, 0 skipped | Seven suites from `testDebugUnitTest`. |
| Android application build | Passed | `assembleDebug`. |
| Android instrumented-test build | Passed | `assembleDebugAndroidTest`; building the test APK does not prove native execution. |
| Existing backend unit tests | 6 passed | Password recovery service regressions. |
| Existing backend acceptance tests | 8 scenarios passed | HU-058 and HU-059, with H2 and the recording email adapter. |
| Local API integration | Passed | Real Spring Boot server with an isolated H2 in-memory database, port `8092`; no external email provider. |
| Native ViewModel tests | 3 passed | Instrumented state tests on an API 36 ARM64 emulator. |
| Native Compose screen tests | 4 passed | Instrumented content and interaction tests on the same emulator. |
| Application navigation tests | 4 passed | Terms retain the form, recovery returns to sign-in, missing-token links show an error, and incoming links survive activity recreation. |
| Android-to-backend integration test | 1 passed | Reset password, sign in, press Back during logout and recreate the activity against the local API. |
| Cold recovery-link entry | Passed | Open a fresh recovery link after force-stopping the application; the reset form is displayed. |
| Rendered screen review | Passed | Seven unedited emulator screenshots reviewed against the existing components and current Figma references. |

The 12 passed native tests used an API 36 ARM64 emulator at `360 × 800` with host/Metal graphics.
The final navigation and API runs also produced the screenshots below. Earlier attempts had
SystemUI/Quickstep ANR dialogs; those captures were discarded. The system dialogs were closed
before the final visual evidence was captured. Emulator checks do not establish physical-device
behavior.

The [native test output](native-tests.txt) records the final passing runs on Android revision
`931a785`.

The local API check verified sign-in and the authenticated account (`200`), logout (`204`, empty
body), rejection without a token (`401`), password reset (`204`, empty body), rejection of the
previous password (`401`), acceptance of the new password (`200`) and rejection of a consumed
recovery token (`422`).

The local test harness adds a `900 ms` logout delay to reproduce leaving the screen while the
request is pending. One API measurement recorded `949 ms`. The delay is test-only and is not a
backend source or production configuration change. The native regression verified that pressing
Back during this delayed logout still clears the session and returns to sign-in; activity recreation
does not restore the protected destination.

## Implementation references

| Repository | Commit | Change |
|---|---|---|
| Android | `3592349` | Connect recovery and logout APIs. |
| Android | `cfe6ff7` | Add recovery and session screens. |
| Android | `3ed4ada` | Preserve activity launch metadata when consuming recovery links. |
| Android | `931a785` | Wait for completed access navigation in regression tests. |
| Backend | `e4893fb` | Document the Android recovery link and session contract. |

The backend regressions were run at `a6d1491`. Its Java source matches the `origin/develop` base
`36b0a2b` used for this change. No new backend feature is attributed to the documentation update.

## Review links

- [Android implementation](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/8), targeting `develop`.
- [Backend contract documentation](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/pull/25), targeting `develop`.

## Screenshots

These captures show the rendered emulator application with a synthetic local account. They do
not show production data or replace the course's physical-device evidence.

| Screen | Capture |
|---|---|
| Recovery request | [password-recovery.png](password-recovery.png) |
| Password reset | [password-reset.png](password-reset.png) |
| Password updated | [password-updated.png](password-updated.png) |
| Terms | [terms.png](terms.png) |
| Settings | [settings.png](settings.png) |
| Signed out | [signed-out.png](signed-out.png) |
| Cold recovery-link entry | [cold-recovery-link.png](cold-recovery-link.png) |

## Integrated verification — 2026-11-08

Android and backend PRs above are merged into `develop`; the report is still under review.
The latest inspected Android `develop` revision, `e137d95`, passed `testDebugUnitTest`,
`assembleDebug` and `assembleDebugAndroidTest`: 54 JVM tests across nine suites, with no
failures, errors or skips. The [result record](integrated-validation.json) preserves the suite
counts. On backend `988a49a`, the six recovery unit tests and eight HU-058/HU-059 BDD scenarios
also passed again with the test profile and recording email adapter.

The later native runs passed 14 tests on Android `e74125b` (base `e137d95`): 11 existing
state/content/navigation tests, two explicit-acceptance tests and the full local API journey
against backend `988a49a`. The local account’s tutorial was pre-completed to isolate IAM; this
check does not validate the Learning tutorial flow. The [native output](native-integrated-tests.txt)
records those runs. The application code is unchanged
from that base; [Android PR #14](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/14)
contains tests only. The 2026-11-05 native results above retain
their original revision.

The [acceptance checklist](acceptance-checklist.md) maps each IAM criterion to evidence and
separates local verification from the remaining checks for IAM.

## Current deployment

Both clients use Azure Container Apps. PostgreSQL is private, and Azure Communication
Services Email handles verification and recovery messages. The [CI/CD record](azure-devops-2026-11-12.md)
contains the automatic deployment checks; the [runtime record](azure-runtime-2026-11-12.md)
contains the dated API and mailbox checks. Mobile executions recorded here use emulators.

## Terms and email completion — 2026-11-10

The [terms and mail increment](terms-and-email-2026-11-10.md) records the completed body copy,
14 native checks, 54 JVM checks, 18 backend unit tests and eight BDD scenarios. Resend request
handling is tested with a mock provider; actual inbox delivery remains unverified because the
service administration account is unavailable. No private demos were uploaded.

## Current client alignment — 2026-11-11

The [client follow-up](client-alignment-2026-11-11.md) records version 1.1 terms shared with the
parent Flutter client and restores post-registration access after the Android settings update.
It preserves the team’s role and client direction without changing account contracts or claiming
that all Flutter IAM flows are implemented. Historical screenshots and videos keep their dates.
