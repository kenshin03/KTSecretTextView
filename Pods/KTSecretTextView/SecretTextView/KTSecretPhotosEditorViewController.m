//
//  KTSecretPhotosEditorViewController.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/1/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretPhotosEditorViewController.h"
#import "KTNumberUtil.h"

static const CGFloat kKTSecretPhotosEditorViewControllerHorizontalPanThreshold = 3.0f;
static const CGFloat kKTSecretPhotosEditorViewControllerHorizontalPanLimit = 150.0f;
static const CGFloat kKTSecretPhotosEditorViewControllerHorizontalBlurLimit = 3.0f;

static const CGFloat kKTSecretPhotosEditorViewControllerVerticalPanThreshold = 3.0f;
static const CGFloat kKTSecretPhotosEditorViewControllerVerticalPanLimit = 180.0f;
static const CGFloat kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMin = 1.0f;
static const CGFloat kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMax = 3.0f;


@interface KTSecretPhotosEditorViewController ()

@property (nonatomic, strong) UIImage *finalImage;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImage *selectedImageOriginal;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) CGFloat blurLevel;
@property (nonatomic) CGFloat brightnessLevel;

// core image
@property (nonatomic, strong) CIContext *coreImageContext;
@property (nonatomic, strong) CIFilter *gammaFilter;
@property (nonatomic, strong) CIFilter *blurFilter;

@property (nonatomic) CGFloat currentGammaFilterValue;
@property (nonatomic) CGFloat currentBlurFilterValue;

@property (nonatomic) CGFloat lastPositionX;
@property (nonatomic) CGFloat lastPositionY;


@end


@implementation KTSecretPhotosEditorViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blurLevel = 0.0f;
    self.brightnessLevel = 1.0f;
    self.currentGammaFilterValue = 1.0f;
    self.currentBlurFilterValue = 1.0f;
    self.lastPositionX = 0.0f;
    self.lastPositionY = 0.0f;

    
    [self addSubviewTree];
    [self constrainViews];
    [self setUpGestureRecognizers];
}

- (void)loadView
{
    self.view = [self mainView];
}

#pragma mark - Public Properties

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = nil;
    _selectedImage = selectedImage;
    self.selectedImageOriginal = selectedImage;
    self.photoImageView.image = selectedImage;
}


#pragma mark - Initialization

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    mainView.userInteractionEnabled = YES;
    mainView.backgroundColor = [UIColor blackColor];
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.photoImageView];
}

- (void)constrainViews
{
    NSDictionary *viewsDict = @{
                                @"photoImageView":self.photoImageView
                                };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[photoImageView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[photoImageView]|" options:0 metrics:nil views:viewsDict]];
    
}

- (void)setUpGestureRecognizers
{
    UIView *view = self.view;
    [view addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - Private

#pragma mark - Private properties

- (CIFilter*) gammaFilter
{
    if (!_gammaFilter) {
        _gammaFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    }
    return _gammaFilter;
}

- (CIFilter*) blurFilter
{
    if (!_blurFilter) {
        _blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    }
    return _blurFilter;
}

- (CIContext*) coreImageContext
{
    if (!_coreImageContext) {
        _coreImageContext = [CIContext contextWithOptions:nil];
    }
    return _coreImageContext;
}

- (UIImageView*) photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _photoImageView;
}

- (UIPanGestureRecognizer*)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGestureRecognizer;
}

#pragma mark - UIPanGestureRecognizer handling methods

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer
{
    CGPoint translationInView = [panGestureRecognizer translationInView:self.view];
    CGPoint positionInView = [panGestureRecognizer locationInView:self.view];
    
    CGFloat translationX = translationInView.x;
    CGFloat translationY = translationInView.y;
    CGFloat positionX = positionInView.x;
    CGFloat positionY = positionInView.y;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // don't trigger too often to improve performance
        CGFloat positionXDiff = self.lastPositionX - positionX;
        CGFloat positionYDiff = self.lastPositionY - positionY;
        
        if ((abs(positionXDiff) > kKTSecretPhotosEditorViewControllerHorizontalPanThreshold) ||
            (abs(positionYDiff) > kKTSecretPhotosEditorViewControllerVerticalPanThreshold)
            ){
                [self updateFiltersOnImage:translationX translationY:translationY];
            }
        
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self updateFiltersOnImage:translationX translationY:translationY];
    }
    
    self.lastPositionX = positionX;
    self.lastPositionY = positionY;
    
}

- (void)updateFiltersOnImage:(CGFloat)translationX translationY:(CGFloat)translationY
{
    if (abs(translationX) > kKTSecretPhotosEditorViewControllerHorizontalPanThreshold) {
        CGFloat blurLevel = [self blurLevelFromTranslationX:translationX];
        self.currentBlurFilterValue = blurLevel;
    }
    if (abs(translationY) > kKTSecretPhotosEditorViewControllerVerticalPanThreshold) {
        CGFloat brightnessLevel = [self brightnessLevelFromTranslationY:translationY];
        self.currentGammaFilterValue = brightnessLevel;
    }
    [self updatePhotoImageFilters];
    [self updateDelegetOnImageFilterChanges];
}

- (void)updateDelegetOnImageFilterChanges
{
    static CGFloat kKTSecretPhotosEditorViewControllerPercentageLimit = 100.0f;
    
    CGFloat blurPercentage = [KTNumberUtil remapNumbersToRange:self.currentBlurFilterValue fromMin:0.0f fromMax:kKTSecretPhotosEditorViewControllerHorizontalBlurLimit toMin:0 toMax:kKTSecretPhotosEditorViewControllerPercentageLimit];
    
    CGFloat dimPercentage = [KTNumberUtil remapNumbersToRange:self.currentGammaFilterValue fromMin:kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMin fromMax:kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMax toMin:0 toMax:kKTSecretPhotosEditorViewControllerPercentageLimit];
    
    [self.delegate secretPhotosEditorViewController:self didUpdateFilters:blurPercentage brightnessLevel:dimPercentage];
}

- (CGFloat)blurLevelFromTranslationX:(CGFloat)translationX
{
    // translate 0-250 to 0-3.0
    CGFloat blurLevelScaled = [KTNumberUtil remapNumbersToRange:translationX fromMin:0.0f fromMax:kKTSecretPhotosEditorViewControllerHorizontalPanLimit toMin:0.0f toMax:kKTSecretPhotosEditorViewControllerHorizontalBlurLimit];
    
    blurLevelScaled = MAX(0.0f, blurLevelScaled);
    blurLevelScaled = MIN(kKTSecretPhotosEditorViewControllerHorizontalBlurLimit, blurLevelScaled);
    return blurLevelScaled;
}

- (CGFloat)brightnessLevelFromTranslationY:(CGFloat)translationY
{
    // invert it as we want the image to dim with a upwards pan
    translationY = -1 * translationY;
    
    CGFloat brightnessLevelScaled = [KTNumberUtil remapNumbersToRange:translationY fromMin:0.0f fromMax:kKTSecretPhotosEditorViewControllerVerticalPanLimit toMin:kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMin toMax:kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMax];
    
    brightnessLevelScaled = MAX(1.0f, brightnessLevelScaled);
    brightnessLevelScaled = MIN(kKTSecretPhotosEditorViewControllerVerticalBrightnessLimitMax, brightnessLevelScaled);
    
    return brightnessLevelScaled;
}

- (void)updatePhotoImageFilters
{
    CIImage *ciImage = [CIImage imageWithCGImage:self.selectedImageOriginal.CGImage];
    CIImage *result = nil;
    
    CIFilter *blurFilter = self.blurFilter;
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    [blurFilter setValue:@(self.currentBlurFilterValue) forKey:@"inputRadius"];
    result = [blurFilter valueForKey:kCIOutputImageKey];
    
    CIFilter *gammaFilter = self.gammaFilter;
    [gammaFilter setValue:result forKey:kCIInputImageKey];
    [gammaFilter setValue:@(self.currentGammaFilterValue) forKey:@"inputPower"];
    result = [gammaFilter valueForKey:kCIOutputImageKey];
    
    
    CGImageRef cgImage = [self.coreImageContext createCGImage:result fromRect:[ciImage extent]];
    UIImage *outputImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    self.photoImageView.image = outputImage;
    self.finalImage = outputImage;
}

@end
