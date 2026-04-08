# flutter_ua

[![Pub](https://img.shields.io/pub/v/flutter_ua.svg)](https://pub.dartlang.org/packages/flutter_ua)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)]()
[![Awesome Flutter](https://img.shields.io/badge/Platform-Android_iOS-blue.svg?longCache=true&style=flat-square)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](/LICENSE)

Retrieve Android/iOS device user agents in Flutter.

### Example user-agents:

| System  | User-Agent                                                                                     | WebView User-Agent                                                                                                                                                                       |
| ------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| iOS     | CFNetwork/1498.700 Darwin/24.4.0 (iPhone/16_Pro iOS/18.4)                                     | Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/22E240                                                                         |
| Android | Dalvik/2.1.0 (Linux; U; Android 15; Pixel 9 Pro Build/AP4A.250205.002)                        | Mozilla/5.0 (Linux; Android 15; Pixel 9 Pro Build/AP4A.250205.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/133.0.0.0 Mobile Safari/537.36                      |

### Additionally:

Every version returns some additional constants that might be useful for custom user-agent building.

The iOS mapping includes recent Apple hardware identifiers (for example iPhone 16e, iPhone 17 family identifiers, iPad Air M3, and iPad A16).

iOS version returns:

- isEmulator
- systemName
- systemVersion
- applicationName
- applicationVersion
- buildNumber
- darwinVersion
- cfnetworkVersion
- deviceIdentifier
- deviceName
- packageUserAgent
- userAgent
- webViewUserAgent

Android version returns:

- systemName
- systemVersion
- deviceManufacturer
- deviceModel
- deviceName
- packageName
- shortPackageName
- applicationName
- applicationVersion
- applicationBuildNumber
- buildNumber
- packageUserAgent
- userAgent
- webViewUserAgent
