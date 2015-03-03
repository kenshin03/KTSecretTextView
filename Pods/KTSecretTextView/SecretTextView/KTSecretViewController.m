//
//  KTSecretViewController.m
//
//  Created by Kenny Tang on 4/30/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretViewController.h"
#import "KTSecretColorChooserViewController.h"
#import "KTSecretPhotosEditorViewController.h"
#import "KTSecretTextureChooserViewController.h"
#import "KTSecretTextView.h"
#import "UIColor+KTColorUtils.h"
#import "KTImageUtil.h"
#import "UIImage+Resize.h"
@import AssetsLibrary;
@import MobileCoreServices;


static NSInteger const kKTSecretViewControllerPhotoAlertViewTakePhoto = 1;
static NSInteger const kKTSecretViewControllerPhotoAlertViewChooseFromLibrary = 2;

static NSInteger const kKTSecretViewControllerRemovePhotoAlertViewRemovePhoto = 1;
static NSInteger const kKTSecretViewControllerRemovePhotoAlertViewTakePhoto = 2;
static NSInteger const kKTSecretViewControllerRemovePhotoAlertViewChooseFromLibrary = 3;


static CGFloat const kKTSecretViewControllerBackgroundInfoLabelPaddingTop = 38.0f;
static CGFloat const kKTSecretViewControllerBackgroundInfoLabelBackgroundViewPadding = 8.0f;
static CGFloat const kKTSecretViewControllerTextViewPaddingFromActionsView = -30.0f;

static CGFloat const kKTSecretViewControllerColorChooserViewHeight = 380.0f;
static CGFloat const kKTSecretViewControllerPhotoButtonWidth = 60.0f;


@interface KTSecretViewController ()<
KTSecretColorChooserViewControllerDelegate,
KTSecretTextureChooserViewControllerDelegate,
KTSecretPhotosEditorViewControllerDelegate,
KTSecretTextViewDelegate,
UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

// info label
@property (nonatomic, strong) UIView *backgroundInfoLabelBackgroundView;
@property (nonatomic, strong) UILabel *backgroundInfoLabel;

// background color
@property (nonatomic, strong) KTSecretColorChooserViewController *colorChooserViewController;

// textures
@property (nonatomic, strong) KTSecretTextureChooserViewController *textureChooserViewController;

// photo
@property (nonatomic, strong) KTSecretPhotosEditorViewController *photosEditorViewController;

// action view
@property (nonatomic, strong) UIView *actionsView;
@property (nonatomic, strong) UIButton *photosButton;

// alert views for handlng photos button
@property (nonatomic, strong) UIAlertView *photosAlertView;
@property (nonatomic, strong) UIAlertView *removePhotosAlertView;

// text view
@property (nonatomic, strong) KTSecretTextView *textView;

@end

@implementation KTSecretViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
}

- (void)loadView
{
    self.view = [self mainView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


#pragma mark - Initialization

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.alpha = 0.9;
    mainView.userInteractionEnabled = YES;
    return mainView;
}

- (void)addSubviewTree
{
    UIView *view = self.view;
    
    [self addChildViewController:self.colorChooserViewController];
    [view addSubview:self.colorChooserViewController.view];
    [self.colorChooserViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.textureChooserViewController];
    [view addSubview:self.textureChooserViewController.view];
    [self.textureChooserViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.photosEditorViewController];
    [view addSubview:self.photosEditorViewController.view];
    [self.photosEditorViewController didMoveToParentViewController:self];
    
    [view addSubview:self.backgroundInfoLabelBackgroundView];
    [view addSubview:self.backgroundInfoLabel];
    [view addSubview:self.actionsView];
    [view addSubview:self.textView];
    
    
    [self addActionsViewSubviewTree];
}

- (void)addActionsViewSubviewTree
{
    [self.actionsView addSubview:self.photosButton];
}

- (void)setupNavigationBar
{
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDoneButton:)];
    self.navigationItem.rightBarButtonItem = dismissButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didSelectCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (void)constrainViews
{
    NSDictionary *viewsDict = @{
                                @"colorChooserView":self.colorChooserViewController.view,
                                @"backgroundInfoLabel":self.backgroundInfoLabel,
                                @"backgroundInfoLabelBackgroundView":self.backgroundInfoLabelBackgroundView,
                                @"photosEditorView":self.photosEditorViewController.view,
                                @"textureImageView":self.textureChooserViewController.view,
                                @"actionsView":self.actionsView,
                                @"textView":self.textView,
                                };
    
    UIView *containerView = self.view;
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorChooserView]|" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[colorChooserView(%f)]", kKTSecretViewControllerColorChooserViewHeight] options:0 metrics:nil views:viewsDict]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textureImageView]|" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textureImageView(colorChooserView)]" options:0 metrics:nil views:viewsDict]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[photosEditorView]|" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[photosEditorView(colorChooserView)]" options:0 metrics:nil views:viewsDict]];
    
    // extend text view up to the actions view
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.actionsView attribute:NSLayoutAttributeTop multiplier:1.0f constant:kKTSecretViewControllerTextViewPaddingFromActionsView]];
    
    // pin background info label to center X of view, and top of view with some padding
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:kKTSecretViewControllerBackgroundInfoLabelPaddingTop]];
    
    // pin info label's background view to info label, with some padding
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabelBackgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundInfoLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabelBackgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundInfoLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabelBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.backgroundInfoLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:kKTSecretViewControllerBackgroundInfoLabelBackgroundViewPadding*2]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundInfoLabelBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundInfoLabel attribute:NSLayoutAttributeHeight multiplier:1.0f constant:kKTSecretViewControllerBackgroundInfoLabelBackgroundViewPadding*2]];
    
    // pin actions view to bottom of color chooser view
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[actionsView]|" options:0 metrics:nil views:viewsDict]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.actionsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorChooserViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    
    [self constrainActionsViewSubviews];
}

- (void)constrainActionsViewSubviews
{
    NSDictionary *viewsDict = @{
                                @"photosButton": self.photosButton
                                };
    [self.actionsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[photosButton(%f)]", kKTSecretViewControllerPhotoButtonWidth] options:0 metrics:nil views:viewsDict]];
    [self.actionsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[photosButton]|" options:0 metrics:nil views:viewsDict]];
}


#pragma mark - Private

#pragma mark - Private properties

- (UIAlertView*) photosAlertView
{
    if (!_photosAlertView) {
        _photosAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:
                                                     NSLocalizedString(@"Take photo", nil),
                                                     NSLocalizedString(@"Choose from library", nil), nil];
    }
    return _photosAlertView;
}

- (UIAlertView*) removePhotosAlertView
{
    if (!_removePhotosAlertView) {
        _removePhotosAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:
                            NSLocalizedString(@"Remove photo", nil),
                            NSLocalizedString(@"Take photo", nil),
                            NSLocalizedString(@"Choose from library", nil), nil];
    }
    return _removePhotosAlertView;
}

// kenny
- (KTSecretPhotosEditorViewController*) photosEditorViewController
{
    if (!_photosEditorViewController) {
        _photosEditorViewController = [KTSecretPhotosEditorViewController new];
        _photosEditorViewController.delegate = self;
        _photosEditorViewController.view.hidden = YES;
        _photosEditorViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _photosEditorViewController;
}

- (KTSecretTextView*) textView
{
    if (!_textView) {
        _textView = [KTSecretTextView new];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.secretTextViewDelegate = self;
    }
    return _textView;
}

- (KTSecretTextureChooserViewController*)textureChooserViewController
{
    if (!_textureChooserViewController) {
        _textureChooserViewController = [KTSecretTextureChooserViewController new];
        _textureChooserViewController.delegate = self;
        _textureChooserViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textureChooserViewController;
}

- (KTSecretColorChooserViewController*)colorChooserViewController
{
    if (!_colorChooserViewController) {
        _colorChooserViewController = [KTSecretColorChooserViewController new];
        _colorChooserViewController.delegate = self;
        _colorChooserViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _colorChooserViewController;
}

- (UIView*)actionsView
{
    if (!_actionsView) {
        _actionsView = [UIView new];
        _actionsView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _actionsView;
}

- (UIButton*)photosButton
{
    if (!_photosButton) {
        _photosButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photosButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_photosButton addTarget:self action:@selector(didSelectPhotosButton:) forControlEvents:UIControlEventTouchUpInside];
        _photosButton.backgroundColor = [UIColor clearColor];
        UIImage *photosButtonImage = [[UIImage imageNamed:@"camera_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _photosButton.tintColor = [UIColor whiteColor];
        [_photosButton setImage:photosButtonImage forState:UIControlStateNormal];
        [_photosButton setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f)];
    }
    return _photosButton;
}

- (UILabel*)backgroundInfoLabel
{
    if (!_backgroundInfoLabel) {
        _backgroundInfoLabel = [UILabel new];
        
        _backgroundInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundInfoLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:16.0f];
        _backgroundInfoLabel.textColor = [UIColor whiteColor];
        _backgroundInfoLabel.shadowColor = [UIColor blackColor];
        _backgroundInfoLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _backgroundInfoLabel.hidden = YES;
    }
    return _backgroundInfoLabel;
}

- (UIView*)backgroundInfoLabelBackgroundView
{
    if (!_backgroundInfoLabelBackgroundView) {
        _backgroundInfoLabelBackgroundView = [UIView new];
        _backgroundInfoLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundInfoLabelBackgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundInfoLabelBackgroundView.layer.cornerRadius = 2.0f;
        _backgroundInfoLabelBackgroundView.alpha = 0.2f;
        _backgroundInfoLabelBackgroundView.hidden = YES;
    }
    return _backgroundInfoLabelBackgroundView;
}

#pragma mark - Initialization helpers

#pragma mark - KTSecretColorChooserViewControllerDelegate methods

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController *)vc didSelectColor:(UIColor *)color name:(NSString *)name
{
    [self updateBackgroundInfoColor:color];
    [self updatePhotosButtonColor:color];
    [self updateBackgroundInfoLabel:name];
}

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController *)vc didSwipeUp:(BOOL)swipedUp
{
    [self.textureChooserViewController selectPreviousTexture:YES];
}

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController *)vc didSwipeDown:(BOOL)swipedDown
{
    [self.textureChooserViewController selectNextTexture:YES];
    
}

- (void)updateBackgroundInfoColor:(UIColor*)color
{
    if ([color isLightColor]) {
        self.backgroundInfoLabel.textColor = [UIColor blackColor];
        self.backgroundInfoLabelBackgroundView.backgroundColor = [UIColor blackColor];
    }else{
        self.backgroundInfoLabel.textColor = [UIColor whiteColor];
        self.backgroundInfoLabelBackgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)updatePhotosButtonColor:(UIColor*)color
{
    if ([color isLightColor]) {
        self.photosButton.tintColor = [UIColor blackColor];
    }else{
        self.photosButton.tintColor = [UIColor whiteColor];
    }
}

- (void)updateBackgroundInfoLabel:(NSString*)text
{
    [self.backgroundInfoLabel.layer removeAllAnimations];
    [self.backgroundInfoLabelBackgroundView.layer removeAllAnimations];
    
    self.backgroundInfoLabel.alpha = 1.0f;
    self.backgroundInfoLabelBackgroundView.alpha = 0.2f;
    self.backgroundInfoLabel.hidden = NO;
    self.backgroundInfoLabelBackgroundView.hidden = NO;

    self.backgroundInfoLabel.text = text;
    
    [UIView animateWithDuration:0.5f delay:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundInfoLabel.alpha = 0.0f;
        self.backgroundInfoLabelBackgroundView.alpha = 0.0f;
    } completion:nil];
    
}

#pragma mark - KTSecretTextureChooserViewControllerDelegate methods

- (void)secretTextureChooserViewController:(KTSecretTextureChooserViewController *)vc didSelectTexture:(UIImage *)textureImage name:(NSString *)name
{
    [self updateBackgroundInfoLabel:name];
}

#pragma mark - Event handler methods

- (void)didSelectDoneButton:(UIButton*)sender
{
    // hide button before taking snapshot
    self.backgroundInfoLabel.hidden = YES;
    self.backgroundInfoLabelBackgroundView.hidden = YES;
    self.photosButton.hidden = YES;
    [self.textView resignFirstResponder];
    
    UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:YES];
    [self.delegate secretViewController:self secretViewSnapshot:snapshotView backgroundImage:self.photosEditorViewController.finalImage attributedString:self.textView.attributedText];
    
    self.photosButton.hidden = NO;
    self.backgroundInfoLabel.hidden = NO;
    self.backgroundInfoLabelBackgroundView.hidden = NO;
    
}

- (void)didSelectPhotosButton:(UIButton*)sender
{
    if (!self.photosEditorViewController.selectedImage) {
        [self.photosAlertView show];
    }else{
        [self.removePhotosAlertView show];
    }
    
}

- (void)handleTakePhoto
{
    if ([self isCameraAvailable]) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = @[(NSString*)kUTTypeImage];
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)handleChoosePhotoFromLibrary
{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark - select photos methods

- (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *assetReferenceURL = info[UIImagePickerControllerReferenceURL];
    
    if (assetReferenceURL) {
        [self handleImageFromLibrary:assetReferenceURL picker:picker];
        
    }else if (info[UIImagePickerControllerMediaMetadata]) {
        [self handleImageFromCamera:info picker:picker];
        
    }
}


#pragma mark - imagePickerController helper methods



- (void)handleImageFromCamera:(NSDictionary *)info picker:(UIImagePickerController *)picker
{
    // to-do: resize image
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    [self showPhotoEditorView];
    self.photosEditorViewController.view.hidden = NO;
    CGSize imageRect = self.photosEditorViewController.view.frame.size;
    UIImage *resizedImage = [selectedImage resizedImageToFitInSize:imageRect scaleIfSmaller:YES];
    self.photosEditorViewController.selectedImage = resizedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleImageFromLibrary:(NSURL*)assetReferenceURL picker:(UIImagePickerController *)picker
{
    ALAssetsLibrary *assetslibrary = [ALAssetsLibrary new];
    [assetslibrary assetForURL:assetReferenceURL resultBlock:^(ALAsset *asset) {
        
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat maxPixelSize = [mainScreen bounds].size.width * [mainScreen scale];
        UIImage *resizedImage = [KTImageUtil thumbnailForAsset:asset maxPixelSize:maxPixelSize];
        if (resizedImage) {
            [self showPhotoEditorView];
            self.photosEditorViewController.view.hidden = NO;
            self.photosEditorViewController.selectedImage = resizedImage;
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"resize image failed: %@", error);
    }];
}

- (void)hidePhotoEditorView
{
    self.photosEditorViewController.view.hidden = YES;
    self.colorChooserViewController.view.hidden = NO;
}

- (void)showPhotoEditorView
{
    self.photosEditorViewController.view.hidden = NO;
    self.colorChooserViewController.view.hidden = YES;
}

#pragma mark - KTSecretPhotosEditorViewControllerDelegate methods

- (void)secretPhotosEditorViewController:(KTSecretPhotosEditorViewController *)vc didUpdateFilters:(CGFloat)blurLevel brightnessLevel:(CGFloat)brightnessLevel
{
    NSString *blurTitleString = NSLocalizedString(@"Blur", nil);
    NSString *dimTitleString = NSLocalizedString(@"Dim", nil);
    
    NSString *filterString = [NSString stringWithFormat:@"%@: %.0f%% %@: %.0f%%", blurTitleString, blurLevel, dimTitleString, brightnessLevel];
    [self updateBackgroundInfoLabel:filterString];
}

#pragma mark - UIAlertViewDelegate methods

 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.photosAlertView) {
        switch (buttonIndex) {
            case kKTSecretViewControllerPhotoAlertViewTakePhoto:
                [self handleTakePhoto];
                break;
            case kKTSecretViewControllerPhotoAlertViewChooseFromLibrary:
                [self handleChoosePhotoFromLibrary];
                break;
            default:
                break;
        }
        
    }else if (alertView == self.removePhotosAlertView) {
        switch (buttonIndex) {
            case kKTSecretViewControllerRemovePhotoAlertViewRemovePhoto:
                [self removeSelectedImageFromView];
                break;
            case kKTSecretViewControllerRemovePhotoAlertViewTakePhoto:
                [self handleTakePhoto];
                break;
            case kKTSecretViewControllerRemovePhotoAlertViewChooseFromLibrary:
                [self handleChoosePhotoFromLibrary];
                break;
            default:
                break;
        }
        
    }
}

#pragma mark - clickedButtonAtIndex helper methods

- (void)removeSelectedImageFromView
{
    self.photosEditorViewController.selectedImage = nil;
    [self hidePhotoEditorView];
}

#pragma mark - KTSecretTextViewDelegate methods

- (UIView*)secretTextView:(KTSecretTextView*)view viewForHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *viewForHitTest = nil;
    CGRect photosButtonFrame = [self.view convertRect:self.photosButton.frame fromView:self.actionsView];
    CGRect collectionViewFrame = self.colorChooserViewController.view.frame;
    CGRect photosEditorViewFrame = self.photosEditorViewController.view.frame;
    
    if (CGRectContainsPoint(photosButtonFrame, point)) {
        viewForHitTest = self.photosButton;
    }else if ((self.photosEditorViewController.view.hidden) && (CGRectContainsPoint(collectionViewFrame, point))){
        viewForHitTest = self.colorChooserViewController.collectionView;
    } else if ((!self.photosEditorViewController.view.hidden) && (CGRectContainsPoint(photosEditorViewFrame, point))){
        viewForHitTest = self.photosEditorViewController.view;
    }
    return viewForHitTest;
}



@end
