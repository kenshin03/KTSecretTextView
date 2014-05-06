//
//  KTImageUtil.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/5/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AssetsLibrary;

/**
 *  Util class for resizing image effectively. Method implementation taken from
 *  http://mindsea.com/2012/12/18/downscaling-huge-alassets-without-fear-of-sigkill
 */

@interface KTImageUtil : NSObject

+ (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;
+ (UIImage*) cropImage:(UIImage*)image toRect:(CGRect)rect;

@end
