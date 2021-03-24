import 'dart:ffi';
import 'dart:io';

typedef callback_type = Int32 Function(Pointer<Void>, Int32);
typedef create_MyStruct_type = MyStruct Function(
    Pointer<NativeFunction<callback_type>>);

typedef CreateMyStructType = MyStruct Function(
    Pointer<NativeFunction<callback_type>>);

const int except = -1;

abstract class MyStruct extends Struct {
  @Int32()
  int var_a;
}

class PracticeMyNativeStruct {
  MyStruct myStruct;

  CreateMyStructType createMyStruct;

  PracticeMyNativeStruct() {
    DynamicLibrary library =
        Platform.isWindows ? DynamicLibrary.open("myapp_plugin.dll") : null;

    if (library == null) return;

    createMyStruct = library
        .lookup<NativeFunction<create_MyStruct_type>>("create_MyStruct")
        .asFunction();

    MyStruct myStruct =
        createMyStruct(Pointer.fromFunction<callback_type>(callback, except));
    print(myStruct.var_a);
  }

  static int callback(Pointer<Void> ptr, int i) {
    print("> $i");

    return i;
  }
}
