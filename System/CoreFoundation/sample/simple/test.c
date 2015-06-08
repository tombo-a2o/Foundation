#include <CoreFoundation/CoreFoundation.h>

int main()
{
	CFStringRef hello = CFSTR("Hello, world.");
	printf("%ld\n",CFStringGetLength(hello));
	puts(CFStringGetCStringPtr(hello, kCFStringEncodingUTF8));
}
