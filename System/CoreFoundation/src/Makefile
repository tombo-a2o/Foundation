
include MakefileVersion

MIN_MACOSX_VERSION=10.9
MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9

SOURCES = CFApplicationPreferences.c CFArray.c CFAttributedString.c CFBag.c CFBase.c CFBasicHash.c CFBigNumber.c CFBinaryHeap.c CFBinaryPList.c CFBitVector.c CFBuiltinConverters.c CFBundle.c CFBundle_InfoPlist.c CFBundle_Resources.c CFBurstTrie.c CFCalendar.c CFCharacterSet.c CFConcreteStreams.c CFData.c CFDate.c CFDateFormatter.c CFDictionary.c CFError.c CFFileUtilities.c CFICUConverters.c CFLocale.c CFLocaleIdentifier.c CFLocaleKeys.c CFNumber.c CFNumberFormatter.c CFOldStylePList.c CFPlatform.c CFPlatformConverters.c CFPreferences.c CFPropertyList.c CFRuntime.c CFSet.c CFSocket.c CFSocketStream.c CFSortFunctions.c CFStorage.c CFStream.c CFString.c CFStringEncodingConverter.c CFStringEncodingDatabase.c CFStringEncodings.c CFStringScanner.c CFStringTokenizer.c CFStringUtilities.c CFSystemDirectories.c CFTimeZone.c CFTree.c CFURL.c CFURLAccess.c CFUUID.c CFUniChar.c CFUnicodeDecomposition.c CFUnicodePrecomposition.c CFUtilities.c CFVersion.c CFWindowsUtilities.c CFXMLInputStream.c CFXMLNode.c CFXMLParser.c CFXMLPreferencesDomain.c CFXMLTree.c
MSOURCES = CFStubs.m NSArray.m NSAttributedString.m NSBlock.m NSCFType.m NSCache.m NSCalendar.m NSCharacterSet.m NSConstantString.m NSData.m NSDate.m NSDateComponents.m NSDictionary.m NSEnumerator.m NSError.m NSException.m NSFastEnumerationEnumerator.m NSGenericDeallocHandler.m NSInputStream.m NSInvocation.m NSLocale.m NSMessageBuilder.m NSMethodSignature.m NSNull.m NSNumber.m NSObjCRuntime.m NSObject.m NSOrderedSet.m NSOutputStream.m NSPropertyList.m NSSet.m NSSharedKeyDictionary.m NSSharedKeySet.m NSStream.m NSString.m NSTimeZone.m NSTimer.m NSURL.m NSZombie.m
OBJECTS = $(patsubst %.c,%.o,$(SOURCES)) $(patsubst %.m,%.o,$(MSOURCES))
HFILES = $(wildcard *.h)
INTERMEDIATE_HFILES = $(addprefix $(OBJBASE)/CoreFoundation/,$(HFILES))

PUBLIC_HEADERS=CFArray.h CFBag.h CFBase.h CFBinaryHeap.h CFBitVector.h CFBundle.h CFByteOrder.h CFCalendar.h CFCharacterSet.h CFData.h CFDate.h CFDateFormatter.h CFDictionary.h CFError.h CFLocale.h CFMessagePort.h CFNumber.h CFNumberFormatter.h CFPlugIn.h CFPlugInCOM.h CFPreferences.h CFPropertyList.h CFRunLoop.h CFSet.h CFSocket.h CFStream.h CFString.h CFStringEncodingExt.h CFTimeZone.h CFTree.h CFURL.h CFURLAccess.h CFUUID.h CFUserNotification.h CFXMLNode.h CFXMLParser.h CFAvailability.h CFUtilities.h CoreFoundation.h

PRIVATE_HEADERS=CFBundlePriv.h CFCharacterSetPriv.h CFError_Private.h CFLogUtilities.h CFPriv.h CFRuntime.h CFStorage.h CFStreamAbstract.h CFStreamPriv.h CFStreamInternal.h CFStringDefaultEncoding.h CFStringEncodingConverter.h CFStringEncodingConverterExt.h CFUniChar.h CFUnicodeDecomposition.h CFUnicodePrecomposition.h ForFoundationOnly.h CFBurstTrie.h CFICULogging.h CFAttributedString.h CFNotificationCenter.h CFURLEnumerator.h

MACHINE_TYPE := $(shell uname -p)
unicode_data_file_name = $(if $(or $(findstring i386,$(1)),$(findstring i686,$(1)),$(findstring x86_64,$(1))),CFUnicodeData-L.mapping,CFUnicodeData-B.mapping)

OBJBASE_ROOT = CF-Objects
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(if $(DSTROOT),$(DSTROOT),../CF-Root)

STYLE=normal
STYLE_CFLAGS=-O2
STYLE_LFLAGS=
ARCHFLAGS=
INSTALLNAME=/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation_$(STYLE)

CC = emcc

CFLAGS=-v -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I$(OBJBASE) -I../../Foundation/include -I../../Foundation/src -I../../CFNetwork/include -I./ -DVERSION=$(VERSION) -include CoreFoundation_Prefix.h -include ../../global.pch -include ../../debug.pch -include ../../Fixme.pch

LFLAGS=-dynamiclib -mmacosx-version-min=$(MIN_MACOSX_VERSION) -twolevel_namespace -fexceptions -compatibility_version 150 -current_version $(VERSION) -Wl,-alias_list,SymbolAliases 


.PHONY: all install clean
.PRECIOUS: $(OBJBASE)/CoreFoundation/%.h

all: $(OBJBASE)/CoreFoundation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE_ROOT)

$(OBJBASE)/CoreFoundation:
	/bin/mkdir -p $(OBJBASE)/CoreFoundation

$(OBJBASE)/CoreFoundation/%.h: %.h $(OBJBASE)/CoreFoundation
	/bin/cp $< $@

$(OBJBASE)/%.o: %.c $(INTERMEDIATE_HFILES)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/%.o: %.m $(INTERMEDIATE_HFILES)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

%.ll: %.m $(INTERMEDIATE_HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreFoundation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	#$(CC) $(STYLE_LFLAGS) -install_name $(INSTALLNAME) $(ARCHFLAGS) $(LFLAGS) $^ -licucore.A -o $(OBJBASE)/CoreFoundation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreFoundation_$(STYLE) $^

install: $(OBJBASE)/CoreFoundation_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreFoundation.framework
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreFoundation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreFoundation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreFoundation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreFoundation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreFoundation $(DSTBASE)/CoreFoundation.framework/CoreFoundation
	/bin/cp Info.plist $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources/en.lproj
	/bin/cp $(PUBLIC_HEADERS) $(DSTBASE)/CoreFoundation.framework/Versions/A/Headers
	/bin/cp $(PRIVATE_HEADERS) $(DSTBASE)/CoreFoundation.framework/Versions/A/PrivateHeaders
	#/usr/bin/strip -S -o $(DSTBASE)/CoreFoundation.framework/Versions/A/CoreFoundation $(OBJBASE)/CoreFoundation_$(STYLE)
	/bin/cp $(OBJBASE)/CoreFoundation_$(STYLE) $(DSTBASE)/CoreFoundation.framework/Versions/A/CoreFoundation
	#/usr/bin/dsymutil $(DSTBASE)/CoreFoundation.framework/Versions/A/CoreFoundation -o $(DSTBASE)/CoreFoundation.framework.dSYM
	/usr/sbin/chown -RH -f root:wheel $(DSTBASE)/CoreFoundation.framework
	/bin/chmod -RH a-w,a+rX $(DSTBASE)/CoreFoundation.framework
	/bin/chmod -RH u+w $(DSTBASE)
	#install_name_tool -id /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation $(DSTBASE)/CoreFoundation.framework/Versions/A/CoreFoundation
	@echo "Installing done.  The framework is in $(DSTBASE)"

