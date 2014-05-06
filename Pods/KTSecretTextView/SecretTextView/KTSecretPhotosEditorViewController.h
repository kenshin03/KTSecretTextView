//
//  KTSecretPhotosEditorViewController.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/1/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTSecretPhotosEditorViewControllerDelegate;


@interface KTSecretPhotosEditorViewController : UIViewController

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, readonly) UIImage *finalImage;
@property (nonatomic, weak) id<KTSecretPhotosEditorViewControllerDelegate> delegate;

@end


@protocol KTSecretPhotosEditorViewControllerDelegate <NSObject>

@optional

- (void)secretPhotosEditorViewController:(KTSecretPhotosEditorViewController*)vc didUpdateFilters:(CGFloat)blurLevel brightnessLevel:(CGFloat)brightnessLevel;


@end