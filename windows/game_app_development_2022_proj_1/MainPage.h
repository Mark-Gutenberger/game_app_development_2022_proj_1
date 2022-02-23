#pragma once
#include <winrt/Microsoft.ReactNative.h>
#include "MainPage.g.h"

namespace winrt::game_app_development_2022_proj_1::implementation {
struct MainPage : MainPageT<MainPage> {
	MainPage();
};
}  // namespace winrt::game_app_development_2022_proj_1::implementation

namespace winrt::game_app_development_2022_proj_1::factory_implementation {
struct MainPage : MainPageT<MainPage, implementation::MainPage> {};
}  // namespace winrt::game_app_development_2022_proj_1::factory_implementation
