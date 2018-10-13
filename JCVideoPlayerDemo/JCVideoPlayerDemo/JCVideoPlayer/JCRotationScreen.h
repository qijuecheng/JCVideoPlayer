//
//  JCRotationScreen.h
//  播放器Demo
//
//  Created by 漆珏成 on 2018/8/17.
//  Copyright © 2018年 漆珏成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCRotationScreen : NSObject


/**
 切换横竖屏

 @param orientation UIInterfaceOrientation
 */
+ (void)rotationScreenOrientation:(UIInterfaceOrientation)orientation;

/**
 是否是横屏

 @return 是 返回YES
 */
+ (BOOL)isOrientatioinLandscape;
@end
