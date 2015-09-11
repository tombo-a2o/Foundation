include ../Makefile.template

CC			= emcc
CFLAGS		= -v -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I./src -I./include -I../CFNetwork/include -I../CFNetwork/private_include -I../Security/include -I./ -DVERSION=$(VERSION) -include ../CoreFoundation/src/CoreFoundation_Prefix.h -include ../../global.pch -include ../../debug.pch -include ../../Fixme.pch

BUILD_DIR	= build/debug
INSTALL_DIR	= $(EMSCRIPTEN)/system/frameworks
SOURCES		= $(wildcard src/*.m src/*.c)
HEADERS		= $(wildcard include/**/*.h private_include/**/*.h)

$(eval $(call framework_build, Foundation, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(HEADERS)))

src/NSPredicateLexer.m: src/NSPredicateLexer.lm
	lex -t $< > $@
