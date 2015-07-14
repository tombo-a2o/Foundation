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
CFLAGS=-v -c -x objective-c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DCF_BUILDING_CF=1 -I./include -I./ -I../CoreFoundation/src -I../Foundation/src -include ../CoreFoundation/src/CoreFoundation_Prefix.h

.PHONY: all install clean

all: $(OBJBASE)/CoreAnimation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/CoreAnimation:
	/bin/mkdir -p $(OBJBASE)/CoreAnimation

$(OBJBASE)/%.o: %.m $(HFILES) $(OBJBASE)/CoreAnimation
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreAnimation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreAnimation_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreAnimation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreAnimation_$(STYLE) $(OBJBASE)/CoreAnimation_$(STYLE).bc

install: $(OBJBASE)/CoreAnimation_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreAnimation.framework
	/bin/mkdir -p $(DSTBASE)/CoreAnimation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreAnimation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreAnimation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreAnimation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreAnimation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreAnimation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreAnimation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreAnimation $(DSTBASE)/CoreAnimation.framework/CoreAnimation
	#/bin/cp Info.plist $(DSTBASE)/CoreAnimation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreAnimation.framework/Versions/A/Resources/en.lproj
	/bin/cp include/QuartzCore/* $(DSTBASE)/CoreAnimation.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/CoreAnimation_$(STYLE) $(DSTBASE)/CoreAnimation.framework/Versions/A/CoreAnimation
	@echo "Installing done.  The framework is in $(DSTBASE)"

