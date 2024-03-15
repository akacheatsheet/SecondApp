# 端末のIPアドレスに合わせて変更
THEOS_DEVICE_IP = 192.168.68.54

# rootful環境ではコメントアウト
THEOS_PACKAGE_SCHEME = rootless

# 非脱獄端末なら必要
# NoJB = 1

# パッケージのフォーマット (deb か ipa)
PACKAGE_FORMAT = ipa

TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SecondApp
ARCHS = arm64
FINALPACKAGE = 1#Strips debug symbols (i.e., DEBUG=0 STRIP=1)
# FOR_RELEASE = 1# An alias for FINALPACKAGE
# DEBUG = 0
# STRIP = 1

# prefixを自動追加する場合は1
ADD_PREFIX = 0

# rootless vs 非脱獄 -> 非脱獄優先
ifneq ($(and $(THEOS_PACKAGE_SCHEME),$(NoJB)),)
undefine THEOS_PACKAGE_SCHEME
endif

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = SecondApp

SecondApp_FILES = AppDelegate.swift RootViewController.swift
SecondApp_FRAMEWORKS = UIKit CoreGraphics
SecondApp_SWIFTFLAGS = -Ounchecked

# iGameGod
SecondApp_FRAMEWORKS += iGameGod
SecondApp_LDFLAGS += -Flayout/Applications/SecondApp.app/Frameworks
SecondApp_LDFLAGS += -Wl,-rpath,@executable_path/Frameworks/

# CustomOffsetPatcher
ifneq ($(NoJB),1)
SecondApp_LDFLAGS += layout/Applications/SecondApp.app/Frameworks/iGameGod/CustomOffsetPatcheriOSGodsCom.dylib
SecondApp_LDFLAGS += -Wl,-rpath,@executable_path/Frameworks/iGameGod
endif

include $(THEOS_MAKE_PATH)/application.mk

.PHONY: add-prefix
add-prefix:
	$(info ===> add prefix)
	@cd packages && \
	for file in *; do \
		if [[ "$$file" == rootless.* ]] || [[ "$$file" == rootful.* ]]; then \
			continue; \
		fi; \
		if [[ "$$file" == *iphoneos-arm64.deb ]]; then \
			mv "$$file" "rootless.$$file"; \
		elif [[ "$$file" == *.ipa ]] && [[ "$(NoJB)" == "1" ]]; then \
			mv "$$file" "NoJB.$$file"; \
		else \
			mv "$$file" "rootful.$$file"; \
		fi; \
	done

after-package::
	@if [ "$(ADD_PREFIX)" = "1" ]; then \
		$(MAKE) add-prefix; \
	fi
