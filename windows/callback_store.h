#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#ifndef CALLBACK_STORE_H
#define CALLBACK_STORE_H

struct Store
{
    int32_t (*callback)(void*, int32_t) = nullptr;
};

#endif  // CALLBACK_STORE_H
