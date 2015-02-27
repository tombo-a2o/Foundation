#import <Foundation/Foundation.h>

int main(void)
{
	NSString *fmt = [NSString stringWithFormat:@"My formatted string: %@", @"hoge"];

	printf("%s", [fmt cStringUsingEncoding:[NSString defaultCStringEncoding]]);

	return 0;
}
