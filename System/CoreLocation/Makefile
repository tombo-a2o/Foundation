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

all: $(OBJBASE)/CoreLocation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/CoreLocation:
	/bin/mkdir -p $(OBJBASE)/CoreLocation

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/CoreLocation
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreLocation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreLocation_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreLocation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreLocation_$(STYLE) $(OBJBASE)/CoreLocation_$(STYLE).bc

install: $(OBJBASE)/CoreLocation_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreLocation.framework
	/bin/mkdir -p $(DSTBASE)/CoreLocation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreLocation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreLocation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreLocation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreLocation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreLocation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreLocation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreLocation $(DSTBASE)/CoreLocation.framework/CoreLocation
	#/bin/cp Info.plist $(DSTBASE)/CoreLocation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreLocation.framework/Versions/A/Resources/en.lproj
	/bin/cp include/CoreLocation/* $(DSTBASE)/CoreLocation.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/CoreLocation_$(STYLE) $(DSTBASE)/CoreLocation.framework/Versions/A/CoreLocation
	@echo "Installing done.  The framework is in $(DSTBASE)"

