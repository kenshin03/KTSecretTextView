//
//  KTSecretColorChooserViewController.h
//
//  Created by Kenny Tang on 4/29/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTSecretColorChooserViewControllerDelegate;

/*!
 *  View Controller that displays a rainbow of colors for selection. The user can swipe between colors or long press and pan to see an index of colors and select one. It was implemented with a UICollectionView that switches layouts when a long press is detected.
 */
@interface KTSecretColorChooserViewController : UIViewController

@property (nonatomic, weak) id<KTSecretColorChooserViewControllerDelegate> delegate;
@property (nonatomic, readonly) UICollectionView *collectionView;

@end

/**
 *  Protocol for delegates to handle color selection and swipe up/down gestures
 */
@protocol KTSecretColorChooserViewControllerDelegate <NSObject>

@optional

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController*)vc didSelectColor:(UIColor*)color name:(NSString*)name;

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController*)vc didSwipeUp:(BOOL)swipedUp;

- (void)secretColorChooserViewController:(KTSecretColorChooserViewController*)vc didSwipeDown:(BOOL)swipedDown;


@end