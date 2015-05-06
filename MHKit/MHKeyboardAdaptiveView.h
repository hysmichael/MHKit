//
//  MHKeyboardAdaptiveView.h
//  MHKit
//
//  Created by Michael Hong on 3/17/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHView.h"

@interface MHKeyboardAdaptiveView : MHView

@property UIScrollView *contentView;

- (void) registerInputControl: (UIView *)control frameView:(UIView *) frame;

@end
