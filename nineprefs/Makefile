include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = nineprefs
nineprefs_FILES = NINERootListController.m NINEHeaderCell.m
nineprefs_INSTALL_PATH = /Library/PreferenceBundles
nineprefs_FRAMEWORKS = UIKit
nineprefs_PRIVATE_FRAMEWORKS = Preferences
nineprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
nineprefs_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nineprefs.plist$(ECHO_END)
