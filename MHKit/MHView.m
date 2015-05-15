//
//  MHView.m
//  MHKit
//
//  Created by Michael Hong on 3/3/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHView.h"

@implementation MHView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    self.draw_block = nil;
    self.layout_block = nil;
    self.layoutLeftRightGuideLine = 10.0;
    self.layoutUpDownGuideline = 10.0;
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.draw_block) self.draw_block(self, context);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layout_block) {
        MHViewLayoutManager *lm = [[MHViewLayoutManager alloc] initWithContainerView:self];
        lm.leftRightGuideLine = self.layoutLeftRightGuideLine;
        lm.upDownGuideline = self.layoutUpDownGuideline;
        self.layout_block(self, lm);
    }
}

- (void)addSubviews:(NSArray *)views {
    for (UIView *view in views) [self addSubview:view];
}

@end
