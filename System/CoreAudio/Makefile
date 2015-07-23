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

all: $(OBJBASE)/CoreAudio_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/CoreAudio:
	/bin/mkdir -p $(OBJBASE)/CoreAudio

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/CoreAudio
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreAudio_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreAudio_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreAudio_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreAudio_$(STYLE) $(OBJBASE)/CoreAudio_$(STYLE).bc

install: $(OBJBASE)/CoreAudio_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreAudio.framework
	/bin/mkdir -p $(DSTBASE)/CoreAudio.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreAudio.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreAudio.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreAudio.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreAudio.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreAudio.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreAudio.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreAudio $(DSTBASE)/CoreAudio.framework/CoreAudio
	#/bin/cp Info.plist $(DSTBASE)/CoreAudio.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreAudio.framework/Versions/A/Resources/en.lproj
	/bin/cp include/CoreAudio/* $(DSTBASE)/CoreAudio.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/CoreAudio_$(STYLE) $(DSTBASE)/CoreAudio.framework/Versions/A/CoreAudio
	@echo "Installing done.  The framework is in $(DSTBASE)"

