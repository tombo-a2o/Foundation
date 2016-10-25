#include <CoreFoundation/CFRunLoop.h>
#include <CoreFoundation/CFString.h>
#include "CFInternal.h"
#include <dispatch/dispatch.h>

CONST_STRING_DECL(kCFRunLoopDefaultMode, "kCFRunLoopDefaultMode")
CONST_STRING_DECL(kCFRunLoopCommonModes, "kCFRunLoopCommonModes")

extern void *_NS_RUNLOOP_KEY;

CFRunLoopRef CFRunLoopGetMain(void) {
    return dispatch_queue_get_specific(dispatch_get_main_queue(), _NS_RUNLOOP_KEY);
}

void CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef mode)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
void CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
Boolean CFRunLoopContainsSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return false;
}
CFStringRef CFRunLoopCopyCurrentMode(CFRunLoopRef rl)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return NULL;
}
CFRunLoopRef CFRunLoopGetCurrent(void)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return NULL;
}
Boolean CFRunLoopIsWaiting(CFRunLoopRef rl)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return false;
}
CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return NULL;
}
void CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
void CFRunLoopRun(void)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
SInt32 CFRunLoopRunInMode(CFStringRef mode, CFTimeInterval seconds, Boolean returnAfterSourceHandled)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return 0;
}
CFRunLoopSourceRef CFRunLoopSourceCreate(CFAllocatorRef allocator, CFIndex order, CFRunLoopSourceContext *context)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
    return NULL;
}
void CFRunLoopSourceInvalidate(CFRunLoopSourceRef source)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
void CFRunLoopSourceSignal(CFRunLoopSourceRef source)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
void CFRunLoopWakeUp(CFRunLoopRef rl)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
void CFRunLoopStop(CFRunLoopRef rl)
{
    CFLog(kCFLogLevelWarning, CFSTR("*** %s is not implemented."), __PRETTY_FUNCTION__);
}
