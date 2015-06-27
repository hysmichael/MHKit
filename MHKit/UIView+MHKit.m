//
//  UIView+MHKit.m
//  MHKit
//
//  Created by Michael Hong on 5/26/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "UIView+MHKit.h"

@implementation UIView (MHKit)

- (void) addTapTarget:(id)target selector:(SEL)selector {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    tapRecognizer.numberOfTapsRequired = 1;
    [tapRecognizer addTarget:target action:selector];
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = true;
}

@end
