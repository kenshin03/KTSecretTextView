//
//  KTSecretTextureChooserViewController.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 4/30/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTSecretTextureChooserViewControllerDelegate;

typedef NS_ENUM(NSUInteger, KTSecretTexture)
{
    KTSecretTextureGlow = 0,
    KTSecretTextureLinen,
    KTSecretTextureLines,
    KTSecretTextureNoise,
    KTSecretTextureSquared,
    KTSecretTextureSquared2,
};

/**
 *  View Controller for controlling which texture to use as the foreground for the background
 */
@interface KTSecretTextureChooserViewController : UIViewController

@property (nonatomic, weak) id<KTSecretTextureChooserViewControllerDelegate> delegate;

/**
 *  Method to select the previous texture
 *
 *  @param previousTexture
 */
- (void)selectPreviousTexture:(BOOL)previousTexture;

/**
 *  Method to select the next texture
 *
 *  @param nextTexture
 */
- (void)selectNextTexture:(BOOL)nextTexture;

@end


/**
 *  Protocol for delegates to be informed of texture selection events
 */
@protocol KTSecretTextureChooserViewControllerDelegate <NSObject>

@optional

- (void)secretTextureChooserViewController:(KTSecretTextureChooserViewController*)vc didSelectTexture:(UIImage*)textureImage name:(NSString*)name;

@end