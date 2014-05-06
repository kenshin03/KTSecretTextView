//
//  KTSecretTextureChooserViewController.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 4/30/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretTextureChooserViewController.h"

@interface KTSecretTextureChooserViewController ()

@property (nonatomic, strong) UIImageView *textureImageView;
@property (atomic) NSInteger selectedTextureIndex;
@property (nonatomic, strong) NSDictionary *texturesDictionary;
@property (nonatomic, strong) NSDictionary *textureNamesDictionary;


@end

@implementation KTSecretTextureChooserViewController


#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedTextureIndex = 0;
    [self addSubviewTree];
    [self constrainViews];
}

- (void)loadView
{
    self.view = [self mainView];
}


#pragma mark - Initialization

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    mainView.alpha = 0.9;
    mainView.userInteractionEnabled = NO;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.textureImageView];
}

- (void)constrainViews
{
    NSDictionary *viewsDict = @{
                                @"textureImageView":self.textureImageView
                                };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textureImageView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textureImageView(380)]" options:0 metrics:nil views:viewsDict]];
    
}

#pragma mark - Public Methods

- (void)selectPreviousTexture:(BOOL)previousTexture
{
    self.selectedTextureIndex += 1;
    
    // reset index
    if (self.selectedTextureIndex > 5) {
        self.selectedTextureIndex = 0;
    }
    UIImage *textureImage = self.texturesDictionary[@(self.selectedTextureIndex)];
    self.textureImageView.image = textureImage;
    
    [self updateDelegateOnSelectedTexture:self.selectedTextureIndex];
}

- (void)selectNextTexture:(BOOL)nextTexture
{
    self.selectedTextureIndex -= 1;
    // reset index
    if (self.selectedTextureIndex < 0) {
        self.selectedTextureIndex = 5;
    }
    UIImage *textureImage = self.texturesDictionary[@(self.selectedTextureIndex)];
    self.textureImageView.image = textureImage;
    
    [self updateDelegateOnSelectedTexture:self.selectedTextureIndex];
}


#pragma mark - Private

#pragma mark - Private properties

- (NSDictionary*)texturesDictionary
{
    if (!_texturesDictionary) {
        _texturesDictionary = @{
                                @(KTSecretTextureGlow):[[UIImage imageNamed:@"default_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                @(KTSecretTextureLinen):[[UIImage imageNamed:@"linen_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                @(KTSecretTextureLines):[[UIImage imageNamed:@"lines_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                @(KTSecretTextureNoise):[[UIImage imageNamed:@"noise_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                @(KTSecretTextureSquared):[[UIImage imageNamed:@"squared_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                @(KTSecretTextureSquared2):[[UIImage imageNamed:@"squares2_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile],
                                
                                };
    }
    return _texturesDictionary;
}

- (NSDictionary*)textureNamesDictionary
{
    if (!_textureNamesDictionary) {
        _textureNamesDictionary = @{
                                    @(KTSecretTextureGlow):     NSLocalizedString(@"Glow", nil),
                                    
                                    @(KTSecretTextureLinen):    NSLocalizedString(@"Linen", nil),
                                    
                                    @(KTSecretTextureLines):    NSLocalizedString(@"Lines", nil),
                                    
                                    @(KTSecretTextureNoise):    NSLocalizedString(@"Noise", nil),
                                    
                                    @(KTSecretTextureSquared):    NSLocalizedString(@"Squares", nil),
                                    
                                    @(KTSecretTextureSquared2): NSLocalizedString(@"Squares 2", nil),
                                    
                                    };
    }
    return _textureNamesDictionary;
}


- (UIImageView*) textureImageView
{
    if (!_textureImageView) {
        _textureImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"default_texture"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
        _textureImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _textureImageView.alpha = 0.4f;
    }
    return _textureImageView;
}

#pragma mark - Initialization helpers

- (void)updateDelegateOnSelectedTexture:(NSInteger)selectedIndex
{
    UIImage *textureImage = self.texturesDictionary[@(selectedIndex)];
    NSString *textureName = self.textureNamesDictionary[@(selectedIndex)];
    
    [self.delegate secretTextureChooserViewController:self didSelectTexture:textureImage name:textureName];
    
}


@end
