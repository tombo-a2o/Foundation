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

all: $(OBJBASE)/AVFoundation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/AVFoundation:
	/bin/mkdir -p $(OBJBASE)/AVFoundation

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/AVFoundation
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/AVFoundation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/AVFoundation_$(STYLE).bc $^
	rm -f $(OBJBASE)/AVFoundation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/AVFoundation_$(STYLE) $(OBJBASE)/AVFoundation_$(STYLE).bc

install: $(OBJBASE)/AVFoundation_$(STYLE)
	/bin/rm -rf $(DSTBASE)/AVFoundation.framework
	/bin/mkdir -p $(DSTBASE)/AVFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/AVFoundation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/AVFoundation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/AVFoundation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/AVFoundation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/AVFoundation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/AVFoundation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/AVFoundation $(DSTBASE)/AVFoundation.framework/AVFoundation
	#/bin/cp Info.plist $(DSTBASE)/AVFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/AVFoundation.framework/Versions/A/Resources/en.lproj
	/bin/cp include/AVFoundation/* $(DSTBASE)/AVFoundation.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/AVFoundation_$(STYLE) $(DSTBASE)/AVFoundation.framework/Versions/A/AVFoundation
	@echo "Installing done.  The framework is in $(DSTBASE)"

