//
//  UIView+MHLayout.h
//  MHKit
//
//  Created by Michael Hong on 5/13/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 MHLayout is a lightweight layout engine that I devised for layouting
 out views throughtout this app. I should have used Auto Layout but 
 describing layout with constraints is not quite intuitive as describing
 it using a layout procedure (like a step-by-step recipe).
 
 MHLayout and its category on UIView are wrappers around the more
 primitive MHViewLayoutManager. MHLayout requires fewer boilerplate codes
 and is more auto completion friendly. It also eliminates direct 
 management and interaction with the MHViewLayoutManager behind the scene.
 
 The full tutorial is here:
 http://hongyanshu.com/ideas/uiviewmhlayout/
 
 */

typedef int MHLayoutPosition;
typedef CGFloat MHLayoutLength;

typedef enum MHMarginEdge_enum {
    MHMarginEdgeNone = 0, MHMarginEdgeAll = 1, MHMarginEdgeX, MHMarginEdgeY
} MHMarginEdge;


@interface UIView (MHLayout)

- (void) setAsLayoutContainer;
- (void) pushAsLayoutSubcontainer;

- (CGPoint) pointOfPosition: (MHLayoutPosition) position;
- (CGPoint) moveToPosition: (MHLayoutPosition) position;

- (CGRect) layoutWidth:(MHLayoutLength) w_para height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutRatio:(CGFloat) ratio width:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutRatio:(CGFloat) ratio height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutDiagonal:(CGPoint) counterpoint;

- (CGRect) layoutAdaptiveWithFixedWidth:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;

- (CGRect) snapPosition:(MHLayoutPosition) position;

@end

@interface MHLayout : NSObject

+ (void) setLayoutContainer: (UIView *) view;
+ (void) pushLayoutSubcontainer: (UIView *) view;
+ (void) popLayoutSubcontainer;

/* both X and Y margin are particular to virtual layout subframes and layout subcontainers
 they will be stored when a new subframe is installed or a subcontainer is pushed */
+ (void) setXMargin: (CGFloat) value;
+ (void) setYMargin: (CGFloat) value;

+ (CGPoint) pointOfPosition: (MHLayoutPosition) position;
+ (CGPoint) pointOfContainerPosition:(MHLayoutPosition) position margin:(MHMarginEdge) edges;

+ (CGPoint) simpleMoveX:(CGFloat) x Y:(CGFloat) y;
+ (CGPoint) moveByArguments:(NSDictionary *) args;

+ (CGPoint) moveToPosition: (MHLayoutPosition) position;
+ (CGPoint) moveToContainerPosition: (MHLayoutPosition) position margin:(MHMarginEdge) edges;
+ (CGPoint) moveToFrame:(CGRect) frame atPosition: (MHLayoutPosition) position;

+ (CGPoint) revert;

+ (CGRect) installVirtualLayoutSubframeWidth:(MHLayoutLength) w_para height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
+ (CGRect) installVirtualLayoutSubframeRatio:(CGFloat) ratio width:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
+ (CGRect) installVirtualLayoutSubframeRatio:(CGFloat) ratio height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
+ (CGRect) installVirtualLayoutSubframeDiagonal:(CGPoint) counterpoint;

+ (CGRect) uninstallVirtualLayoutSubframe;
+ (void)   uninstallAllVirtualLayoutSubframe;

@end

