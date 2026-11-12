# Azure client integration — November 12, 2026

This follow-up covers Mauricio's assigned IAM work: password recovery (HU-058),
sign-out (HU-059), registration terms and the shared backend endpoint. It preserves
the historical validation records and does not certify the whole AV2 delivery.

## Implemented client changes

Android debug and release now default to the public Azure API. The ignored
`local.properties` key `api.base.url` still overrides debug for local development;
changing a build-time endpoint requires rebuilding the app. Flutter uses the same
Azure host and retains its `API_BASE_URL` build-time override.

Flutter recovery follows the existing application/domain/infrastructure/presentation
layers and reuses the current form components, logo, colors and localization system.
The flow includes request validation, a generic acknowledgement, the emailed link,
new-password confirmation, invalid/used-link states and return to sign-in. Both
clients handle `ecomind://authentication/reset-password`; the public HTTPS page is a
handoff, not a reset operation. A successful reset clears the local session. The
existing backend contract does not revoke other previously issued JWTs.

Shared terms and privacy text is version 1.2, dated November 12. It identifies Azure
backend/database hosting, Azure Communication Services Email and Cloudinary community
images, while preserving the academic scope and manual privacy-request limitations.
Readable text is not evidence of legal approval or server-side consent auditing.

## Recorded verification

| Check | Observed result | Scope |
| --- | --- | --- |
| Android debug build and test APK | Passed | Azure endpoint in generated debug/release configuration; explicit debug override honored and local file restored |
| Android JVM tests | 61 passed in final integration | Includes the cleanup refactor and the team's subsequent Quests changes; earlier IAM-only increment passed 59 |
| Android instrumented suite | 25 cases, no failures, 3 intentional skips | API 36 emulator; live IAM and local-backend opt-ins are separate |
| Android controlled-link Azure journey | Passed separately | Reset, new login, settings, logout and activity recreation; old-password login 401, new-password login 200, reused token 422, logout 204 and anonymous account access 401 |
| Flutter analysis and unit/widget tests | Clean analysis; 26 passed | Parser, state, navigation, delayed authentication and Spanish layout at larger text scale |
| Flutter debug APK | Built | Android APK; iOS URL-scheme configuration was inspected, not executed |
| Native link delivery to Flutter | Passed with a synthetic token | Implicit manifest-resolved ACTION_VIEW reached app_links and displayed the reset page; this initial check does not establish live reset or email receipt |
| Flutter controlled-link Azure reset | Passed in separate SDK phases | Normal installed APK displayed Password updated; subsequent UI sign-in, Profile and sign-out passed; a separate Back/relaunch check retained empty sign-in fields. Separate API checks: old password 401, new password 200, consumed token 422, logout 204 and anonymous access 401. This is not email-receipt evidence |
| Backend clean verification | 699 tests passed; coverage gates passed | Polling/status diagnostic increment; CI separately verifies H2, PostgreSQL and deployment images |

## Live-mail investigation

One Android request reached its generic acknowledgement. The corresponding provider
metrics showed SendMail HTTP 202 and successful status polling, but the personal test
mailbox did not receive a new message. A later controlled API request reproduced an
SDK timeout. Neither acknowledgement nor HTTP 202 is recorded as delivery evidence.

The adapter now allows a longer bounded confirmation wait and retains a validated
provider operation ID for subsequent status diagnosis. It does not resend automatically.
Diagnostics omit message bodies, recipient addresses, credentials and recovery links.
The recovery API retains its generic response for known and unknown addresses.

The second native request run ended with a retained Android ANR record. Its trace was
unavailable through both shell access and the supported own-app exit-info API, so no
specific application stack defect or low-memory cause is asserted.

The later Android request UI test waited for the initial sign-in screen and
completed once with the generic acknowledgement. Its provider operation was still
`Running` at 21:07 UTC on the latest read, with no error code. Domain and
sender configuration checks do not establish delivery. An explicitly controlled reset
fixture was therefore prepared for the owner's test account to verify the mobile/API
path independently. The database stored only the token hash and expiry, and the
temporary fixture job was removed. This test link was not obtained from an email.

Android's controlled-link test passed at 20:10:10–20:11:28 UTC. Its API checks also
confirmed that an already-issued bearer remains accepted after logout, consistent
with the existing stateless contract; a request without Authorization returned 401.
This result does not claim server-side JWT revocation or current mail delivery.

## Remaining validation

Android reset, new-password login and post-logout navigation have passed with the
controlled fixture. Flutter reset and separate API checks also passed: new password
200, old password 401, consumed token 422, logout 204 and anonymous access 401.
The installed normal Flutter APK also completed sign-in, Profile and sign-out.
A separate SDK Back/relaunch check passed with empty sign-in fields before and
after reopening. These are separate test phases, not one uninterrupted recording. Actual mailbox
receipt remains unverified; controlled fixtures do not close that delivery check. Private demo
videos remain local to the owner. Physical-device evidence, participant App Validation
and the team's remaining delivery artifacts are separate academic checks.

Implementation branches and PRs:

- [Backend #32](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/pull/32)
- [Android #15](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/15)
- [Flutter #1](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Flutter/pull/1)

## Course conventions and source revisions

The three repositories in the teacher organization were inventoried and pulled with
`--ff-only` on November 12; all were already current and clean. Android reference
`easyevent-mobile-android` is `24eda270404d76af9dcfd80e6134d44ac639b848`, Flutter
reference `easytraval-mobile-flutter` is `9243a85a2c403975dc1c86898dccec565e4959b5`
and `easyvet-mobile` is `c943d85a74d3b41fc446cd16f501c2434f653899`. These are
implementation references; their presence does not replace the current assignment.

The recovery work preserves EcoMind's feature layers, application use cases, domain
repository contracts, infrastructure API implementation, view models with separate
state, navigation and localized resources. It does not introduce a new production UI
framework. The normal Flutter APK used production source `21e307e`; later `6c60909`
adds only an explicitly gated integration harness and its instructions. The harness
was analyzed, but its local Dart compiler stalled twice before execution. The SDK
checks against the installed normal APK are separate evidence.

Backend PR #32 was merged to `develop` as `cb5ba414f4ee15497fe8d5075cfff12a78cb2458`;
its tree matches the deployed source `e009a533d5eb4800e3aabce4cbbfecebfdc26724`.
Android PR #15 was merged to `develop` as `065c234f46aa94ec9e203420fc517de0a3bdbde1`;
its tree matches the tested feature source `d220605`. The API image is pinned by digest
and the active deployment is `ca-ecomind-api--0000005`.

Flutter PR #1 was merged to `develop` as `f2cf11efe4ac9a75c9206365d4cac6d3005a0483`.
The canonical Flutter clone was updated with a fast-forward pull. Private recordings
remain outside the report repository. The Flutter demo labels its separate phases and
the later success/relaunch screenshots explicitly; it is not presented as an
uninterrupted recording or proof of email receipt.

The final Android course-style review moved local session cleanup behind
`ClearSessionUseCase`, preserving the retry/error and cancellation behavior. The
ViewModel now depends only on application use cases. The isolated debug logger was
removed. The refactor passed 59 JVM tests and four recovery ViewModel instrumented
cases before integrating the team's subsequent Quests changes. The final integration
build is recorded below separately.

The final Android integration on top of the team's Quests merge `eb577b6` passed
61 JVM tests with no failures/errors/skips and rebuilt both debug APKs. The four
recovery ViewModel instrumented cases passed on the identical IAM refactor before
that Quests merge. The four staged private fixture/URI files were removed from app
storage after validation. No accounts or general app data were deleted.

[Android #23](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/23)
integrates the cleanup refactor and opt-in SDK checks into `develop` as
`a5c577b13d7827be1c152559c4f649135a2df1e0`, from tested source
`0ada1c84c1116a80bbfee97dc01fba077ed6b250`. The canonical Android clone was
updated by fast-forward pull. The earlier controlled Android video uses source
`d220605`; the later layer-only refactor is covered by the additional unit and
ViewModel regression checks, not represented as another live reset recording.
