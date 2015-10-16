ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = Forcy
Forcy_FILES = Tweak.xm
Forcy_FRAMEWORKS = UIKit AudioToolbox
Forcy_PRIVATE_FRAMEWORKS = BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += forcyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
