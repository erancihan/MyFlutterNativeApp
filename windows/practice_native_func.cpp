#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

extern "C"
{
#ifdef _WIN32
    __declspec(dllexport)
#endif
    int32_t native_add(int32_t x, int32_t y)
    {
        return x + y;
    }
}
