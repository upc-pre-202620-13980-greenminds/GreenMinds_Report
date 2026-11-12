# Remaining IAM checks

Use this record with a controlled test account and the current version 1.1 terms copy. Do not treat the
unchecked items below as completed. Never publish passwords, verification codes, access tokens,
recovery-link tokens or private inbox contents in screenshots or videos.

## Deployed recovery journey

1. Confirm the deployed backend’s OpenAPI loads publicly. Record its URL, deployed revision and
   the test date. Verify the recovery request, confirmation and logout contracts.
2. Confirm `PASSWORD_RECOVERY_URL` points to the public Azure HTTPS `/authentication/reset-password`
   helper and the server appends the `token` query parameter. Its button must open the existing
   `ecomind://authentication/reset-password` Android route. A Git merge alone is not evidence
   that the environment setting changed.
3. Use a team-approved inbox/account. From **Forgot your password?**, request recovery and
   confirm the generic acknowledgement. Record actual delivery without capturing the token.
4. Open the email link with the app stopped and again while the app is running, using a fresh
   link each time. The reset form must open in both cases.
5. Submit mismatched or weak passwords and verify the correction message. Submit a valid new
   password and confirm that the previous password is rejected and the new one signs in.
6. Reuse the consumed link. The app must show an invalid-link state and allow a fresh request.
   For expiry, use a genuinely expired test link; do not change a production clock or security
   policy to manufacture the result.

## Physical-device session and terms checks

- Install a build configured for the deployed API. The emulator address `10.0.2.2` is not the
  physical device’s backend address. The current debug build supports `api.base.url` in
  untracked `local.properties`; set it to the team’s deployed HTTPS `/api/v1/` URL and rebuild.
- Record device model, OS version, app revision, API environment, date, steps and observed results.
- Complete registration with valid fields but without accepting terms: submission must remain
  on the form with an acceptance error. The checkbox must start unchecked.
- Open and read the version 1.1 terms and privacy text; return and verify form preservation.
  Accept explicitly and confirm registration can continue. Repeat after unchecking it.
- Sign in, visit a protected destination and **Log out**. Verify sign-in is shown. Press Back,
  rotate, relaunch and verify that the previous protected destination is not restored.
- Verify local logout with a temporary device network interruption; restore connectivity after
  the check. Credentials must be cleared even if the API request fails.
- Check recovery, terms and logout labels in English (`en_US`) and Latin American Spanish
  (`es_419`), with a larger system font and the device screen reader. Report observed issues;
  resource-key parity alone does not prove accessibility.

## Recording fields

| Check | Date / revision / environment | Observed result | Evidence link | State |
|---|---|---|---|---|
| Public OpenAPI and deployed IAM contracts | 2026-11-12, Azure source 930cdcd | Public OpenAPI 200; protected resource without token 401; account lifecycle checked | [Azure runtime](azure-runtime-2026-11-12.md) | API verified |
| Real recovery email and app link | 2026-11-12, Azure source 930cdcd | Actual ES receipt (initially spam), logo and browser handoff checked; reset API passed; installed-app handoff pending | [Azure runtime](azure-runtime-2026-11-12.md) | Mail/API verified; device pending |
| Reset and consumed-link behavior on a physical device | Pending | Pending | Pending | Not verified |
| Logout, Back and relaunch on a physical device | Pending | Pending | Pending | Not verified |
| Version 1.0 terms, explicit acceptance and accessible reading | 2026-11-10, Android eb582eb, emulator | Reading/return tested in both locales, including 150% Spanish text; physical-device check pending | [Increment record](terms-and-email-2026-11-10.md) | Emulator verified |

Version1.1 was checked on November 11 in the current Android integration and rendered in Flutter
(English and es-419 with 150% text). Settings → Terms → Settings was exercised against the local
API. These checks do not close the physical-device or deployed-email rows. See the
[client follow-up](client-alignment-2026-11-11.md).

Keep these results separate from App Validation with participants. A developer walkthrough does
not replace the course’s user-validation sessions, About the Product or About the Team videos.
