//
//  MHKeyboardAdaptiveView.h
//  MHKit
//
//  Created by Michael Hong on 3/17/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHView.h"

/* MHKeyboardAdaptiveView is a subclass of MHview (a subclass of UIView)
 that wraps all the contents in a scrollview and scroll in accordance to
 the appearance and disappearnce of the keyboard.
 
 To enable auto scrolling, one must register the input controls that need
 to trigger the scrolling. The control will be registered with 
 UIKeyboardWillShowNotification and UIKeyboardWillHideNotification
 notifications. When one control sends out a UIKeyboardWillHideNotification,
 and the keyboard pops up, MHKeyboardAdaptiveView will make sure the
 frame that is associated with the control be scrolled to visible. */


@interface MHKeyboardAdaptiveView : MHView

@property UIScrollView *contentView;

- (void) registerInputControl: (UIView *)control frameView:(UIView *) frame;
- (void) dismissKeyboard;

@end
