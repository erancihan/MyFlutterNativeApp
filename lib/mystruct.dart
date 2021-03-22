import 'dart:ffi';
import 'dart:io';

class MyStruct extends Struct {
  @Int32()
  int var_a;
}

class MyStructWrapper {
  MyStruct myStruct;

  MyStruct Function() createMyStruct;

  MyStructWrapper() {
    DynamicLibrary library =
        Platform.isWindows ? DynamicLibrary.open("myapp_plugin.dll") : null;

    if (library == null) return;

    createMyStruct = library
        .lookup<NativeFunction<MyStruct Function()>>("create_MyStruct")
        .asFunction();

    MyStruct myStruct = createMyStruct();
    print(myStruct.var_a);
  }
}
