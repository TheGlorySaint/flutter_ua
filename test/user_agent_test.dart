import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ua/flutter_ua.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('flutter_ua');

  void logProperties(String label) {
    final properties = FlutterUserAgent.properties ?? const <String, dynamic>{};
    final keys = properties.keys.toList()..sort();
    final ordered = <String, dynamic>{
      for (final key in keys) key: properties[key],
    };
    debugPrint('[flutter_ua][$label] ${jsonEncode(ordered)}');
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  late int getPropertiesCallCount;
  late Map<String, dynamic> mockProperties;

  setUp(() {
    getPropertiesCallCount = 0;
    mockProperties = {
      'systemName': 'Android',
      'systemVersion': '15',
      'deviceManufacturer': 'Google',
      'deviceModel': 'Pixel 9 Pro',
      'deviceName': 'Google Pixel 9 Pro',
      'packageName': 'io.theglorysaint.flutter_ua.example',
      'shortPackageName': 'example',
      'applicationName': 'Flutter UA Example',
      'applicationVersion': '1.0.0',
      'applicationBuildNumber': 42,
      'buildNumber': 42,
      'packageUserAgent':
          'example/1.0.0.42 Dalvik/2.1.0 (Linux; U; Android 15; Pixel 9 Pro Build/AP4A.250205.002)',
      'userAgent':
          'Dalvik/2.1.0 (Linux; U; Android 15; Pixel 9 Pro Build/AP4A.250205.002)',
      'webViewUserAgent':
          'Mozilla/5.0 (Linux; Android 15; Pixel 9 Pro Build/AP4A.250205.002; wv) AppleWebKit/537.36',
    };

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getProperties') {
            getPropertiesCallCount += 1;
            return mockProperties;
          }

          return null;
        });

    FlutterUserAgent.release();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    FlutterUserAgent.release();
  });

  test('init caches properties and exposes getters', () async {
    await FlutterUserAgent.init();
    await FlutterUserAgent.init();
    logProperties('cache-success');

    expect(getPropertiesCallCount, 1);
    expect(FlutterUserAgent.userAgent, mockProperties['userAgent']);
    expect(
      FlutterUserAgent.webViewUserAgent,
      mockProperties['webViewUserAgent'],
    );
    expect(
      FlutterUserAgent.getProperty('deviceName'),
      mockProperties['deviceName'],
    );
    expect(FlutterUserAgent.properties, equals(mockProperties));
  });

  test('init force true refetches properties', () async {
    await FlutterUserAgent.init();

    mockProperties = {
      ...mockProperties,
      'userAgent':
          'Dalvik/2.1.0 (Linux; U; Android 16; Pixel 10 Build/BP1A.260101.001)',
      'systemVersion': '16',
    };

    await FlutterUserAgent.init(force: true);
    logProperties('force-refresh-success');

    expect(getPropertiesCallCount, 2);
    expect(FlutterUserAgent.userAgent, mockProperties['userAgent']);
    expect(FlutterUserAgent.getProperty('systemVersion'), '16');
  });

  test('getPropertyAsync initializes if needed', () async {
    final buildNumber = await FlutterUserAgent.getPropertyAsync('buildNumber');

    expect(getPropertiesCallCount, 1);
    expect(buildNumber, 42);
  });

  test('release clears cached state', () async {
    await FlutterUserAgent.init();
    FlutterUserAgent.release();

    expect(FlutterUserAgent.properties, isNull);
  });

  test('properties map is immutable', () async {
    await FlutterUserAgent.init();

    expect(
      () => FlutterUserAgent.properties!['newKey'] = 'newValue',
      throwsUnsupportedError,
    );
  });

  test('init propagates platform failures', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getProperties') {
            throw PlatformException(
              code: 'native_error',
              message: 'Failed to fetch user agent properties',
            );
          }

          return null;
        });

    await expectLater(
      FlutterUserAgent.init(),
      throwsA(isA<PlatformException>()),
    );
    expect(FlutterUserAgent.properties, isNull);
  });

  test('returns Android device data for major vendors', () async {
    final scenarios = [
      {
        'manufacturer': 'Google',
        'model': 'Pixel 9 Pro',
        'name': 'Google Pixel 9 Pro',
      },
      {
        'manufacturer': 'Samsung',
        'model': 'SM-S928B',
        'name': 'Samsung SM-S928B',
      },
      {'manufacturer': 'HUAWEI', 'model': 'P60 Pro', 'name': 'HUAWEI P60 Pro'},
    ];

    for (final scenario in scenarios) {
      mockProperties = {
        ...mockProperties,
        'deviceManufacturer': scenario['manufacturer'],
        'deviceModel': scenario['model'],
        'deviceName': scenario['name'],
      };

      await FlutterUserAgent.init(force: true);
      logProperties("android-${scenario['manufacturer']}");

      expect(
        FlutterUserAgent.getProperty('deviceManufacturer'),
        scenario['manufacturer'],
      );
      expect(FlutterUserAgent.getProperty('deviceModel'), scenario['model']);
      expect(FlutterUserAgent.getProperty('deviceName'), scenario['name']);
    }

    expect(getPropertiesCallCount, scenarios.length);
  });

  test('keeps unknown iPhone output available', () async {
    mockProperties = {
      'isEmulator': false,
      'systemName': 'iOS',
      'systemVersion': '19.0',
      'applicationName': 'Flutter UA Example',
      'applicationVersion': '1.0.0',
      'buildNumber': '42',
      'darwinVersion': '25.0.0',
      'cfnetworkVersion': '1600',
      'deviceIdentifier': 'iPhone19,1',
      'deviceName': 'iPhone',
      'packageUserAgent':
          'example/1.0.0.42 CFNetwork/1600 Darwin/25.0.0 (iPhone iOS/19.0)',
      'userAgent': 'CFNetwork/1600 Darwin/25.0.0 (iPhone iOS/19.0)',
      'webViewUserAgent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 19_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/23A000',
    };

    await FlutterUserAgent.init(force: true);
    logProperties('unknown-iphone');

    expect(FlutterUserAgent.getProperty('deviceIdentifier'), 'iPhone19,1');
    expect(FlutterUserAgent.getProperty('deviceName'), 'iPhone');
  });
}
