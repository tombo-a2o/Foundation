
MIN_MACOSX_VERSION=10.9
MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9

SOURCES = CFProxySupport.c HTTP/CFHTTPMessage.c HTTP/CFHTTPStream.c URL/CFURLRequest.c URL/CFURLCache.c URL/CFURLConnection.c Utils/CFRuntimeUtils.c Utils/CFFSUtils.c Utils/CFHTTPUtils.c
MSOURCES = 
OBJECTS = $(patsubst %.c,%.o,$(SOURCES)) $(patsubst %.m,%.o,$(MSOURCES))
HFILES = $(wildcard *.h) $(wildcard Headers/*.h) $(wildcard SharedCode/*.h) $(wildcard Proxies/*.h)
#HFILES = $(wildcard *.h)
INTERMEDIATE_HFILES = $(addprefix $(OBJBASE)/CFNetwork/,$(HFILES))

PUBLIC_HEADERS_=CFFTPStream.h CFHTTPAuthentication.h CFHTTPMessage.h CFHTTPStream.h CFHost.h CFNetDiagnostics.h CFNetServices.h CFNetwork.h CFNetworkDefs.h CFNetworkErrors.h CFProxySupport.h CFSocketStream.h
PUBLIC_HEADERS=$(addprefix Headers/,$(PUBLIC_HEADERS_))

PRIVATE_HEADERS=

OBJBASE_ROOT = CF-Objects
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(if $(DSTROOT),$(DSTROOT),$(EMSCRIPTEN)/system/frameworks)

STYLE=normal
STYLE_CFLAGS=-O2
STYLE_LFLAGS=
ARCHFLAGS=

CC = emcc

CFLAGS=-v -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I$(OBJBASE) -I../../Foundation/include -I../../Foundation/src -I../include -I../private_include -I../private_include/CFNetwork -I../../CoreFoundation/src -I./ -I./Headers -I./Utils -I./SharedCode -I./Proxies -DVERSION=$(VERSION) -include ../../global.pch -include ../../debug.pch -include ../../Fixme.pch -include ../../CoreFoundation/src/CoreFoundation_Prefix.h -s USE_ZLIB=1

LFLAGS=-dynamiclib -mmacosx-version-min=$(MIN_MACOSX_VERSION) -twolevel_namespace -fexceptions -compatibility_version 150 -current_version $(VERSION) -Wl,-alias_list,SymbolAliases 


.PHONY: all install clean
.PRECIOUS: $(OBJBASE)/CFNetwork/%.h

all: $(OBJBASE)/CFNetwork_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE_ROOT)

$(OBJBASE)/CFNetwork:
	/bin/mkdir -p $(OBJBASE)/CFNetwork

$(OBJBASE)/CFNetwork/%.h: %.h $(OBJBASE)/CFNetwork
	mkdir -p $(dir $@)
	/bin/cp $< $@

$(OBJBASE)/%.o: %.c $(INTERMEDIATE_HFILES)
	mkdir -p $(dir $@)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/%.o: %.m $(INTERMEDIATE_HFILES)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(INTERMEDIATE_HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CFNetwork_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CFNetwork_$(STYLE).bc $^
	rm -f $(OBJBASE)/CFNetwork_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CFNetwork_$(STYLE) $(OBJBASE)/CFNetwork_$(STYLE).bc

install: $(OBJBASE)/CFNetwork_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CFNetwork.framework
	/bin/mkdir -p $(DSTBASE)/CFNetwork.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CFNetwork.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CFNetwork.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CFNetwork.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CFNetwork.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CFNetwork.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CFNetwork.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CFNetwork $(DSTBASE)/CFNetwork.framework/CFNetwork
	/bin/cp Info.plist $(DSTBASE)/CFNetwork.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CFNetwork.framework/Versions/A/Resources/en.lproj
	/bin/cp $(PUBLIC_HEADERS) $(DSTBASE)/CFNetwork.framework/Versions/A/Headers
	#/bin/cp $(PRIVATE_HEADERS) $(DSTBASE)/CFNetwork.framework/Versions/A/PrivateHeaders
	#/usr/bin/strip -S -o $(DSTBASE)/CFNetwork.framework/Versions/A/CFNetwork $(OBJBASE)/CFNetwork_$(STYLE)
	/bin/cp $(OBJBASE)/CFNetwork_$(STYLE) $(DSTBASE)/CFNetwork.framework/Versions/A/CFNetwork
	#/usr/bin/dsymutil $(DSTBASE)/CFNetwork.framework/Versions/A/CFNetwork -o $(DSTBASE)/CFNetwork.framework.dSYM
	#/usr/sbin/chown -RH -f root:wheel $(DSTBASE)/CFNetwork.framework
	#/bin/chmod -RH a-w,a+rX $(DSTBASE)/CFNetwork.framework
	#/bin/chmod -RH u+w $(DSTBASE)
	#install_name_tool -id /System/Library/Frameworks/CFNetwork.framework/Versions/A/CFNetwork $(DSTBASE)/CFNetwork.framework/Versions/A/CFNetwork
	@echo "Installing done.  The framework is in $(DSTBASE)"

