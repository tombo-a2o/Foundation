SOURCES= \
    CGAffineTransform.c \
    CGBitmapContext.c \
    CGBlt.c \
    CGColor.c \
    CGColorSpace.c \
    CGColorTransform.c \
    CGColorTransformBase.c \
    CGContext.c \
    CGContextDelegate.c \
    CGDash.c \
    CGDataProvider.c \
    CGDefaults.c \
    CGDirectDisplay.c \
    CGDisplayList.c \
    CGError.c \
    CGFont.c \
    CGFunction.c \
    CGGState.c \
    CGGeometry.c \
    CGImage.c \
    CGLayer.c \
    CGLibrary.c \
    CGNotificationCenter.c \
    CGPath.c \
    CGRenderingState.c \
    CGSoftMask.c \
    CGStyle.c \
    CGTypesPriv.c \
    CGZone.c
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))
HFILES = $(wildcard *.h) $(wildcard include/**/*.h)


OBJBASE_ROOT = build
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(EMSCRIPTEN)/system/frameworks

STYLE=normal
STYLE_CFLAGS=-O2
STYLE_LFLAGS=
ARCHFLAGS=

CC = emcc

MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9
CFLAGS=-v -c -x c++ -std=c++11 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DCF_BUILDING_CF=1 -I./include -I./ -I../CoreFoundation/src -include ../CoreFoundation/src/CoreFoundation_Prefix.h

.PHONY: all install clean

all: $(OBJBASE)/CoreGraphics_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/CoreGraphics:
	/bin/mkdir -p $(OBJBASE)/CoreGraphics

$(OBJBASE)/%.o: %.c $(HFILES) $(OBJBASE)/CoreGraphics
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreGraphics_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreGraphics_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreGraphics_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreGraphics_$(STYLE) $(OBJBASE)/CoreGraphics_$(STYLE).bc

install: $(OBJBASE)/CoreGraphics_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreGraphics.framework
	/bin/mkdir -p $(DSTBASE)/CoreGraphics.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreGraphics.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreGraphics.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreGraphics.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreGraphics.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreGraphics.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreGraphics.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreGraphics $(DSTBASE)/CoreGraphics.framework/CoreGraphics
	#/bin/cp Info.plist $(DSTBASE)/CoreGraphics.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreGraphics.framework/Versions/A/Resources/en.lproj
	/bin/cp include/CoreGraphics/* $(DSTBASE)/CoreGraphics.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/CoreGraphics_$(STYLE) $(DSTBASE)/CoreGraphics.framework/Versions/A/CoreGraphics
	@echo "Installing done.  The framework is in $(DSTBASE)"

