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

all: $(OBJBASE)/Accounts_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/Accounts:
	/bin/mkdir -p $(OBJBASE)/Accounts

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/Accounts
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/Accounts_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/Accounts_$(STYLE).bc $^
	rm -f $(OBJBASE)/Accounts_$(STYLE)
	llvm-ar rcs $(OBJBASE)/Accounts_$(STYLE) $(OBJBASE)/Accounts_$(STYLE).bc

install: $(OBJBASE)/Accounts_$(STYLE)
	/bin/rm -rf $(DSTBASE)/Accounts.framework
	/bin/mkdir -p $(DSTBASE)/Accounts.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Accounts.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/Accounts.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/Accounts.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/Accounts.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/Accounts.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/Accounts.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/Accounts $(DSTBASE)/Accounts.framework/Accounts
	#/bin/cp Info.plist $(DSTBASE)/Accounts.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Accounts.framework/Versions/A/Resources/en.lproj
	/bin/cp include/Accounts/* $(DSTBASE)/Accounts.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/Accounts_$(STYLE) $(DSTBASE)/Accounts.framework/Versions/A/Accounts
	@echo "Installing done.  The framework is in $(DSTBASE)"

