SOURCES= \
    CAAnimation.m \
    CABackingStore.m \
    CABase.m \
    CADisplayLink.m \
    CAEAGLLayer.m \
    CAGradientLayer.m \
    CAImplicitAnimationObserver.m \
    CALayer+DynamicProperties.m \
    CALayer.m \
    CAMediaTiming.m \
    CAMediaTimingFunction.m \
    CARenderer.m \
    CAReplicatorLayer.m \
    CAScrollLayer.m \
    CAShapeLayer.m \
    CATextLayer.m \
    CATiledLayer.m \
    CATransaction.m \
    CATransform3D.m \
    CATransformLayer.m \
    CAValueFunction.m
OBJECTS = $(patsubst %.m,%.o,$(SOURCES))
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
CFLAGS=-v -c -x objective-c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DCF_BUILDING_CF=1 -I./include -I./ -I../CoreFoundation/src -I../Foundation/src -I../CFNetwork/include -include ../CoreFoundation/src/CoreFoundation_Prefix.h

.PHONY: all install clean

all: $(OBJBASE)/QuartzCore_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/QuartzCore:
	/bin/mkdir -p $(OBJBASE)/QuartzCore

$(OBJBASE)/%.o: %.m $(HFILES) $(OBJBASE)/QuartzCore
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/QuartzCore_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/QuartzCore_$(STYLE).bc $^
	rm -f $(OBJBASE)/QuartzCore_$(STYLE)
	llvm-ar rcs $(OBJBASE)/QuartzCore_$(STYLE) $(OBJBASE)/QuartzCore_$(STYLE).bc

install: $(OBJBASE)/QuartzCore_$(STYLE)
	/bin/rm -rf $(DSTBASE)/QuartzCore.framework
	/bin/mkdir -p $(DSTBASE)/QuartzCore.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/QuartzCore.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/QuartzCore.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/QuartzCore.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/QuartzCore.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/QuartzCore.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/QuartzCore.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/QuartzCore $(DSTBASE)/QuartzCore.framework/QuartzCore
	#/bin/cp Info.plist $(DSTBASE)/QuartzCore.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/QuartzCore.framework/Versions/A/Resources/en.lproj
	/bin/cp include/QuartzCore/* $(DSTBASE)/QuartzCore.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/QuartzCore_$(STYLE) $(DSTBASE)/QuartzCore.framework/Versions/A/QuartzCore
	@echo "Installing done.  The framework is in $(DSTBASE)"

