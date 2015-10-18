#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <emscripten/html5.h>

@implementation EAGLSharegroup
@end


@interface EAGLContext()
@property(readonly) EMSCRIPTEN_WEBGL_CONTEXT_HANDLE webglContext;
@end

@implementation EAGLContext {
    EMSCRIPTEN_WEBGL_CONTEXT_HANDLE _webglContext;
}


static EAGLContext *_currentContext = nil;

+(EAGLContext*) currentContext {
    EMSCRIPTEN_WEBGL_CONTEXT_HANDLE webglContext = emscripten_webgl_get_current_context();
    if(_currentContext == NULL) {
        assert(webglContext==0);
    } else {
        assert(_currentContext.webglContext == webglContext);
    }
    return _currentContext;
}

+(BOOL)setCurrentContext:(EAGLContext *)context {
    _currentContext = context;
    return emscripten_webgl_make_context_current(context.webglContext) == EMSCRIPTEN_RESULT_SUCCESS;
} 

-(instancetype)initWithAPI:(EAGLRenderingAPI)api {
  return [self initWithAPI:api sharegroup:[[EAGLSharegroup alloc] init]];
}

-(instancetype)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup {
    self = [super init];
    _API = api;
    _sharegroup = sharegroup;

    EmscriptenWebGLContextAttributes attr;
    emscripten_webgl_init_context_attributes(&attr);
    attr.enableExtensionsByDefault = 1;
    _webglContext = emscripten_webgl_create_context(0, &attr);
    emscripten_webgl_make_context_current(_webglContext);

    return self;
}

-(BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable {
    NSAssert(0, @"not implemented");
    return NO;
}

-(BOOL)presentRenderbuffer:(NSUInteger)target {
    NSAssert(0, @"not implemented");
    return NO;
}
@end
