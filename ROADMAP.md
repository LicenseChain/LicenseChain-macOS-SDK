# LicenseChain macOS SDK Roadmap

## Current Focus

- Keep API base URL behavior aligned with `https://api.licensechain.app/v1`.
- Maintain parity with iOS verification and JWT/JWKS helper behavior.
- Keep CocoaPods/`LicenseChainmacOS` packaging names collision-free with iOS.

## Next Operational Tasks

- Re-run conformance checks after Core API verify/JWKS contract updates.
- Keep docs and examples synchronized with https://docs.licensechain.app/en/sdk.
- Record release-impacting changes in `CHANGELOG.md`; develop experiments on `dev`, release from `main`.

## Ecosystem Notes

- CI uses host `swift build` on macOS runners; Xcode remains required for full app integration tests.
