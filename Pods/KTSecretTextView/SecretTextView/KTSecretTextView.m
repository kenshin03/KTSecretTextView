//
//  KTSecretTextView.m
//  SecretTextViewSampleApp
//
//  Created by Kenny Tang on 5/4/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretTextView.h"

// default container inset. this is to vertically center text in the text view

static NSString* const kKTSecretViewControllerTextViewPlaceholderText = @"Share a thought";
static CGFloat const kKTSecretTextViewDefaultContainerInsetFromTop = 150.0f;
static CGFloat const kKTSecretTextViewDefaultContainerInsetFromTopMinimum = 30.9f;
static NSUInteger const kKTSecretTextViewMaxNumberOfLines = 10;

static UIEdgeInsets const kKTSecretTextViewDefaultTextContainerInset = {kKTSecretTextViewDefaultContainerInsetFromTop, 10.0f, 20.0f, 10.0f};


@interface KTSecretTextView()<
UITextViewDelegate
>

@property (nonatomic) CGFloat defaultSingleLineHeight;
@property (nonatomic, strong) NSDictionary *textAttributes;

@end


@implementation KTSecretTextView

#pragma mark - Public

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor whiteColor];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.text = kKTSecretViewControllerTextViewPlaceholderText;
        [self setupDefaultContentInset];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributes];
}

#pragma mark - Override

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    self.textColor = tintColor;
}

#pragma mark - Private

#pragma mark - Private properties

- (NSDictionary*)textAttributes
{
    if (!_textAttributes) {
        
        NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
        paragrahStyle.lineSpacing = 6.0f;
        paragrahStyle.alignment = NSTextAlignmentCenter;
        
        NSShadow *shadow = [NSShadow new];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowBlurRadius = 2.0f;
        
        _textAttributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:22.0f],
                            NSParagraphStyleAttributeName: paragrahStyle,
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSShadowAttributeName: shadow
                            };
    }
    return _textAttributes;
}

#pragma mark - Initialization Helpers


- (void)setupDefaultContentInset
{
    self.textContainerInset = kKTSecretTextViewDefaultTextContainerInset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *viewToReceiveTouch = nil;
    
    CGRect rectForCurrentText = [self.layoutManager usedRectForTextContainer:self.textContainer];
    rectForCurrentText.origin.x += self.textContainerInset.left;
    rectForCurrentText.origin.y += self.textContainerInset.top;
    
    if (!CGRectContainsPoint(rectForCurrentText, point)) {
        viewToReceiveTouch = [self.secretTextViewDelegate secretTextView:self viewForHitTest:point withEvent:event];
        if (self.isFirstResponder) {
            [self resignFirstResponder];
        }
    }
//  consume event if delegate doesnt provide a view or is inside tect
    if (!viewToReceiveTouch) {
        viewToReceiveTouch = self;
    }
    return viewToReceiveTouch;
}

#pragma mark - UITextViewDelegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString *text = textView.text;
    if ([text isEqualToString:kKTSecretViewControllerTextViewPlaceholderText]) {
        
        // clear placeholder text
        textView.text = @"";
        
        // save the line height for single line text for calculation
        [self updateSingleLineHeightFromTextContainer];
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    // reset to placeholder text if empty
    NSString *text = textView.text;
    if (![text length]) {
        textView.text = kKTSecretViewControllerTextViewPlaceholderText;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateContentInsetOnContentChange:textView];
    if ([self.secretTextViewDelegate respondsToSelector:@selector(secretTextView:textViewDidChange:)]) {
        [self.secretTextViewDelegate secretTextView:self textViewDidChange:textView];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL shouldChangeText = YES;
    CGRect rectForCurrentText = [self.layoutManager usedRectForTextContainer:self.textContainer];
    NSUInteger numberOfLines = round(rectForCurrentText.size.height/self.defaultSingleLineHeight);
    
    // do not allow adding new text if reached maximum line limit
    if (numberOfLines  > kKTSecretTextViewMaxNumberOfLines) {
        if ([text length]) {
            shouldChangeText = NO;
        }
    }
    return shouldChangeText;
}

#pragma makr - text container resize methods

- (void)updateSingleLineHeightFromTextContainer
{
    // save default single line height which is useful for calculating insets later on
    CGRect rectForCurrentText = [self.layoutManager usedRectForTextContainer:self.textContainer];
    self.defaultSingleLineHeight = rectForCurrentText.size.height;
    
}

- (void)updateContentInsetOnContentChange:(UITextView *)textView
{
    CGRect rectForCurrentText = [self.layoutManager usedRectForTextContainer:self.textContainer];
    
    CGFloat containerInsetFromTop = kKTSecretTextViewDefaultContainerInsetFromTop;
    UIEdgeInsets containerInsets = kKTSecretTextViewDefaultTextContainerInset;
    
    NSUInteger numberOfLines = round(rectForCurrentText.size.height/self.defaultSingleLineHeight);
    
    // when text starts to fill up the textview, change the content inset allowing the text to move up
    if (numberOfLines >  2) {
        containerInsetFromTop = numberOfLines*self.defaultSingleLineHeight + kKTSecretTextViewDefaultContainerInsetFromTopMinimum;
    }
    // set to default value if calculation went beyond or below alloweed thresholds
    if ( (containerInsetFromTop < kKTSecretTextViewDefaultContainerInsetFromTopMinimum) ||
         (containerInsetFromTop > kKTSecretTextViewDefaultContainerInsetFromTop) ){
        containerInsetFromTop = kKTSecretTextViewDefaultContainerInsetFromTopMinimum;
    }
    containerInsets.top = containerInsetFromTop;
    self.textContainerInset = containerInsets;
}

@end
