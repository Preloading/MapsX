TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MapsX

MapsX_FILES = Tweak.x TokenManager.m QueryToLatLng.m GEONewerClasses.m
MapsX_CFLAGS = -fobjc-arc
MapsX_FRAMEWORKS = Foundation CoreFoundation
MapsX_PRIVATE_FRAMEWORKS = ProtocolBuffer GeoServices

include $(THEOS_MAKE_PATH)/tweak.mk
