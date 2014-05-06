//
//  UIColor+KTColorUtils.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/5/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KTColorUtils)

/**
 *  Returns a boolean to indicate whether the color is a light or dark color
 *  Implementation from http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
 *
 *  @return BOOL
 */
- (BOOL)isLightColor;

@end
