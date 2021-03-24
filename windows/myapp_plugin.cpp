#include "include/myapp/myapp_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include <stdint.h>

namespace
{
  class MyappPlugin : public flutter::Plugin
  {
  public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

    MyappPlugin();

    virtual ~MyappPlugin();

  private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  };

  static constexpr unsigned int hash(const char *str, int h = 0)
  {
    return !str[h] ? 5381 : (hash(str, h + 1) * 33) ^ str[h];
  }

  // static
  void MyappPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar)
  {
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(registrar->messenger(), "myapp", &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<MyappPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  MyappPlugin::MyappPlugin() {}

  MyappPlugin::~MyappPlugin() {}

  void MyappPlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    auto method_name = hash(method_call.method_name().c_str());
    std::ostringstream version_stream;

    switch (method_name)
    {
    case hash("getPlatformVersion"):
      version_stream << "Windows ";
      if (IsWindows10OrGreater())
      {
        version_stream << "10+";
      }
      else if (IsWindows8OrGreater())
      {
        version_stream << "8";
      }
      else if (IsWindows7OrGreater())
      {
        version_stream << "7";
      }
      result->Success(flutter::EncodableValue(version_stream.str()));
      break;
    default:
      result->NotImplemented();
      break;
    }
  }
} // namespace

void MyappPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar)
{
  MyappPlugin::RegisterWithRegistrar(flutter::PluginRegistrarManager::GetInstance()->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
