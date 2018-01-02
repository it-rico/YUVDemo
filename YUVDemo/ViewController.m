//
//  ViewController.m
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/24.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import "ViewController.h"
#import "ZCEAGLView.h"
#import "ZCCubeYUVScene.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet ZCEAGLView *glView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ZCCubeYUVScene *scene;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZCCubeYUVScene *scene = [ZCCubeYUVScene scene];
    self.glView.vertexShaderFileName = @"cube_yuv_vertex_shader";
    self.glView.fragmentShaderFileName = @"cube_yuv_fragment_shader";
    self.scene = scene;
    
    self.glView.scene = scene;
    
    [self.glView setupGL];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"coastguard_qcif" ofType:@"yuv"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    scene.size = CGSizeMake(176, 144);
    [scene updateWithData:data];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.042 target:self selector:@selector(videoFrame) userInfo:nil repeats:YES];
    
}

- (void)videoFrame
{
    [self.scene nextVideoFrame];
}

@end
