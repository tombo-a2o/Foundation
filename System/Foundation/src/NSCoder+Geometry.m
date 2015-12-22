//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <Foundation/Foundation.h>

@implementation NSCoder (NSKeyedGeometryCodingFromWinObjC)

static double x,y,width,height;

- (CGRect)decodeRectForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGRectZero;
    }
    
    if([obj isKindOfClass:[NSString class]]) {
        return NSRectFromString(obj);
    } else {
        CGRect rect;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&x, bytes+1, sizeof(double));
        memcpy(&y, bytes+9, sizeof(double));
        memcpy(&width, bytes+17, sizeof(double));
        memcpy(&height, bytes+25, sizeof(double));
        rect.origin.x = x;
        rect.origin.y = y;
        rect.size.width = width;
        rect.size.height = height;
        
        return rect;
    }
}

- (CGSize)decodeSizeForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGSizeZero;
    }
    
    if([obj isKindOfClass:[NSString class]]) {
        return NSSizeFromString(obj);
    } else {
        CGSize size;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&width, bytes+1, sizeof(double));
        memcpy(&height, bytes+9, sizeof(double));
        size.width = width;
        size.height = height;
        
        return size;
    }
}

- (CGPoint)decodePointForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGPointZero;
    }
    
    if([obj isKindOfClass:[NSString class]]) {
        return NSPointFromString(obj);
    } else {
        CGPoint point;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&x, bytes+1, sizeof(double));
        memcpy(&y, bytes+9, sizeof(double));
        point.x = x;
        point.y = y;
        
        return point;
    }
}

@end
