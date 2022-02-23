#pragma once

#include "winrt/Microsoft.ReactNative.h"

namespace winrt::game_app_development_2022_proj_1::implementation {
struct ReactPackageProvider
	: winrt::implements<ReactPackageProvider,
						winrt::Microsoft::ReactNative::IReactPackageProvider> {
   public:	// IReactPackageProvider
	void CreatePackage(
		winrt::Microsoft::ReactNative::IReactPackageBuilder const&
			packageBuilder) noexcept;
};
}  // namespace winrt::game_app_development_2022_proj_1::implementation
