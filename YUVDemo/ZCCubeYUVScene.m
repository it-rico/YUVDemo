//
//  ZCCubeYUVScene.m
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import "ZCCubeYUVScene.h"
#import <GLKit/GLKit.h>

static const GLfloat squareVertices[] = {
    -1.0f, -1.0f, 1.0f,         //前左下
    1.0f, -1.0f, 1.0f,          //前右下
    -1.0f, 1.0f, 1.0f,          //前左上
    1.0f, -1.0f, 1.0f,          //前右下
    -1.0f, 1.0f, 1.0f,          //前左上
    1.0f, 1.0f, 1.0f,           //前右上
    
    1.0f, -1.0f, -1.0f,         //后左下
    -1.0f, -1.0f, -1.0f,        //后右下
    1.0f, 1.0f, -1.0f,          //后左上
    -1.0f, -1.0f, -1.0f,        //后右下
    1.0f, 1.0f, -1.0f,          //后左上
    -1.0f, 1.0f, -1.0f,         //后右上
    
    -1.0f, -1.0f, -1.0f,        //左左下
    -1.0f, -1.0f, 1.0f,         //左右下
    -1.0f, 1.0f, -1.0f,         //左左上
    -1.0f, -1.0f, 1.0f,         //左右下
    -1.0f, 1.0f, -1.0f,         //左左上
    -1.0f, 1.0f, 1.0f,          //左右上
    
    1.0f, -1.0f, 1.0f,          //右左下
    1.0f, -1.0f, -1.0f,         //右右下
    1.0f, 1.0f, 1.0f,           //右左上
    1.0f, -1.0f, -1.0f,         //右右下
    1.0f, 1.0f, 1.0f,           //右左上
    1.0f, 1.0f, -1.0f,          //右右上
    
    -1.0f, 1.0f, 1.0f,          //上左下
    1.0f, 1.0f, 1.0f,           //上右下
    -1.0f, 1.0f, -1.0f,         //上左上
    1.0f, 1.0f, 1.0f,           //上右下
    -1.0f, 1.0f, -1.0f,         //上左上
    1.0f, 1.0f, -1.0f,          //上右上
    
    -1.0f, -1.0f, -1.0f,         //前左下
    1.0f, -1.0f, -1.0f,          //前右下
    -1.0f, -1.0f, 1.0f,          //前左上
    1.0f, -1.0f, -1.0f,          //前右下
    -1.0f, -1.0f, 1.0f,          //前左上
    1.0f, -1.0f, 1.0f,           //前右上
};

static const GLfloat coordVertices[] = {
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
    
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
    
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
    
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
    
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
    
    0.0f, 1.0f,             //左下
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 1.0f,             //右下
    0.0f, 0.0f,             //左上
    1.0f, 0.0f,             //右上
};

@interface ZCCubeYUVScene () {
    BOOL isProgBuild;
    
    BOOL sizeChanged;
    
    GLuint positionHandle;
    GLuint coordHandle;
    GLuint yHandle;
    GLuint uHandle;
    GLuint vHandle;
    GLuint yTid, uTid, vTid;
    
    GLKMatrix4 viewMatrix;
    GLKMatrix4 projectMatrix;
    GLKMatrix4 matrix;
    GLKMatrix4 tmpMatrix;
    GLuint matrixHandler;
    
    const void *yData;
    const void *uData;
    const void *vData;
    
    float degree1, degree2;
}

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ZCCubeYUVScene

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)buildProgram
{
    positionHandle = glGetAttribLocation(program, "vPosition");
    GetError();
    coordHandle = glGetAttribLocation(program, "a_texCoord");
    GetError();
    yHandle = glGetUniformLocation(program, "tex_y");
    GetError();
    uHandle = glGetUniformLocation(program, "tex_u");
    GetError();
    vHandle = glGetUniformLocation(program, "tex_v");
    GetError();
    matrixHandler = glGetUniformLocation(program, "vMatrix");
    GetError();
    
    yTid = 0xffff;
    uTid = 0xffff;
    vTid = 0xffff;
    
    isProgBuild = YES;
}

- (void)buildTextures
{
    BOOL changed = sizeChanged;
    sizeChanged = NO;
    
    [self.lock lock];
    
    if (yTid == 0xffff || changed) {
        if (yTid != 0xffff) {
            glDeleteTextures(1, &yTid);
        }
        glGenTextures(1, &yTid);
        GetError();
    }
    
    glBindTexture(GL_TEXTURE_2D, yTid);
    GetError();
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, self.size.width, self.size.height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, yData);
    GetError();
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    if (uTid == 0xffff || changed) {
        if (uTid != 0xffff) {
            glDeleteTextures(1, &uTid);
        }
        glGenTextures(1, &uTid);
        GetError();
    }
    
    glBindTexture(GL_TEXTURE_2D, uTid);
    GetError();
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, self.size.width / 2, self.size.height / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, uData);
    GetError();
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    if (vTid == 0xffff || changed) {
        if (vTid != 0xffff) {
            glDeleteTextures(1, &vTid);
        }
        glGenTextures(1, &vTid);
        GetError();
    }
    
    
    glBindTexture(GL_TEXTURE_2D, vTid);
    GetError();
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, self.size.width / 2, self.size.height / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, vData);
    GetError();
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    [self.lock unlock];
}

- (void)sceneDidCreate
{
    [super sceneDidCreate];
    
    if (!isProgBuild) {
        [self buildProgram];
    }
    
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
}

- (void)sceneDidChangeSize:(CGSize)size
{
    [super sceneDidChangeSize:size];
    
    float ratio = size.width / size.height;
    
    projectMatrix = GLKMatrix4MakeFrustum(-ratio, ratio, -1, 1, 3, 20);
    viewMatrix = GLKMatrix4MakeLookAt(0, 0, 10.0f, 0, 0, 0, 0, 1.0f, 0);
    matrix = GLKMatrix4Multiply(projectMatrix, viewMatrix);
}

- (void)drawFrame
{
    [self buildTextures];
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self p_drawFrame];
}

- (void)p_drawFrame
{
    glUseProgram(program);
    
    tmpMatrix = matrix;
    float x, y, z;
    x = sinf(degree1 * M_PI / 180);
    y = 2;
    z = cosf(degree1 * M_PI / 180);
    degree1 += 0.2;
    tmpMatrix = GLKMatrix4Rotate(tmpMatrix, degree2 * M_PI / 180, x, y, z);
    degree2 += 1;
    
    glUniformMatrix4fv(matrixHandler, 1, GL_FALSE, tmpMatrix.m);
    
    glVertexAttribPointer(positionHandle, 3, GL_FLOAT, GL_FALSE, 0, squareVertices);
    GetError();
    glEnableVertexAttribArray(positionHandle);
    
    glVertexAttribPointer(coordHandle, 2, GL_FLOAT, GL_FALSE, 0, coordVertices);
    GetError();
    glEnableVertexAttribArray(coordHandle);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, yTid);
    glUniform1i(yHandle, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, uTid);
    glUniform1i(uHandle, 1);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, vTid);
    glUniform1i(vHandle, 2);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    glFinish();
    
    glDisableVertexAttribArray(positionHandle);
    glDisableVertexAttribArray(coordHandle);
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        sizeChanged = YES;
        _size = size;
    }
}

- (void)updateWithData:(NSData *)data
{
    [self.lock lock];
    
    self.data = data;
    NSInteger length = self.size.width * self.size.height;
    yData = self.data.bytes;
    uData = yData + length;
    vData = uData + length / 4;
    
    [self.lock unlock];
}

- (void)nextVideoFrame
{
    [self.lock lock];
    
    NSInteger frameLength = self.size.width * self.size.height * 3 / 2;
    NSInteger length = self.size.width * self.size.height;
    yData = yData + frameLength;
    if (yData >= self.data.bytes + self.data.length) {
        yData = self.data.bytes;
    }
    uData = yData + length;
    vData = uData + length / 4;
    
    [self.lock unlock];
}

@end
