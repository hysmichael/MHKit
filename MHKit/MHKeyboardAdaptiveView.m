//
//  MHKeyboardAdaptiveView.m
//  SPFramework
//
//  Created by Michael Hong on 3/17/15.
//  Copyright (c) 2015 StylePuzzle Inc. All rights reserved.
//

#import "MHKeyboardAdaptiveView.h"

@implementation MHKeyboardAdaptiveView {
    NSDictionary *activeViewInfo;
    NSMutableArray *registeredInputControls;
}

- (void)initialize {
    [super initialize];
    
    registeredInputControls = [[NSMutableArray alloc] init];
    
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.bounces = false;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.contentView addGestureRecognizer:tapRecognizer];
    [self addSubview:self.contentView];
    
    [self registerForKeyboardNotifications];
}

- (void)layoutSubviews {
    self.contentView.frame = self.bounds;
    self.contentView.contentSize = self.bounds.size;
    [super layoutSubviews];
}

- (void)registerInputControl:(UIView *)control frameView:(UIView *)frame {
    if (!frame) frame = control;
    [registeredInputControls addObject:@{@"view"    : control,
                                         @"frame"   : frame, }];
}

#pragma mark - Keyboard Notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) findActiveView {
    for (NSDictionary *viewInfo in registeredInputControls) {
        if ([viewInfo[@"view"] isFirstResponder]) {
            activeViewInfo = viewInfo;
            return;
        }
    }
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.contentView.contentInset = contentInsets;
    self.contentView.scrollIndicatorInsets = contentInsets;
    
    [self findActiveView];
    UIView *frameView = activeViewInfo[@"frame"];
    [self.contentView scrollRectToVisible:frameView.frame animated:true];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentView.contentInset = contentInsets;
    self.contentView.scrollIndicatorInsets = contentInsets;
}

-(void)dismissKeyboard {
    if (activeViewInfo) {
        [activeViewInfo[@"view"] resignFirstResponder];
        activeViewInfo = nil;
    }
}

#pragma mark - UIView Overrides
- (void)addSubview:(UIView *)view {
    if (view != self.contentView) {
        [self.contentView addSubview:view];
    } else {
        [super addSubview:view];
    }
}

#pragma mark - Delloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
