include $(THEOS)/makefiles/common.mk

TWEAK_NAME = nine
nine_FILES = $(wildcard *.xm *.mm CustomWorks/*/*.m)
nine_PRIVATE_FRAMEWORKS = UIKit
nine_EXTRA_FRAMEWORKS = Cephei
nine_LIBRARIES = colorpicker


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nineprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
