
import 'dart:async';

import 'package:flutter/services.dart';

class Myapp {
  static const MethodChannel _channel =
      const MethodChannel('myapp');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
