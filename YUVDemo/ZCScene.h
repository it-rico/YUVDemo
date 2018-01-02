//
//  ZCScene.h
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <OpenGLES/ES2/gl.h>
#import "error.h"

@interface ZCScene : NSObject {
@public
    GLuint program;
}

@property (nonatomic, assign, readonly) BOOL hasInit;

+ (instancetype)scene;

- (void)sceneDidCreate;
- (void)sceneDidChangeSize:(CGSize)size;
- (void)drawFrame;

@end
