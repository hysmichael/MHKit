//
//  MHLabel.m
//  MHKit
//
//  Created by Michael Hong on 5/29/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHLabel.h"

@implementation MHLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end
