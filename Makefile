include $(THEOS)/makefiles/common.mk

ARCHS=arm64 armv7 armv7s

ADDITIONAL_OBJCFLAGS = -fobjc-arc

TOOL_NAME = UpdateProxySettings

UpdateProxySettings_FILES = main.mm WiFiProxyToggler.m
UpdateProxySettings_FRAMEWORKS = UIKit Foundation SystemConfiguration
UpdateProxySettings_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/tool.mk