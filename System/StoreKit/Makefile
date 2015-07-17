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

all: $(OBJBASE)/StoreKit_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/StoreKit:
	/bin/mkdir -p $(OBJBASE)/StoreKit

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/StoreKit
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/StoreKit_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/StoreKit_$(STYLE).bc $^
	rm -f $(OBJBASE)/StoreKit_$(STYLE)
	llvm-ar rcs $(OBJBASE)/StoreKit_$(STYLE) $(OBJBASE)/StoreKit_$(STYLE).bc

install: $(OBJBASE)/StoreKit_$(STYLE)
	/bin/rm -rf $(DSTBASE)/StoreKit.framework
	/bin/mkdir -p $(DSTBASE)/StoreKit.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/StoreKit.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/StoreKit.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/StoreKit.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/StoreKit.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/StoreKit.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/StoreKit.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/StoreKit $(DSTBASE)/StoreKit.framework/StoreKit
	#/bin/cp Info.plist $(DSTBASE)/StoreKit.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/StoreKit.framework/Versions/A/Resources/en.lproj
	/bin/cp include/StoreKit/* $(DSTBASE)/StoreKit.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/StoreKit_$(STYLE) $(DSTBASE)/StoreKit.framework/Versions/A/StoreKit
	@echo "Installing done.  The framework is in $(DSTBASE)"

