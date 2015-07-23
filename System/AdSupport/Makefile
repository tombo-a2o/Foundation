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

all: $(OBJBASE)/AdSupport_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/AdSupport:
	/bin/mkdir -p $(OBJBASE)/AdSupport

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/AdSupport
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/AdSupport_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/AdSupport_$(STYLE).bc $^
	rm -f $(OBJBASE)/AdSupport_$(STYLE)
	llvm-ar rcs $(OBJBASE)/AdSupport_$(STYLE) $(OBJBASE)/AdSupport_$(STYLE).bc

install: $(OBJBASE)/AdSupport_$(STYLE)
	/bin/rm -rf $(DSTBASE)/AdSupport.framework
	/bin/mkdir -p $(DSTBASE)/AdSupport.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/AdSupport.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/AdSupport.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/AdSupport.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/AdSupport.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/AdSupport.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/AdSupport.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/AdSupport $(DSTBASE)/AdSupport.framework/AdSupport
	#/bin/cp Info.plist $(DSTBASE)/AdSupport.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/AdSupport.framework/Versions/A/Resources/en.lproj
	/bin/cp include/AdSupport/* $(DSTBASE)/AdSupport.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/AdSupport_$(STYLE) $(DSTBASE)/AdSupport.framework/Versions/A/AdSupport
	@echo "Installing done.  The framework is in $(DSTBASE)"

