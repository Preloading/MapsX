TARGET := iphone:clang:latest:6.0
export TARGET=iphone:clang:7.0
INSTALL_TARGET_PROCESSES = geod

ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MapsX

MapsX_FILES = Tweak.x TokenManager.m
MapsX_CFLAGS = -fobjc-arc
MapsX_FRAMEWORKS = Foundation CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk
