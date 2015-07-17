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

all: $(OBJBASE)/ImageIO_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/ImageIO:
	/bin/mkdir -p $(OBJBASE)/ImageIO

$(OBJBASE)/%.o: src/%.c $(HFILES) $(OBJBASE)/ImageIO
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/ImageIO_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/ImageIO_$(STYLE).bc $^
	rm -f $(OBJBASE)/ImageIO_$(STYLE)
	llvm-ar rcs $(OBJBASE)/ImageIO_$(STYLE) $(OBJBASE)/ImageIO_$(STYLE).bc

install: $(OBJBASE)/ImageIO_$(STYLE)
	/bin/rm -rf $(DSTBASE)/ImageIO.framework
	/bin/mkdir -p $(DSTBASE)/ImageIO.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/ImageIO.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/ImageIO.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/ImageIO.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/ImageIO.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/ImageIO.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/ImageIO.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/ImageIO $(DSTBASE)/ImageIO.framework/ImageIO
	#/bin/cp Info.plist $(DSTBASE)/ImageIO.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/ImageIO.framework/Versions/A/Resources/en.lproj
	/bin/cp include/ImageIO/* $(DSTBASE)/ImageIO.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/ImageIO_$(STYLE) $(DSTBASE)/ImageIO.framework/Versions/A/ImageIO
	@echo "Installing done.  The framework is in $(DSTBASE)"

