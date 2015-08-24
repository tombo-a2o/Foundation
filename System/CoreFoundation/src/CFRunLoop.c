#include <CoreFoundation/CFRunLoop.h>
#include <dispatch/dispatch.h>

extern void *_NS_RUNLOOP_KEY;

CFRunLoopRef CFRunLoopGetMain(void) {
    return dispatch_queue_get_specific(dispatch_get_main_queue(), _NS_RUNLOOP_KEY);
}
