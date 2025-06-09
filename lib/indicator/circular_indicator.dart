import 'dart:async';

import 'package:flutter/services.dart';

class CircularIndicator {
  static const MethodChannel _channel = MethodChannel('circular_indicator');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
