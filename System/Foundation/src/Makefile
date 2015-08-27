
MIN_MACOSX_VERSION=10.9
MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9

SOURCES = NSAddressCheckingResult.m NSAggregateExpression.m NSAnyKeyExpression.m NSArchiver.m NSArray.m NSAttributedString.m NSAutoreleasePool.m NSBOMEncoding.m NSBetweenPredicateOperator.m NSBlockExpression.m NSBlockPredicate.m NSBundle.m NSByteCountFormatter.m NSCalendar.m NSCoder.m NSComparisonPredicate.m NSComparisonPredicateOperator.m NSCompoundPredicate.m NSCompoundPredicateOperator.m NSConstantValueExpression.m NSCustomPredicateOperator.m NSData.m NSDataDetector.m NSDate.m NSDateCheckingResult.m NSDateFormatter.m NSDecimal.m NSDecimalNumber.m NSDictionary.m NSDirectoryEnumerator.m NSEqualityPredicateOperator.m NSException.m NSExpression.m NSExternals.m NSFalsePredicate.m NSFileAttributes.m NSFileCoordinator.m NSFileHandle.m NSFileManager.m NSFilesystemItemRemoveOperation.m NSFormatter.m NSFunctionExpression.m NSGrammarCheckingResult.m NSHTTPCookie.m NSHTTPCookieStorage.m NSHashTable.m NSInPredicateOperator.m NSIndexPath.m NSIndexSet.m NSJSONSerialization.m NSKeyPathExpression.m NSKeyPathSpecifierExpression.m NSKeyValueAccessor.m NSKeyValueChangeDictionary.m NSKeyValueCoding.m NSKeyValueCodingInternal.m NSKeyValueCollectionProxies.m NSKeyValueComputedProperty.m NSKeyValueContainerClass.m NSKeyValueNestedProperty.m NSKeyValueObservance.m NSKeyValueObservationInfo.m NSKeyValueObserving.m NSKeyValueProperty.m NSKeyValueUnnestedProperty.m NSKeyedArchiver.m NSKeyedUnarchiver.m NSLikePredicateOperator.m NSLinkCheckingResult.m NSLocale.m NSLocalizableString.m NSLock.m NSLog.m NSMapTable.m NSMatchingPredicateOperator.m NSNestedDictionary.m NSNetServices.m NSNotification.m NSNotificationCenter.m NSNotificationQueue.m NSNumber.m NSNumberFormatter.m NSObjCRuntime.m NSOperation.m NSOrthographyCheckingResult.m NSPathStore.m NSPathUtilities.m NSPhoneNumberCheckingResult.m NSPlatform.m NSPointerArray.m NSPointerFunctions.m NSPort.m NSPredicate.m NSPredicateLexer.m NSPredicateOperator.m NSProcessInfo.m NSProgress.m NSProxy.m NSRange.m NSRegularExpression.m NSRegularExpressionCheckingResult.m NSRunLoop.m NSRunLoopModes.m NSScanner.m NSSelfExpression.m NSSet.m NSSetExpression.m NSSortDescriptor.m NSSpellCheckingResult.m NSString.m NSStringPredicateOperator.m NSSubqueryExpression.m NSSubstitutionCheckingResult.m NSSubstringPredicateOperator.m NSSymbolicExpression.m NSTernaryExpression.m NSTextCheckingResult.m NSThread.m NSTimeZone.m NSTimer.m NSTokenMatchingPredicateOperator.m NSTransitInformationCheckingResult.m NSTruePredicate.m NSURL.m NSURLAuthenticationChallenge.m NSURLCache.m NSURLConnection.m NSURLCredential.m NSURLCredentialStorage.m NSURLError.m NSURLProtectionSpace.m NSURLProtocol.m NSURLRequest.m NSURLResponse.m NSUUID.m NSUbiquitousKeyValueStore.m NSUserDefaults.m NSValue.m NSValueTransformer.m NSVariableAssignmentExpression.m NSVariableExpression.m NSXMLParser.m NSXPCCoder.m NSZone.m _NSFileIO.m _NSKeyedCoderOldStyleArray.m _NSPredicateOperatorUtilities.m _NSPredicateUtilities.m _DebugUtils.m NSObjectInternal.m
OBJECTS = $(patsubst %.m,%.o,$(SOURCES)) NSPredicateParser.tab.o
HFILES = $(wildcard *.h)
INTERMEDIATE_HFILES = $(addprefix $(OBJBASE)/Foundation/,$(HFILES))

PUBLIC_HEADERS=

PRIVATE_HEADERS=

MACHINE_TYPE := $(shell uname -p)
unicode_data_file_name = $(if $(or $(findstring i386,$(1)),$(findstring i686,$(1)),$(findstring x86_64,$(1))),CFUnicodeData-L.mapping,CFUnicodeData-B.mapping)

OBJBASE_ROOT = NS-Objects
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(if $(DSTROOT),$(DSTROOT),$(EMSCRIPTEN)/system/frameworks)

STYLE=normal
STYLE_CFLAGS=-O0
STYLE_LFLAGS=
ARCHFLAGS=
INSTALLNAME=/System/Library/Frameworks/Foundation.framework/Versions/A/Foundation_$(STYLE)

CC = emcc

CFLAGS=-v -c -x objective-c -pipe -std=gnu99 -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DCF_BUILDING_CF=1 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DU_SHOW_DRAFT_API=1 -DU_SHOW_CPLUSPLUS_API=0 -I$(OBJBASE) -I../../CoreFoundation/include -I../../CoreFoundation/src -I../include -I../../CFNetwork/include -I../../CFNetwork/private_include -I../../Security/include -I./ -DVERSION=$(VERSION) -include CoreFoundation_Prefix.h -include ../../global.pch -include ../../debug.pch -include ../../Fixme.pch


#LFLAGS=-dynamiclib -mmacosx-version-min=$(MIN_MACOSX_VERSION) -twolevel_namespace -fexceptions -compatibility_version 150 -current_version $(VERSION) -Wl,-alias_list,SymbolAliases 


.PHONY: all install clean
.PRECIOUS: $(OBJBASE)/Foundation/%.h

all: $(OBJBASE)/Foundation_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE_ROOT)

$(OBJBASE)/Foundation:
	/bin/mkdir -p $(OBJBASE)/Foundation

$(OBJBASE)/Foundation/%.h: %.h $(OBJBASE)/Foundation
	/bin/cp $< $@

$(OBJBASE)/%.o: %.c $(INTERMEDIATE_HFILES)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/%.o: %.m $(INTERMEDIATE_HFILES)
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@

$(OBJBASE)/Foundation_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	#$(CC) $(STYLE_LFLAGS) -install_name $(INSTALLNAME) $(ARCHFLAGS) $(LFLAGS) $^ -licucore.A -o $(OBJBASE)/Foundation_$(STYLE)
	llvm-link -o $(OBJBASE)/Foundation_$(STYLE).bc $^
	rm -f $(OBJBASE)/Foundation_$(STYLE)
	llvm-ar rcs $(OBJBASE)/Foundation_$(STYLE) $(OBJBASE)/Foundation_$(STYLE).bc

NSPredicateLexer.m: NSPredicateLexer.lm
	lex -t NSPredicateLexer.lm > NSPredicateLexer.m

install: $(OBJBASE)/Foundation_$(STYLE)
	/bin/rm -rf $(DSTBASE)/Foundation.framework
	/bin/mkdir -p $(DSTBASE)/Foundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Foundation.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/Foundation.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/Foundation.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/Foundation.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/Foundation.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/Foundation.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/Foundation $(DSTBASE)/Foundation.framework/Foundation
	#/bin/cp Info.plist $(DSTBASE)/Foundation.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/Foundation.framework/Versions/A/Resources/en.lproj
	#/bin/cp $(PUBLIC_HEADERS) $(DSTBASE)/Foundation.framework/Versions/A/Headers
	#/bin/cp $(PRIVATE_HEADERS) $(DSTBASE)/Foundation.framework/Versions/A/PrivateHeaders
	/bin/cp -R ../include/Foundation/* $(DSTBASE)/Foundation.framework/Versions/A/Headers
	#/usr/bin/strip -S -o $(DSTBASE)/Foundation.framework/Versions/A/Foundation $(OBJBASE)/Foundation_$(STYLE)
	/bin/cp $(OBJBASE)/Foundation_$(STYLE) $(DSTBASE)/Foundation.framework/Versions/A/Foundation
	#/usr/bin/dsymutil $(DSTBASE)/Foundation.framework/Versions/A/Foundation -o $(DSTBASE)/Foundation.framework.dSYM
	#/usr/sbin/chown -RH -f root:wheel $(DSTBASE)/Foundation.framework
	#/bin/chmod -RH a-w,a+rX $(DSTBASE)/Foundation.framework
	#/bin/chmod -RH u+w $(DSTBASE)
	#install_name_tool -id /System/Library/Frameworks/Foundation.framework/Versions/A/Foundation $(DSTBASE)/Foundation.framework/Versions/A/Foundation
	@echo "Installing done.  The framework is in $(DSTBASE)"

