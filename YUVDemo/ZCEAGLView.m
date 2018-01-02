//
//  ZCEAGLView.m
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import "ZCEAGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "ZCScene.h"
#import "error.h"

@interface ZCEAGLView () {
    GLuint program;
    GLuint colorRenderBuffer;
    GLuint depthRenderBuffer;
}

@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ZCEAGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.context) {
        [self glChange];
    }
}

- (void)setupLayer
{
    _glLayer = (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
}

- (void)setupContext
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    
    
    // Add to end of setupFrameBuffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
}

// Add new method right after setupRenderBuffer
- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void)setupDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.paused = NO;
}

- (void)setupGL
{
    [self setupLayer];
    [self setupContext];
    
    [self setupDepthBuffer];
    
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    
    program = [self createProgram];
    
    if (self.scene) {
        if (!self.scene.hasInit) {
            self.scene->program = program;
        }
    }
    [self glCreate];
    [self glChange];
    
    [self setupDisplayLink];
}

- (void)glCreate
{
    if (self.scene) {
        [self.scene sceneDidCreate];
    }
}

- (void)glChange
{
    if (program > 0) {
        glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
        if (self.scene) {
            [self.scene sceneDidChangeSize:self.bounds.size];
        }
    }
}

- (void)drawFrame:(CADisplayLink *)displayLink
{
    if (self.scene) {
        [self.scene drawFrame];
    }
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (GLuint)createProgram
{
    
    GLuint vertexShader = [self loadShaderOfType:GL_VERTEX_SHADER file:[[NSBundle mainBundle] pathForResource:self.vertexShaderFileName ofType:@"glsl"]];
    GLuint pixelShader = [self loadShaderOfType:GL_FRAGMENT_SHADER file:[[NSBundle mainBundle] pathForResource:self.fragmentShaderFileName ofType:@"glsl"]];
    
    GLuint prog = glCreateProgram();
    if (prog != 0) {
        glAttachShader(prog, vertexShader);
        GetError();
        glAttachShader(prog, pixelShader);
        GetError();
        glLinkProgram(prog);
        
        GLint linkStatus;
        glGetProgramiv(prog, GL_LINK_STATUS, &linkStatus);
        if (linkStatus != GL_TRUE) {
            glDeleteProgram(prog);
            prog = 0;
        }
    }
    return prog;
}

- (GLuint)loadShaderOfType:(GLenum)type file:(NSString *)file
{
    GLuint shader = glCreateShader(type);
    if (shader != 0) {
        const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                                    encoding:NSASCIIStringEncoding
                                                                       error:nil] cStringUsingEncoding:NSASCIIStringEncoding];
        glShaderSource(shader, 1, &source, NULL);
        glCompileShader(shader);
        
        GLint status;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
        GetError();
        
        if (status == 0) {
            glDeleteShader(shader);
            shader = 0;
        }
    }
    return shader;
}

- (GLuint)compileShaderOfType:(GLenum)type file:(NSString *)file
{
    GLuint shader;
    const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                                encoding:NSASCIIStringEncoding
                                                                   error:nil] cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (nil == source)
    {
        [NSException raise:kFailedToInitialiseGLException
                    format:@"Failed to read shader file %@", file];
    }
    
    shader = glCreateShader(type);
    GetError();
    
    glShaderSource(shader, 1, &source, NULL);
    GetError();
    
    glCompileShader(shader);
    GetError();
    
#ifdef DEBUG
    GLint logLength;
    
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    GetError();
    
    if (logLength > 0)
    {
        GLchar *log = malloc((size_t)logLength);
        glGetShaderInfoLog(shader, logLength, &logLength, log);
        GetError();
        NSLog(@"Shader compilation failed with error:\n%s", log);
        free(log);
    }
    
#endif
    
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    GetError();
    
    if (0 == status)
    {
        glDeleteShader(shader);
        GetError();
        [NSException raise:kFailedToInitialiseGLException
                    format:@"Shader compilation failed for file %@", file];
    }
    
    return shader;
}

@end
