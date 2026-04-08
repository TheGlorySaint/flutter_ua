import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sourcePath = File('ios/Classes/FlutterUserAgentPlugin.m');

  Map<String, String> parseDeviceMap(String source) {
    final mapping = <String, String>{};
    final entryPattern = RegExp(r'@"([^"]+)": @"([^"]+)"');

    for (final match in entryPattern.allMatches(source)) {
      mapping[match.group(1)!] = match.group(2)!;
    }

    return mapping;
  }

  String resolveDeviceName(Map<String, String> mapping, String identifier) {
    final mapped = mapping[identifier];
    if (mapped != null) {
      return mapped;
    }

    if (identifier.contains('iPod')) {
      return 'iPod';
    }

    if (identifier.contains('iPad')) {
      return 'iPad';
    }

    if (identifier.contains('iPhone')) {
      return 'iPhone';
    }

    if (identifier.contains('AppleTV')) {
      return 'AppleTV';
    }

    return identifier;
  }

  test('contains current Apple identifiers', () {
    final source = sourcePath.readAsStringSync();
    final mapping = parseDeviceMap(source);

    expect(mapping['iPhone17,5'], 'iPhone/16e');
    expect(mapping['iPhone18,3'], 'iPhone/17');
    expect(mapping['iPad15,7'], 'iPad_11th_Gen_A16_WiFi');
    expect(mapping['iPad15,8'], 'iPad_11th_Gen_A16_WiFi_Cellular');
  });

  test('unknown iPhone family falls back to iPhone', () {
    final source = sourcePath.readAsStringSync();
    final mapping = parseDeviceMap(source);
    final resolved = resolveDeviceName(mapping, 'iPhone19,1');
    debugPrint('[flutter_ua][ios-mapping] iPhone19,1 => $resolved');

    expect(resolved, 'iPhone');
  });

  test('unknown non-family identifier returns raw identifier', () {
    final source = sourcePath.readAsStringSync();
    final mapping = parseDeviceMap(source);

    expect(resolveDeviceName(mapping, 'FutureDevice1,1'), 'FutureDevice1,1');
  });
}
