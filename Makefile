include theos/makefiles/common.mk

TWEAK_NAME = Forcy
Forcy_FILES = Tweak.xm
Forcy_FRAMEWORKS = IOKit UIKit AudioToolbox
Forcy_PRIVATE_FRAMEWORKS = BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
