#include "ReactPackageProvider.h"
#include "NativeModules.h"
#include "pch.h"

using namespace winrt::Microsoft::ReactNative;

namespace winrt::game_app_development_2022_proj_1::implementation {

void ReactPackageProvider::CreatePackage(
	IReactPackageBuilder const& packageBuilder) noexcept {
	AddAttributedModules(packageBuilder);
}

}  // namespace winrt::game_app_development_2022_proj_1::implementation
