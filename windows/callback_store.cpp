#include "callback_store.h"

extern "C"
{
    Store store = Store{};

#ifdef _WIN32
    __declspec(dllexport)
#endif
    void set_callback(int32_t (*callback)(void *, int32_t))
    {
        store.callback = callback;
    }

#ifdef _WIN32
    __declspec(dllexport)
#endif
    void invoke_callback()
    {
        store.callback(nullptr, 102);
    }
}
