SOURCES= Dummy.m
OBJECTS = $(patsubst %.m,%.o,$(SOURCES))
HFILES = $(wildcard include/**/*.h)


OBJBASE_ROOT = build
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(EMSCRIPTEN)/system/frameworks

STYLE=normal
STYLE_CFLAGS=-O2
STYLE_LFLAGS=
ARCHFLAGS=

CC = emcc

MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9
CFLAGS=-v -c -x objective-c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DCF_BUILDING_CF=1 -I./include -I./ -I../CoreFoundation/src -I../Foundation/src -I../CFNetwork/include -include ../CoreFoundation/src/CoreFoundation_Prefix.h

.PHONY: all install clean

all: $(OBJBASE)/GameKit_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/GameKit:
	/bin/mkdir -p $(OBJBASE)/GameKit

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/GameKit
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/GameKit_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/GameKit_$(STYLE).bc $^
	rm -f $(OBJBASE)/GameKit_$(STYLE)
	llvm-ar rcs $(OBJBASE)/GameKit_$(STYLE) $(OBJBASE)/GameKit_$(STYLE).bc

install: $(OBJBASE)/GameKit_$(STYLE)
	/bin/rm -rf $(DSTBASE)/GameKit.framework
	/bin/mkdir -p $(DSTBASE)/GameKit.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/GameKit.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/GameKit.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/GameKit.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/GameKit.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/GameKit.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/GameKit.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/GameKit $(DSTBASE)/GameKit.framework/GameKit
	#/bin/cp Info.plist $(DSTBASE)/GameKit.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/GameKit.framework/Versions/A/Resources/en.lproj
	/bin/cp include/GameKit/* $(DSTBASE)/GameKit.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/GameKit_$(STYLE) $(DSTBASE)/GameKit.framework/Versions/A/GameKit
	@echo "Installing done.  The framework is in $(DSTBASE)"

