#ARCHS = armv7 arm64
#TARGET = iphone:clang:latest:latest
TARGET = simulator:clang:latest:7.0
THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Forcy
Forcy_USE_SUBSTRATE = 0
Forcy_FILES = Tweak.xm ForcyMenus.xm
Forcy_FRAMEWORKS = UIKit AudioToolbox Photos
Forcy_PRIVATE_FRAMEWORKS = BackBoardServices DCIMServices SAObjects

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += forcyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
