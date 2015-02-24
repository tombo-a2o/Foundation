#include <CoreFoundation/CoreFoundation.h>

#undef dispatch_once
void dispatch_once(dispatch_once_t *predicate, dispatch_block_t block) {
	if(*predicate != ~0l) {
		*predicate = ~0l;
		block();
	}
}

int main()
{
	CFStringRef hello = CFSTR("Hello, world.");
	printf("%ld\n",CFStringGetLength(hello));
	puts(CFStringGetCStringPtr(hello, kCFStringEncodingUTF8));
}
