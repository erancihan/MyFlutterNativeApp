import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:myapp/mystruct.dart';
import 'package:myapp/practice_callback_store.dart';

class App {
  static const MethodChannel _channel = const MethodChannel('myapp');

  void Function(int resp) _callback;

  int _count = 0;

  ffi.DynamicLibrary _library;
  int Function(int x, int y) _nativeAdd;

  App() {
    PracticeMyNativeStruct();
    PracticeCallbackStore();

    initNative();
  }

  void initNative() {
    try {
      _library = null;
      _library = Platform.isWindows
          ? ffi.DynamicLibrary.open("myapp_plugin.dll")
          : _library;
      _library = Platform.isMacOS ? null : _library;
      _library = Platform.isLinux ? null : _library;
    } catch (e) {
      print("ERR while opening library");
      print(e);
    }

    if (_library == null) return;

    try {
      _nativeAdd = _library
          .lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32)>>(
              "native_add")
          .asFunction();
    } catch (e) {
      print("ERR during function lookup");
      print(e);
    }
  }

  int sum(int x, int y) {
    if (_nativeAdd == null) {
      return -1;
    }

    return _nativeAdd(x, y);
  }

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
