//
//  UIView+MHLayout.m
//  MHKit
//
//  Created by Michael Hong on 5/13/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "UIView+MHLayout.h"
#import "MHViewLayoutManager.h"

@interface MHLayout()

@property (nonatomic, strong) NSMutableArray *viewLayoutManagerStack;
+ (MHViewLayoutManager *) currentManager;

@end

@implementation UIView (MHLayout)

- (void) setAsLayoutContainer {
    [MHLayout setLayoutContainer:self];
}

- (void) pushAsLayoutSubcontainer {
    [MHLayout pushLayoutSubcontainer:self];
}

- (CGPoint) pointOfPosition: (MHLayoutPosition) position {
    return [[MHLayout currentManager] pointOfView:self AtPosition:position];
}

- (CGPoint) moveToPosition: (MHLayoutPosition) position {
    return [[MHLayout currentManager] moveCursorToView:self AtPosition:position];
}

- (CGRect) layoutWidth:(MHLayoutLength) w_para height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    return [[MHLayout currentManager] setView:self width:w_para height:h_para respectToPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

- (CGRect) layoutRatio:(CGFloat) ratio width:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    return [[MHLayout currentManager] setView:self width:w_para ratio:ratio respectToPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

- (CGRect) layoutRatio:(CGFloat) ratio height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    return [[MHLayout currentManager] setView:self height:h_para ratio:ratio respectToPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

- (CGRect) layoutDiagonal:(CGPoint) counterpoint {
    return [[MHLayout currentManager] setView:self respectToPoint:counterpoint];
}

- (CGRect)layoutAdaptiveWithFixedWidth:(MHLayoutLength)w_para anchor:(MHLayoutPosition)position margin:(MHMarginEdge)edges {
    [[MHLayout currentManager] setView:self width:w_para height:0.0 respectToPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
    [self sizeToFit];
    return [[MHLayout currentManager] setView:self width:w_para height:self.bounds.size.height respectToPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

@end

@implementation MHLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewLayoutManagerStack = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (MHLayout *) sharedInstance {
    static MHLayout *sharedLayoutInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLayoutInstance = [[self alloc] init];
    });
    return sharedLayoutInstance;
}

#pragma mark Stack Management
+ (NSMutableArray *) stack {
    return [self sharedInstance].viewLayoutManagerStack;
}

+ (MHViewLayoutManager *) currentManager {
    return [[self stack] lastObject];
}

+ (void) setLayoutContainer:(UIView *)view {
    [self sharedInstance].viewLayoutManagerStack = [[NSMutableArray alloc] init];
    [self pushLayoutSubcontainer:view];
}

+ (void) pushLayoutSubcontainer: (UIView *) view {
    MHViewLayoutManager *lm = [[MHViewLayoutManager alloc] initWithContainerView:view];
    [[self stack] addObject:lm];
}

+ (void) popLayoutSubcontainer {
    NSMutableArray *stack = [self stack];
    if ([stack count] > 0) [stack removeLastObject];
}

#pragma mark Container Setter
+ (void) setXMargin: (CGFloat) value {
    [self currentManager].leftRightGuideLine = value;
}

+ (void) setYMargin: (CGFloat) value {
    [self currentManager].upDownGuideline = value;
}

#pragma mark Position Getter
+ (CGPoint) pointOfPosition: (MHLayoutPosition) position {
    return [[self currentManager] pointOfPosition:position];
}

+ (CGPoint) pointOfContainerPosition:(MHLayoutPosition)position margin:(MHMarginEdge)edges {
    return [[self currentManager] pointOfContainerPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

#pragma mark Cursor Mover
+ (CGPoint) simpleMoveX:(CGFloat) x Y:(CGFloat) y {
    return [[self currentManager] simpleMoveX:x Y:y];
}

+ (CGPoint) moveByArguments:(NSDictionary *) args {
    NSNumber *x_para, *y_para;
    int x_dir = 0, y_dir = 0;
    if (args[@"x"])     { x_para = args[@"x"];  x_dir = 1;    }
    if (args[@"-x"])    { x_para = args[@"-x"]; x_dir = -1;   }
    if (args[@"y"])     { y_para = args[@"y"];  y_dir = 1;    }
    if (args[@"-y"])    { y_para = args[@"-y"]; y_dir = -1;   }
    MHLayoutLength x_para_raw = 0;
    MHLayoutLength y_para_raw = 0;
    if (x_para) x_para_raw = [x_para floatValue];
    if (y_para) y_para_raw = [y_para floatValue];
    
    NSNumber *edges = args[@"margin"];
    MHMarginEdge edges_raw = 0; // default to no margin edges
    if (edges) edges_raw = [edges intValue];
    
    if (x_dir == 0) {
        if (y_dir == 0)     { return [self currentManager].cursor; }
        if (y_dir == 1)     { return [[self currentManager] moveCursorVertically:y_para_raw downward:true applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
        if (y_dir == -1)    { return [[self currentManager] moveCursorVertically:y_para_raw downward:false applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
    }
    if (x_dir == 1) {
        if (y_dir == 0)     { return [[self currentManager] moveCursorHorizontally:x_para_raw rightward:true applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
        if (y_dir == 1)     { return [[self currentManager] moveCursorByOffsetX:x_para_raw offsetY:y_para_raw direction:4 applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
        if (y_dir == -1)    { return [[self currentManager] moveCursorByOffsetX:x_para_raw offsetY:y_para_raw direction:1 applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
    }
    if (x_dir == -1) {
        if (y_dir == 0)     { return [[self currentManager] moveCursorHorizontally:x_para_raw rightward:false applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
        if (y_dir == 1)     { return [[self currentManager] moveCursorByOffsetX:x_para_raw offsetY:y_para_raw direction:3 applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
        if (y_dir == -1)    { return [[self currentManager] moveCursorByOffsetX:x_para_raw offsetY:y_para_raw direction:2 applyGuideLine:(MHViewLayoutGuideLine)edges_raw]; }
    }
    return CGPointZero;
}

+ (CGPoint) moveToPosition: (MHLayoutPosition) position {
    return [[self currentManager] moveCursorToPosition:position];
}

+ (CGPoint) moveToContainerPosition: (MHLayoutPosition) position margin:(MHMarginEdge) edges {
    return [[self currentManager] moveCursorToContainerPosition:position applyGuideLine:(MHViewLayoutGuideLine)edges];
}

+ (CGPoint) moveToFrame:(CGRect) frame atPosition: (MHLayoutPosition) position {
    return [[self currentManager] moveCursorToFrame:frame AtPosition:position];
}

+ (CGPoint) revert {
    return [[self currentManager] revert];
}

+ (CGRect) installVirtualLayoutView: (UIView *) view {
    NSMutableArray *stack = [self stack];
    if ([stack count] == 0) return CGRectZero;
    NSUInteger lastIndex = [stack count] - 1;
    stack[lastIndex] = [[MHViewLayoutManager alloc] initWithContainerView:view parentLayoutManager:stack[lastIndex]];
    return view.frame;
}

+ (CGRect) installVirtualLayoutSubframeWidth:(MHLayoutLength) w_para height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    UIView *virtualView = [[UIView alloc] init];
    [virtualView layoutWidth:w_para height:h_para anchor:position margin:edges];
    return [self installVirtualLayoutView:virtualView];
}

+ (CGRect) installVirtualLayoutSubframeRatio:(CGFloat) ratio width:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    UIView *virtualView = [[UIView alloc] init];
    [virtualView layoutRatio:ratio width:w_para anchor:position margin:edges];
    return [self installVirtualLayoutView:virtualView];
}

+ (CGRect) installVirtualLayoutSubframeRatio:(CGFloat) ratio height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges {
    UIView *virtualView = [[UIView alloc] init];
    [virtualView layoutRatio:ratio height:h_para anchor:position margin:edges];
    return [self installVirtualLayoutView:virtualView];
}

+ (CGRect) installVirtualLayoutSubframeDiagonal:(CGPoint) counterpoint {
    UIView *virtualView = [[UIView alloc] init];
    [virtualView layoutDiagonal:counterpoint];
    return [self installVirtualLayoutView:virtualView];
}

+ (CGRect) uninstallVirtualLayoutSubframe {
    NSMutableArray *stack = [self stack];
    if ([stack count] == 0) return CGRectZero;
    NSUInteger lastIndex = [stack count] - 1;
    MHViewLayoutManager *lm = stack[lastIndex];
    stack[lastIndex] = lm.parentLayoutManager;
    return [lm containerFrameInParentLayoutContext];
}

+ (void) uninstallAllVirtualLayoutSubframe {
    NSMutableArray *stack = [self stack];
    if ([stack count] == 0) return;
    NSUInteger lastIndex = [stack count] - 1;
    MHViewLayoutManager *lm = stack[lastIndex];
    while (lm.parentLayoutManager) lm = lm.parentLayoutManager;  // retrace along the chain
    stack[lastIndex] = lm;
    return;
}

@end

