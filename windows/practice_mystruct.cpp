#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

extern "C"
{
    struct MyStruct
    {
        int var_a = 12;
    };

#ifdef _WIN32
    __declspec(dllexport)
#endif
    struct MyStruct create_MyStruct(int32_t (*callback)(void *, int32_t))
    {
        struct MyStruct my_struct;

        callback(nullptr, my_struct.var_a);
        my_struct.var_a = 100;

        return my_struct;
    }
}
