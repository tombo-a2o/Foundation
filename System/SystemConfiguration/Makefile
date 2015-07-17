SOURCES= Dummy.c
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))
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

all: $(OBJBASE)/SystemConfiguration_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/SystemConfiguration:
	/bin/mkdir -p $(OBJBASE)/SystemConfiguration

$(OBJBASE)/%.o: src/%.c $(HFILES) $(OBJBASE)/SystemConfiguration
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/SystemConfiguration_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/SystemConfiguration_$(STYLE).bc $^
	rm -f $(OBJBASE)/SystemConfiguration_$(STYLE)
	llvm-ar rcs $(OBJBASE)/SystemConfiguration_$(STYLE) $(OBJBASE)/SystemConfiguration_$(STYLE).bc

install: $(OBJBASE)/SystemConfiguration_$(STYLE)
	/bin/rm -rf $(DSTBASE)/SystemConfiguration.framework
	/bin/mkdir -p $(DSTBASE)/SystemConfiguration.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/SystemConfiguration.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/SystemConfiguration.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/SystemConfiguration.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/SystemConfiguration.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/SystemConfiguration.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/SystemConfiguration.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/SystemConfiguration $(DSTBASE)/SystemConfiguration.framework/SystemConfiguration
	#/bin/cp Info.plist $(DSTBASE)/SystemConfiguration.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/SystemConfiguration.framework/Versions/A/Resources/en.lproj
	/bin/cp include/SystemConfiguration/* $(DSTBASE)/SystemConfiguration.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/SystemConfiguration_$(STYLE) $(DSTBASE)/SystemConfiguration.framework/Versions/A/SystemConfiguration
	@echo "Installing done.  The framework is in $(DSTBASE)"

