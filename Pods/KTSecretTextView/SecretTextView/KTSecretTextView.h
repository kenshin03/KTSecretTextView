//
//  KTSecretTextView.h
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/4/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KTSecretTextViewDelegate;

/**
 *  UITextView subclass that takes care of vertically center aligning the text and setting attributed on the NSAttributedString contained.
 */
@interface KTSecretTextView : UITextView

@property (nonatomic, weak) id<KTSecretTextViewDelegate> secretTextViewDelegate;

- (void)setText:(NSString *)text;

@end



@protocol KTSecretTextViewDelegate <NSObject>

- (UIView*)secretTextView:(KTSecretTextView*)view viewForHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@optional
- (void)secretTextView:(KTSecretTextView*)view textViewDidChange:(UITextView *)textView;

@end