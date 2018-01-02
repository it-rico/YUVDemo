//
//  AppDelegate.h
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/24.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

