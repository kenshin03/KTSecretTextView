//
//  UIColor+KTColorUtils.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/5/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "UIColor+KTColorUtils.h"

@implementation UIColor (KTColorUtils)

- (BOOL)isLightColor;
{
    BOOL isLight = NO;
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.6) {
        isLight = NO;
    }else {
        isLight = YES;
    }
    return isLight;
}


@end
