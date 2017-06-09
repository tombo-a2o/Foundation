include ../Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I./src -I./include -I./private_include -I./ -DVERSION=$(VERSION) -include ../CoreFoundation/src/CoreFoundation_Prefix.h -include ../../global.pch -include ../debug.pch -include ../Fixme.pch -s DISABLE_EXCEPTION_CATCHING=0
CFLAGS = -x objective-c -std=gnu99 -s DISABLE_EXCEPTION_CATCHING=0
STYLE_LFLAGS ?= -O0 -g2
LFLAGS =

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks
SOURCES			= $(wildcard src/*.mm src/*.m src/*.c) src/NSPredicateLexer.m
PUBLIC_HEADERS	= $(wildcard include/**/*.h private_include/**/*.h)
PRIVATE_HEADERS	= $(wildcard include/**/*.h private_include/**/*.h)
RESOURCE_DIR	= resource
MODULE_MAP		= modules/module.modulemap

$(eval $(call framework_build, Foundation, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR), $(MODULE_MAP)))

src/NSPredicateLexer.m: src/NSPredicateLexer.lm
	lex -t $< > $@
