# IAM client alignment — 2026-11-11

This follow-up applies the team's child-focused Android and parent-focused Flutter direction
to the assigned IAM work. Common account concepts and the backend contract stay shared. It
does not remove existing roles or attribute teammates' Flutter authentication work to this change.

## Changes

- Android [PR #15](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/15),
  `eed8e30`: integrates develop `925f0a4` and restores Terms & policy in the current Settings
  help group, preserving notification, language, theme and support routes. The new settings
  integration had removed the post-registration terms entry.
- Flutter [PR #1](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Flutter/pull/1),
  `1e0ad76`, based on develop `e121cc8`: replaces provisional copy and exposes the existing
  TermsPage from Profile with the existing TextLink. Authentication, verification, logout and
  family/profile work already present in that base remain teammates' contributions.
- Shared terms version 1.1, dated November 11, use account-area wording rather than promising a
  Settings screen in both clients. English and Spanish bodies match exactly; es-419 inherits
  the Spanish content. No additional legal, role or consent-storage capability is claimed.
- Backend [PR #30](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/pull/30),
  `d40c933`: integrates develop `f0f5051`; the recovery mail contract is unchanged.
- The two old `feature/iam-account-access` branches in Android and Backend were deleted only
  after confirming their tips are ancestors of current develop. Open review branches remain.

## Verification

| Check | Observed result | Limit |
|---|---|---|
| Android build and JVM suite | Application/test APKs built; 56 tests passed | Local debug build |
| Native navigation and terms | Six tests passed | Four navigation and two reading/locale checks |
| Native local API journey | Passed | Reset, sign-in, Settings → Terms → Settings, Back during delayed logout and activity recreation |
| Backend IAM unit tests | 18 passed | Eight recovery service and ten adapter/profile checks |
| Backend BDD suite | 85 scenarios passed | Test profile; includes eight HU-058/HU-059 scenarios |
| Flutter static analysis | No issues | Dart 3.13.5; checked from an ASCII-path worktree after a Unicode-path analyzer protocol failure |
| Flutter terms rendering | Reviewed top/end at 360 × 800 in EN and es-419 at 150% text | Actual TermsPage widget; private captures; no physical-device claim |
| Localized content parity | EN/ES bodies match Android; es-419 fallback confirmed | No API or backend-consent schema change |

The optional Flutter APK build did not finish provisioning dependencies and was stopped after
persistent download stalls. Analysis and actual-widget rendering passed; APK/device and deployed
Flutter validation are not claimed.

## Remaining verification

Review and integrate the open IAM increments through develop. The deployment owner must
configure the sender/provider, verify actual receipt and open a fresh recovery link on a physical
phone with the installed Android client. The user has no Render/Resend administration access.
A local recording adapter, mock HTTP test or private walkthrough does not prove inbox delivery.

Flutter password recovery is not present in the inspected base or added by this terms increment.
Its inclusion in the team's initial Flutter scope has not been assigned here. The team's 30%
planning target is not evidence of completed functionality or an independently verified change
to the course requirements. Keep shared capabilities and progress claims tied to each client.

Private media stays outside the repositories. These developer checks do not replace App
Validation, About the Product or About the Team delivery videos. The strict AV2 audit retains
its unresolved global controls; this follow-up does not declare the whole delivery ready.
