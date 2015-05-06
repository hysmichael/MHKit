//
//  MHEmptyView.m
//  MHKit
//
//  Created by Michael Hong on 2/19/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHEmptyView.h"

@implementation MHEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.caption = [UILabel new];
        self.caption.font = [UIFont boldSystemFontOfSize:16.0];
        self.caption.textColor = [UIColor darkGrayColor];
        self.caption.textAlignment = NSTextAlignmentCenter;
        
        self.details = [UILabel new];
        self.details.font = [UIFont boldSystemFontOfSize:14.0];
        self.details.textColor = [UIColor lightGrayColor];
        self.details.textAlignment = NSTextAlignmentCenter;
        self.details.numberOfLines = 0;
        self.details.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.caption];
        [self addSubview:self.details];
    }
    return self;
}

- (void)layoutSubviews {
    self.details.frame = CGRectMake(20.0, 0.0, self.frame.size.width - 40.0, 0.0);
    [self.details sizeToFit];
    CGFloat detailHeight = self.details.frame.size.height;
    CGFloat padding = (self.frame.size.height - detailHeight - 30.0) / 2;
    
    self.caption.frame = CGRectMake(0.0, padding, self.frame.size.width, 20.0);
    self.details.frame = CGRectMake(20.0, padding + self.caption.frame.size.height + 10.0, self.frame.size.width - 40.0, detailHeight);
}

@end
