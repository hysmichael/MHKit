//
//  MHView.h
//  MHKit
//
//  Created by Michael Hong on 3/3/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHViewLayoutManager.h"

/* MHView allows inline drawing code and layout code without subclassing
 UIView */

@interface MHView : UIView

- (void) initialize;
- (void) addSubviews:(NSArray *)views;

@property (nonatomic, copy) void(^draw_block)(UIView *view, CGContextRef context);
@property (nonatomic, copy) void(^layout_block)(UIView *view, MHViewLayoutManager *lm);

@property CGFloat layoutUpDownGuideline;
@property CGFloat layoutLeftRightGuideLine;

@end
