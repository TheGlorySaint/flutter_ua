## 1.0.2

- Add current Apple hardware identifiers, including iPhone 16e and the latest iPad Air/iPad variants.
- Add iOS `deviceIdentifier` to constants so unknown hardware (for example `iPhone19,1`) can still be inspected.
- Add Android device metadata (`deviceManufacturer`, `deviceModel`, and `deviceName`) for easier user-agent customization.
- Keep backward-compatible iOS fallback naming and return the raw hardware identifier when no family match is available.
- Expand automated tests and run them on pull requests.

## 1.0.1

- fixed issue with pub.dev icon

## 1.0.0

- Initial Plugin Release
