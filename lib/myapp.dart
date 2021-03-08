import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class App {
  static const MethodChannel _channel = const MethodChannel('myapp');

  void Function(int resp) _callback;

  int _count = 0;

  Future<void> startTimer() async {
    new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _callback.call(_count);

      if (_count == 10) {
        timer.cancel();
      }
      _count++;
    });
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');

    return version;
  }

  set callback(void Function(int) callback) {
    _callback = callback;
  }
}
