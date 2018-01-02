//
//  ZCScene.m
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import "ZCScene.h"

@implementation ZCScene

+ (instancetype)scene
{
    ZCScene *scene = [[self alloc] init];
    return scene;
}

- (BOOL)hasInit
{
    return program > 0;
}

- (void)sceneDidCreate
{
    
}

- (void)sceneDidChangeSize:(CGSize)size
{
    
}

@end
