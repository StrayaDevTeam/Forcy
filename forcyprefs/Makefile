ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest

include theos/makefiles/common.mk

BUNDLE_NAME = ForcyPrefs
ForcyPrefs_FILES = $(wildcard *.mm)
ForcyPrefs_INSTALL_PATH = /Library/PreferenceBundles
ForcyPrefs_FRAMEWORKS = UIKit
ForcyPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ForcyPrefs.plist$(ECHO_END)
