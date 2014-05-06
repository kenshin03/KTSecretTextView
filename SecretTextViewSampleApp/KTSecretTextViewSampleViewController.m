//
//  KTSecretTextViewSampleViewController.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/5/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretTextViewSampleViewController.h"
#import "KTSecretViewController.h"
#import "KTImageUtil.h"

@interface KTSecretTextViewSampleViewController ()<
KTSecretViewControllerDelegate
>

@property (nonatomic, strong) UIBarButtonItem *editBarButton;
@property (nonatomic, strong) KTSecretViewController *secretViewController;
@property (nonatomic, strong) UIView *secretSnapshotView;

@end


@implementation KTSecretTextViewSampleViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviewTree];
}

- (void)loadView
{
    self.view = [self mainView];
}


#pragma mark - Initialization

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.frame = [[UIScreen mainScreen] bounds];
    mainView.alpha = 0.9;
    mainView.tintColor = [UIColor blueColor];
    return mainView;
}

- (void)addSubviewTree
{
    self.navigationItem.rightBarButtonItem = self.editBarButton;
}

#pragma mark - Private

#pragma mark - Private properties

- (KTSecretViewController*) secretViewController
{
    if (!_secretViewController) {
        _secretViewController = [KTSecretViewController new];
        _secretViewController.delegate = self;
    }
    return _secretViewController;
}

- (UIBarButtonItem*) editBarButton
{
    if (!_editBarButton) {
        _editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editBarButtonTapped:)];
    }
    return _editBarButton;
}

#pragma mark - Event Handler methods

- (void)editBarButtonTapped:(id)sender
{
    [self.secretSnapshotView removeFromSuperview];
    KTSecretViewController *secretVC = self.secretViewController;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secretVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - KTSecretViewControllerDelegate methods

- (void)secretViewController:(KTSecretViewController *)vc secretViewSnapshot:(UIView *)snapshotView backgroundImage:(UIImage *)backgroundImage attributedString:(NSAttributedString *)attributedString
{
    snapshotView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:snapshotView];
    self.secretSnapshotView = snapshotView;
    
    NSDictionary *viewsDict = @{@"snapshotView":snapshotView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[snapshotView(568)]" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[snapshotView]|" options:0 metrics:nil views:viewsDict]];
    [self.secretViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
