//
//  KTSecretViewController.h
//
//  Created by Kenny Tang on 4/30/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTSecretViewControllerDelegate;

/*!
 *  View Controller that hosts the secret view.
 */
@interface KTSecretViewController : UIViewController

@property (nonatomic, weak) id<KTSecretViewControllerDelegate> delegate;

@end


@protocol KTSecretViewControllerDelegate <NSObject>

- (void)secretViewController:(KTSecretViewController*)vc secretViewSnapshot:(UIView*)snapshotView backgroundImage:(UIImage*)backgroundImage attributedString:(NSAttributedString*)attributedString;

@end