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

all: $(OBJBASE)/Social_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/Social:
	/bin/mkdir -p $(OBJBASE)/Social

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/Social
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/Social_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/Social_$(STYLE).bc $^
	rm -f $(OBJBASE)/Social_$(STYLE)
	llvm-ar rcs $(OBJBASE)/Social_$(STYLE) $(OBJBASE)/Social_$(STYLE).bc

install: $(OBJBASE)/Social_$(STYLE)
	/bin/rm -rf $(DSTBASE)/Social.framework
	/bin/mkdir -p $(DSTBASE)/Social.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Social.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/Social.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/Social.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/Social.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/Social.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/Social.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/Social $(DSTBASE)/Social.framework/Social
	#/bin/cp Info.plist $(DSTBASE)/Social.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Social.framework/Versions/A/Resources/en.lproj
	/bin/cp include/Social/* $(DSTBASE)/Social.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/Social_$(STYLE) $(DSTBASE)/Social.framework/Versions/A/Social
	@echo "Installing done.  The framework is in $(DSTBASE)"

