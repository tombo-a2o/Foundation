#include <CoreFoundation/CFRunLoop.h>
#include "CFInternal.h"
#include <dispatch/dispatch.h>

CONST_STRING_DECL(kCFRunLoopDefaultMode, "kCFRunLoopDefaultMode")
CONST_STRING_DECL(kCFRunLoopCommonModes, "kCFRunLoopCommonModes")

extern void *_NS_RUNLOOP_KEY;

CFRunLoopRef CFRunLoopGetMain(void) {
    return dispatch_queue_get_specific(dispatch_get_main_queue(), _NS_RUNLOOP_KEY);
}
