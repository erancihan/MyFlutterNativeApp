import 'dart:ffi';
import 'dart:io';

typedef callback_type = Int32 Function(Pointer<Void>, Int32);
typedef create_MyStruct_type = MyStruct Function(
    Pointer<NativeFunction<callback_type>>);
typedef set_callback_type = Void Function(
    Pointer<NativeFunction<callback_type>>);
typedef invoke_callback_type = Void Function();

typedef CreateMyStructType = MyStruct Function(
    Pointer<NativeFunction<callback_type>>);
typedef SetCallbackType = void Function(Pointer<NativeFunction<callback_type>>);
typedef InvokeCallbackType = void Function();

const int except = -1;

abstract class MyStruct extends Struct {
  @Int32()
  int var_a;
}

class MyStructWrapper {
  MyStruct myStruct;

  CreateMyStructType createMyStruct;
  SetCallbackType setCallback;
  InvokeCallbackType invokeCallback;

  static int callback(Pointer<Void> ptr, int i) {
    print("> $i");

    return i;
  }

  MyStructWrapper() {
    DynamicLibrary library =
        Platform.isWindows ? DynamicLibrary.open("myapp_plugin.dll") : null;

    if (library == null) return;

    createMyStruct = library
        .lookup<NativeFunction<create_MyStruct_type>>("create_MyStruct")
        .asFunction();

    setCallback = library
        .lookup<NativeFunction<set_callback_type>>("set_callback")
        .asFunction();

    invokeCallback = library
        .lookup<NativeFunction<invoke_callback_type>>("invoke_callback")
        .asFunction();

    // MyStruct myStruct = createMyStruct(Pointer.fromFunction<callback_type>(callback, except));
    // print(myStruct.var_a);

    setCallback(Pointer.fromFunction<callback_type>(callback, except));
    invokeCallback();
  }
}
