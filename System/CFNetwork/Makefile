include ../Makefile.template

CC				= emcc
CFLAGS			= -v -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I./src -I./include -I./private_include -I./src/Headers -I./src/Utils -I./src/SharedCode -I./src/Proxies -I./src/HTTP -DVERSION=$(VERSION) -include ../global.pch -include ../debug.pch -include ../Fixme.pch -include ../CoreFoundation/src/CoreFoundation_Prefix.h -s USE_ZLIB=1

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= src/CFDummy.c
PUBLIC_HEADERS	= $(wildcard include/**/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/**/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CFNetwork, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
