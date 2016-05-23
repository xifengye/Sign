//
//  UIImage+MG.h
//  SinaWeibo
//
//  Created by yexifeng on 15/11/10.
//  Copyright (c) 2015年 moregood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MG)
+(UIImage*) imageWithStretchable:(NSString*)imageName;
+(UIImage*) imageWithStretchable:(NSString*)imageName leftCapWidth:(CGFloat)left topCapHeight:(CGFloat)top;
+ (UIImage *)createImageWithColor:(UIColor *)color;
@end
