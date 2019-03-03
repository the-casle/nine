SIMULATOR=0

ifeq ($(SIMULATOR),1)
ARCHS = x86_64
TARGET = simulator:clang:12.1:11.1 
else
ARCHS = arm64
TARGET = iphone:clang:11.2:11.1
export IPHONE_SIMULATOR_ROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs
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

after-install::
ifneq ($(SIMULATOR),1)
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nineprefs
endif

after-all::
ifeq ($(SIMULATOR),1)
	rm /opt/simject/$(TWEAK_NAME).dylib
	cp .theos/obj/iphone_simulator/debug/$(TWEAK_NAME).dylib /opt/simject/
	~/Development/simject/bin/respring_simulator
endif

include $(THEOS_MAKE_PATH)/aggregate.mk
