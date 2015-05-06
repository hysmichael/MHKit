//
//  MHSwitcher.h
//  MHKit
//
//  Created by Michael Hong on 4/29/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHView.h"

@interface MHSwitcher : MHView

@property UIColor *selectedBackgroundColor;

@property UIColor *textColor;
@property UIColor *selectedTextColor;
@property UIFont  *font;

@property NSUInteger selectedIndex;

@property (nonatomic, copy) void(^userTapped)(NSUInteger);

- (instancetype) initWithTitles:(NSArray *)titles;
- (void) setToIndex:(NSUInteger) index;

@end
