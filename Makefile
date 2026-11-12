TARGET := iphone:clang:latest:6.0
export TARGET=iphone:clang:7.0
INSTALL_TARGET_PROCESSES = geod Maps

ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MapsX

MapsX_FILES = Tweak.x \
			addtoken.xm \
			directions.x \
			urlpatches.x \
			shields.x \
			GEOTokenManager.m \
			GEOQueryToLatLng.m \
			GEONewerClasses.m \
			GEOShieldMappingManager.m \
			shieldmap-protobuf/GEOXShieldMap.m \
			attribution.x \
			pois.x \
			polygons.xm \
			landmark3d.xm \
			satellite.x

MapsX_LIBRARIES = heif de265 c++
MapsX_CFLAGS = -fobjc-arc -Wno-gcc-compat -Ilib/libheif/include
MapsX_LDFLAGS = -Llib/libheif/lib -Llib/libde265/lib
MapsX_FRAMEWORKS = Foundation CoreFoundation SystemConfiguration UIKit CoreGraphics
MapsX_PRIVATE_FRAMEWORKS = ProtocolBuffer GeoServices VectorKit

include $(THEOS_MAKE_PATH)/tweak.mk
