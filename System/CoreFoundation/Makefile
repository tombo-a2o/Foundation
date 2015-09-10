
MIN_MACOSX_VERSION=10.9
MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9

SOURCES = CFApplicationPreferences.c CFArray.c CFAttributedString.c CFBag.c CFBase.c CFBasicHash.c CFBigNumber.c CFBinaryHeap.c CFBinaryPList.c CFBitVector.c CFBuiltinConverters.c CFBundle.c CFBundle_InfoPlist.c CFBundle_Resources.c CFBurstTrie.c CFCalendar.c CFCalendarConstants.c CFCharacterSet.c CFConcreteStreams.c CFData.c CFDate.c CFDateFormatter.c CFDictionary.c CFError.c CFFileUtilities.c CFICUConverters.c CFLocale.c CFLocaleIdentifier.c CFLocaleKeys.c CFNumber.c CFNumberFormatter.c CFOldStylePList.c CFPlatform.c CFPlatformConverters.c CFPreferences.c CFPropertyList.c CFRuntime.c CFRunLoop.c CFSet.c CFSocket.c CFSocketStream.c CFSortFunctions.c CFStorage.c CFStream.c CFString.c CFStringEncodingConverter.c CFStringEncodingDatabase.c CFStringEncodings.c CFStringScanner.c CFStringTokenizer.c CFStringUtilities.c CFSystemDirectories.c CFTimeZone.c CFTree.c CFURL.c CFURLAccess.c CFUUID.c CFUniChar.c CFUnicodeDecomposition.c CFUnicodePrecomposition.c CFUtilities.c CFVersion.c CFWindowsUtilities.c CFXMLInputStream.c CFXMLNode.c CFXMLParser.c CFXMLPreferencesDomain.c CFXMLTree.c CFNotificationCenter.c
MSOURCES = CFStubs.m NSArray.m NSAttributedString.m NSBlock.m NSCFType.m NSCache.m NSCalendar.m NSCharacterSet.m NSConstantString.m NSData.m NSDate.m NSDateComponents.m NSDictionary.m NSEnumerator.m NSError.m NSException.m NSFastEnumerationEnumerator.m NSGenericDeallocHandler.m NSInputStream.m NSInvocation.m NSLocale.m NSMessageBuilder.m NSMethodSignature.m NSNull.m NSNumber.m NSObjCRuntime.m NSObject.m NSOrderedSet.m NSOutputStream.m NSPropertyList.m NSSet.m NSSharedKeyDictionary.m NSSharedKeySet.m NSStream.m NSString.m NSTimeZone.m NSTimer.m NSURL.m NSZombie.m
OBJECTS = $(patsubst %.c,%.o,$(SOURCES)) $(patsubst %.m,%.o,$(MSOURCES))
HFILES = $(wildcard include/**/*.h) $(wildcard private_include/**/*.h)

OBJBASE_ROOT = build
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(if $(DSTROOT),$(DSTROOT),$(EMSCRIPTEN)/system/frameworks)

STYLE=normal
STYLE_CFLAGS=-O0
STYLE_LFLAGS=
INSTALLNAME=/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation_$(STYLE)

CC = emcc

CFLAGS=-c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I./src -I./include -I./private_include -I../CFNetwork/include -I../CoreGraphics/include -I../Security/include -DVERSION=$(VERSION) -include CoreFoundation_Prefix.h -include ../global.pch -include ../debug.pch -include ../Fixme.pch

.PHONY: all install clean
.PRECIOUS: $(OBJBASE)/CoreFoundation/%.h

all: $(OBJBASE)/CoreFoundation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE_ROOT)

$(OBJBASE)/CoreFoundation:
	/bin/mkdir -p $(OBJBASE)/CoreFoundation

$(OBJBASE)/%.o: src/%.c $(HFILES) $(OBJBASE)/CoreFoundation
	$(CC) $(STYLE_CFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/%.o: src/%.m $(HFILES) $(OBJBASE)/CoreFoundation
	$(CC) $(STYLE_CFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/CoreFoundation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreFoundation_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreFoundation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreFoundation_$(STYLE) $(OBJBASE)/CoreFoundation_$(STYLE).bc

install-header:
	/bin/rm -rf $(DSTBASE)/CoreFoundation.framework
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreFoundation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreFoundation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreFoundation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreFoundation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreFoundation $(DSTBASE)/CoreFoundation.framework/CoreFoundation
	/bin/cp include/CoreFoundation/*.h $(DSTBASE)/CoreFoundation.framework/Versions/A/Headers
	/bin/cp private_include/CoreFoundation/*.h $(DSTBASE)/CoreFoundation.framework/Versions/A/PrivateHeaders

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
	/bin/cp resource/Info.plist $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreFoundation.framework/Versions/A/Resources/en.lproj
	/bin/cp include/CoreFoundation/*.h $(DSTBASE)/CoreFoundation.framework/Versions/A/Headers
	/bin/cp private_include/CoreFoundation/*.h $(DSTBASE)/CoreFoundation.framework/Versions/A/PrivateHeaders
	/bin/cp $(OBJBASE)/CoreFoundation_$(STYLE) $(DSTBASE)/CoreFoundation.framework/Versions/A/CoreFoundation
	@echo "Installing done.  The framework is in $(DSTBASE)"

