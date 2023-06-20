TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SecondApp
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = SecondApp

SecondApp_FILES = AppDelegate.swift RootViewController.swift
SecondApp_FRAMEWORKS = UIKit CoreGraphics
SecondApp_SWIFTFLAGS = -Ounchecked

include $(THEOS_MAKE_PATH)/application.mk

before-stage::
	rm -rf SecondApp.ipa

after-stage::
	cp -r .theos/_/Applications ./Payload
	zip SecondApp.ipa -qr ./Payload -x "*.DS_Store"
	rm -rf ./Payload
