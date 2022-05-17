BUNDLE_NAME = EnekoPreferences
EnekoPreferences_FILES = $(wildcard *.m)
EnekoPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
EnekoPreferences_INSTALL_PATH = /Library/PreferenceBundles
EnekoPreferences_PRIVATE_FRAMEWORKS = Preferences
EnekoPreferences_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
EnekoPreferences_LIBRARIES = gcuniversal

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/EnekoPreferences.plist$(ECHO_END)
