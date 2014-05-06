//
//  KTNumberUtil.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/1/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTNumberUtil.h"

@implementation KTNumberUtil


+ (float)remapNumbersToRange:(float)inputNumber fromMin:(float)fromMin fromMax:(float)fromMax toMin:(float)toMin toMax:(float)toMax {
    return (inputNumber - fromMin) / (fromMax - fromMin) * (toMax - toMin) + toMin;
}

@end
