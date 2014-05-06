//
//  KTNumberUtil.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/1/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTNumberUtil : NSObject

+ (float)remapNumbersToRange:(float)inputNumber fromMin:(float)fromMin fromMax:(float)fromMax toMin:(float)toMin toMax:(float)toMax;

@end
