# Diagram validation

## Structural validation

All four `.drawio` files parse as XML. The combined source has three pages. Every page has unique cell identifiers and valid parent/source/target references. Each single-page model was recreated successfully with the draw.io XML tool and official Azure shape search.

## Independent static review

A bounded review of the generator source was completed. It was a static review only, without code execution or access to live infrastructure. The following supported changes were integrated:

- Replaced the stale email-pending note with the verified first inbox receipt; this does not certify the whole recovery flow.
- Made ARM the caller of ACS `listKeys()` and the writer of the Key Vault secret, rather than drawing the mail service as the secret writer.
- Distinguished the revision/image reference from the actual ACR image pull.
- Reversed the pull relationship to show the runtime initiating it and labelled the registry role separately.
- Added exact subnet delegation targets, confirmed against `infra/azure/network.bicep`.
- Made external ingress explicit and clarified the CI image build as validation.
- Added person/container/external-system type descriptions and the explicit landing-site scope omission.
- Removed the broad assertion about all administrator jobs; retained only the verified completed/deleted bootstrap and demo jobs.

Other suggestions were assessed against source evidence. Deployment is pinned by digest; database/JWT/mail secrets and the absence of secret outputs are backed by Bicep. Resource names were confirmed in source and deployment evidence. Azure icons are retained deliberately because this is the Azure-specific current-state architecture requested for the report. The backend card and footnote show one modular monolith. Legends are view-specific and labelled as such. A separate full C4 context covering unchanged landing/payment/map flows is outside this focused architecture update.

## Visual validation and exports

All three final views were inspected in the real draw.io editor. Initial text overlap and connectors crossing unrelated cards were corrected in the generator, recreated through the plugin, and visually inspected again. Private editor screenshots were retained outside the repository for each of the three views.

All three SVG files were exported through draw.io's SVG export, with embedded images and an editable diagram copy. The embedded models were decoded and checked for the final labels and corrected connections. Each SVG is self-contained and does not require the Azure icon URLs to render. The original `.drawio` models retain the editable library references. Exact dimensions, image counts and source embedding results are in `export-validation.json`.

Browser mouse dispatch and download-event tracking intermittently timed out. Each outcome was checked against the current UI and expected downloaded file before continuing; keyboard confirmation completed the last export. There are no pending exports. Only the editable sources, SVG exports and source/validation notes are included in the report. No PDF was generated.
