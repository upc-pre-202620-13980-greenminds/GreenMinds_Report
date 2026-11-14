# Terms and recovery email — 2026-11-10

This increment completes the requested terms content for the current academic build and prepares
real recovery-email delivery. It remains limited to Mauricio’s IAM assignment.

## Implementation

- [Android PR #15](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Android/pull/15),
  commit `eb582eb`: terms/privacy version 1.0 in English and es-419, readable through the existing
  registration and settings routes. The text explains account data, minors, community visibility,
  sandbox payments, service providers, manual privacy requests and current data-control limits.
  It does not promise verified guardianship, self-service account deletion or automatic retention.
- [Backend PR #30](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/pull/30),
  commit `bd93175`: explicit `dev,email` delivery through Resend, default Android recovery route,
  encoded single-token links, localized HTML/plain text and bounded provider waits.
- A provider failure is translated into an IAM outbound-port error. Recovery keeps the same
  generic acknowledgement for registered and unknown accounts and warns without recipient/token
  data. The response acknowledges the request rather than asserting inbox delivery. Unexpected
  programming errors still propagate.

## Verification

| Check | Observed result | Limit |
|---|---|---|
| Android unit tests and APK builds | 54 JVM tests passed; application/test APKs built | Emulator/debug build |
| Terms, state, content and navigation | 13 native tests passed | Includes both locales and Spanish at 150% text size |
| Android recovery → sign-in → logout | One native API test passed | Synthetic local account; H2 and recording email adapter |
| Recovery service unit tests | 8 passed | Includes provider-failure acknowledgement and unexpected-error propagation |
| Resend adapter/profile tests | 10 passed | Mock HTTP provider; request content, language, encoding, errors, profiles and missing credentials |
| HU-058/HU-059 acceptance tests | 8 BDD scenarios passed | H2 test profile; no external mail |
| Visual review | English and enlarged Spanish terms reviewed from top to the return button | Captures remain private/local |

The private demos and captures are kept outside the repositories. They are not evidence of a
real email reaching an inbox. Historical 2026-11-05/08 captures and logs retain their original
revision and must not be presented as screenshots of the new terms.

## Required service-owner check

The user confirmed they do not have access to the Render/Resend administration account. No
production variables, sender domain or deployment were changed. The configured public API also
did not respond to the availability check.

The administrator must:

1. Confirm the public API and OpenAPI are reachable and the deployed profile is `prod`.
2. Set `RESEND_API_KEY` and `RESEND_FROM_EMAIL` in the private deployment environment. The sender
   must be allowed by Resend. Its sandbox sender can only send testing mail to the account owner;
   other recipients require a verified domain.
3. Use the default `ecomind://authentication/reset-password` route or explicitly set the approved
   `PASSWORD_RECOVERY_URL` for the installed client. Do not put a fixed recovery token in it.
4. Request recovery for a controlled registered inbox, verify actual reception, and test the link
   in the selected mail client on a device with EcoMind installed. Some clients restrict custom
   app links; the email also includes the address as plain text. Do not claim universal link
   compatibility without this check.
5. Confirm password change, sign-in with the new password and rejection of the consumed link.

For local delivery with the real provider, `dev,email` selects Resend instead of the console.
Automated tests never select the real adapter. See the backend README for the setup.

## Content and technical references

The app/report and the implemented endpoints determine the copy. The official
[ANPD description of access, rectification, cancellation and opposition](https://www.gob.pe/9270)
was consulted for the privacy-rights language; no legal certification is claimed. Provider setup
and payloads follow [Resend send email](https://resend.com/docs/api-reference/emails/send-email)
and its [error/sender restrictions](https://resend.com/docs/api-reference/errors).
