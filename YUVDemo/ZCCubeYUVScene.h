//
//  ZCCubeYUVScene.h
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import "ZCScene.h"

@interface ZCCubeYUVScene : ZCScene

@property (nonatomic, assign) CGSize size;

- (void)updateWithData:(NSData *)data;
- (void)nextVideoFrame;

@end
