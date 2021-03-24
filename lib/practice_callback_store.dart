import 'dart:ffi';
import 'dart:io';

typedef callback_type = Int32 Function(Pointer<Void>, Int32);
typedef set_callback_type = Void Function(
    Pointer<NativeFunction<callback_type>>);
typedef invoke_callback_type = Void Function();

typedef SetCallbackType = void Function(Pointer<NativeFunction<callback_type>>);
typedef InvokeCallbackType = void Function();

const int except = -1;

class PracticeCallbackStore {
  SetCallbackType setCallback;
  InvokeCallbackType invokeCallback;

  PracticeCallbackStore() {
    DynamicLibrary library =
        Platform.isWindows ? DynamicLibrary.open("myapp_plugin.dll") : null;

    if (library == null) return;

    setCallback = library
        .lookup<NativeFunction<set_callback_type>>("set_callback")
        .asFunction();

    invokeCallback = library
        .lookup<NativeFunction<invoke_callback_type>>("invoke_callback")
        .asFunction();

    setCallback(Pointer.fromFunction<callback_type>(callback, except));
    invokeCallback();
  }

  static int callback(Pointer<Void> ptr, int i) {
    print("> $i");

    return i;
  }
}
