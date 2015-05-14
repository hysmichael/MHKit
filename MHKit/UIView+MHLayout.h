//
//  UIView+MHLayout.h
//  MHKit
//
//  Created by Michael Hong on 5/13/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int MHLayoutPosition;
typedef CGFloat MHLayoutLength;

typedef enum MHMarginEdge_enum {
    MHMarginEdgeNone = 0, MHMarginEdgeAll = 1, MHMarginEdgeX, MHMarginEdgeY
} MHMarginEdge;


@interface UIView (MHLayout)

- (void) setAsLayoutContainer;
- (void) setXMargin: (CGFloat) value;
- (void) setYMargin: (CGFloat) value;

- (CGPoint) pointOfPosition: (MHLayoutPosition) position;
- (CGPoint) moveToPosition: (MHLayoutPosition) position;

- (CGRect) layoutWidth:(MHLayoutLength) w_para height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutRatio:(CGFloat) ratio width:(MHLayoutLength) w_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutRatio:(CGFloat) ratio height:(MHLayoutLength) h_para anchor:(MHLayoutPosition) position margin:(MHMarginEdge) edges;
- (CGRect) layoutDiagonal:(CGPoint) counterpoint;


@end

@interface MHLayout : NSObject

+ (CGPoint) pointOfPosition: (MHLayoutPosition) position;
+ (CGPoint) pointOfContainerPosition:(MHLayoutPosition) position;

+ (CGPoint) simpleMoveX:(CGFloat) x Y:(CGFloat) y;
+ (CGPoint) moveByArguments:(NSDictionary *) args;

+ (CGPoint) moveToPosition: (MHLayoutPosition) position;
+ (CGPoint) moveToContainerPosition: (MHLayoutPosition) position margin:(MHMarginEdge) edges;
+ (CGPoint) moveToFrame:(CGRect) frame atPosition: (MHLayoutPosition) position;

+ (CGPoint) revert;

@end