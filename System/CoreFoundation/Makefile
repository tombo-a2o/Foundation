include ../Makefile.template

CC				= emcc
CFLAGS			= -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I./src -I./include -I./private_include -I../CFNetwork/include -I../CoreGraphics/include -I../Security/include -DVERSION=$(VERSION) -include CoreFoundation_Prefix.h -include ../global.pch -include ../debug.pch -include ../Fixme.pch -DDEBUG=1

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

CSOURCES		= $(addprefix src/, CFApplicationPreferences.c CFArray.c CFAttributedString.c CFBag.c CFBase.c CFBasicHash.c CFBigNumber.c CFBinaryHeap.c CFBinaryPList.c CFBitVector.c CFBuiltinConverters.c CFBundle.c CFBundle_InfoPlist.c CFBundle_Resources.c CFBurstTrie.c CFCalendar.c CFCalendarConstants.c CFCharacterSet.c CFConcreteStreams.c CFData.c CFDate.c CFDateFormatter.c CFDictionary.c CFError.c CFFileUtilities.c CFICUConverters.c CFLocale.c CFLocaleIdentifier.c CFLocaleKeys.c CFNumber.c CFNumberFormatter.c CFOldStylePList.c CFPlatform.c CFPlatformConverters.c CFPreferences.c CFPropertyList.c CFRuntime.c CFRunLoop.c CFSet.c CFSocket.c CFSocketStream.c CFSortFunctions.c CFStorage.c CFStream.c CFString.c CFStringEncodingConverter.c CFStringEncodingDatabase.c CFStringEncodings.c CFStringScanner.c CFStringTokenizer.c CFStringUtilities.c CFSystemDirectories.c CFTimeZone.c CFTree.c CFURL.c CFURLAccess.c CFUUID.c CFUniChar.c CFUnicodeDecomposition.c CFUnicodePrecomposition.c CFUtilities.c CFVersion.c CFWindowsUtilities.c CFXMLInputStream.c CFXMLNode.c CFXMLParser.c CFXMLPreferencesDomain.c CFXMLTree.c CFNotificationCenter.c)
MSOURCES		= $(addprefix src/, CFStubs.m NSArray.m NSAttributedString.m NSBlock.m NSCFType.m NSCache.m NSCalendar.m NSCharacterSet.m NSConstantString.m NSData.m NSDate.m NSDateComponents.m NSDictionary.m NSEnumerator.m NSError.m NSException.m NSFastEnumerationEnumerator.m NSGenericDeallocHandler.m NSInputStream.m NSInvocation.m NSLocale.m NSMessageBuilder.m NSMethodSignature.m NSNull.m NSNumber.m NSObjCRuntime.m NSObject.m NSOrderedSet.m NSOutputStream.m NSPropertyList.m NSSet.m NSSharedKeyDictionary.m NSSharedKeySet.m NSStream.m NSString.m NSTimeZone.m NSTimer.m NSURL.m NSZombie.m)

SOURCES			= $(CSOURCES) $(MSOURCES)
PUBLIC_HEADERS	= $(wildcard include/**/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/**/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CoreFoundation, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
