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

all: $(OBJBASE)/MultipeerConnectivity_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/MultipeerConnectivity:
	/bin/mkdir -p $(OBJBASE)/MultipeerConnectivity

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/MultipeerConnectivity
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/MultipeerConnectivity_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/MultipeerConnectivity_$(STYLE).bc $^
	rm -f $(OBJBASE)/MultipeerConnectivity_$(STYLE)
	llvm-ar rcs $(OBJBASE)/MultipeerConnectivity_$(STYLE) $(OBJBASE)/MultipeerConnectivity_$(STYLE).bc

install: $(OBJBASE)/MultipeerConnectivity_$(STYLE)
	/bin/rm -rf $(DSTBASE)/MultipeerConnectivity.framework
	/bin/mkdir -p $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/MultipeerConnectivity.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/MultipeerConnectivity.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/MultipeerConnectivity.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/MultipeerConnectivity.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/MultipeerConnectivity $(DSTBASE)/MultipeerConnectivity.framework/MultipeerConnectivity
	#/bin/cp Info.plist $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/Resources/en.lproj
	/bin/cp include/MultipeerConnectivity/* $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/MultipeerConnectivity_$(STYLE) $(DSTBASE)/MultipeerConnectivity.framework/Versions/A/MultipeerConnectivity
	@echo "Installing done.  The framework is in $(DSTBASE)"

