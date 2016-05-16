include ../Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -I./src -I./include -I./private_include -I./include/CFNetwork -I./private_include/CFNetwork -I./src/Headers -I./src/Utils -I./src/SharedCode -I./src/Proxies -I./src/HTTP -DVERSION=$(VERSION) -include ../global.pch -include ../debug.pch -include ../Fixme.pch -include ../CoreFoundation/src/CoreFoundation_Prefix.h -s USE_ZLIB=1
CFLAGS = -x objective-c -std=gnu99
STYLE_LFLAGS ?= -O0
LFLAGS =

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES = $(addprefix src/, \
    CFNetwork.c \
    HTTP/CFHTTPAuthentication.c \
    HTTP/CFHTTPConnection.c \
    HTTP/CFHTTPFilter.c \
    HTTP/CFHTTPMessage.c \
    HTTP/CFHTTPStream.c \
    Proxies/ProxySupport.c \
    SharedCode/CFNetConnection.c \
    SharedCode/CFNetworkSchedule.c \
    SharedCode/CFNetworkThreadSupport.c \
    SharedCode/CFError.c \
    URL/CFURLAuthChallenge.c \
    URL/CFURLConnection.c \
    URL/CFURLRequest.c \
    URL/CFURLResponse.c \
    URL/_CFURLAccess.c \
    URL/CFURLCache.c \
    URL/CFCachedURLResponse.c \
    CFProxySupport.c \
    Cookies/CFHTTPCookie.c \
    Cookies/CFHTTPCookieStorage.c \
    Stream/CFSocketStream.c \
    Utils/CFFSUtils.c \
    Utils/CFRuntimeUtils.c \
    Utils/CFHTTPUtils.c \
)
PUBLIC_HEADERS	= $(wildcard include/**/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/**/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CFNetwork, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
