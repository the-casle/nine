SIMULATOR=1

ifeq ($(SIMULATOR),1)
ARCHS = x86_64
TARGET = simulator:clang:12.1:11.1 
else
ARCHS = arm64
TARGET = iphone:clang:11.2:11.1
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = nine
nine_FILES = $(wildcard *.xm *.mm CustomWorks/*/*.m)


ifeq ($(SIMULATOR),1)
ADDITIONAL_OBJCFLAGS = -DSIMULATOR=1
else
$(TWEAK_NAME)_LIBRARIES += colorpicker
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = UIKit
endif


include $(THEOS_MAKE_PATH)/tweak.mk


ifeq ($(SIMULATOR),1)
after-install::
	install.exec "killall -9 SpringBoard"
include $(THEOS_MAKE_PATH)/aggregate.mk

else
after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nineprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
endif
