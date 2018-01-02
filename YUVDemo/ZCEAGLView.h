//
//  ZCEAGLView.h
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFailedToInitialiseGLException @"Failed to initialise OpenGL"

@class ZCScene;
@interface ZCEAGLView : UIView

@property (nonatomic, strong) ZCScene *scene;
@property (nonatomic, strong) NSString *vertexShaderFileName;
@property (nonatomic, strong) NSString *fragmentShaderFileName;

- (void)setupGL;

@end
