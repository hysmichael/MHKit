//
//  MHViewLayoutManager.h
//  MHKit
//
//  Created by Michael Hong on 2/14/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* POSITION OF A VIEW
 1 --- 2 --- 3
 |     |     |
 4 --- 5 --- 6
 |     |     |
 7 --- 8 --- 9 */
typedef enum MHViewLayoutPositionType {
    MHViewLayoutUpperLeft = 1,  MHViewLayoutUpperMiddle,  MHViewLayoutUpperRight,
    MHViewLayoutMiddleLeft,     MHViewLayoutCenter,       MHViewLayoutMiddleRight,
    MHViewLayoutLowerLeft,      MHViewLayoutLowerMiddle,  MHViewLayoutLowerRight
} MHViewLayoutPosition;

typedef enum MHViewLayoutGuideLineType {
    MHViewLayoutNoGuideLines = 0, MHViewLayoutAllGuideLines = 1, MHViewLayoutOnlyLeftRightGuideLines, MHViewLayoutOnlyUpDownGuideLines
} MHViewLayoutGuideLine;

/* DEFINITION OF MHViewLayoutLength
 POSITIVE VALUE > 1.0           : actual length = VALUE (> 1.0)
 POSITIVE VALUE (0.0, 1.0]      : percentage of valid container dimension                           (MHViewLayoutGuideLine applies)
 ZERO                           : 1.0
 NEGATIVE VALUE [-1.0, 0.0)     : percentage of length from cursor point to valid container boarder (MHViewLayoutGuideLine applies)
 NEGATIVE VALUE < -1.0          : length from cursor to valid container boarder minus VALUE         (MHViewLayoutGuideLine applies)
 */
typedef CGFloat MHViewLayoutLength;

/* direction is defined on a plane (4-quarters)
 ::
   2 | 1
 ---------
   3 | 4      */
typedef int MHViewLayoutDirection;


@interface MHViewLayoutManager : NSObject

/* guildlines can be opt-in or opt-out for every operation. 
 the default value at initialization is (10, 10) */
@property CGFloat upDownGuideline;
@property CGFloat leftRightGuideLine;

@property CGPoint cursor;

- (instancetype) initWithContainerView:(UIView *)view;
- (void) resetToView:(UIView *)view;

- (CGPoint) pointOfPosition:(MHViewLayoutPosition)position;
- (CGPoint) pointOfContainerPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGPoint) pointOfView:(UIView *)view AtPosition:(MHViewLayoutPosition)position;

- (CGPoint) moveCursorToPosition:(MHViewLayoutPosition)position;
- (CGPoint) moveCursorToContainerPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGPoint) moveCursorToView:(UIView *)view AtPosition:(MHViewLayoutPosition)position;
- (CGPoint) moveCursorToFrame:(CGRect)frame AtPosition:(MHViewLayoutPosition)position;

- (CGPoint) moveCursorHorizontally:(MHViewLayoutLength)x_para
                         rightward:(BOOL)rightward applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGPoint) moveCursorVertically:(MHViewLayoutLength)y_para
                        downward:(BOOL)downward applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGPoint) moveCursorByOffsetX:(MHViewLayoutLength)x_para offsetY:(MHViewLayoutLength)y_para
                      direction:(MHViewLayoutDirection)direction applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGPoint) simpleMoveX:(CGFloat)x Y:(CGFloat)y;

- (CGPoint) revert;

- (CGRect) setView:(UIView *)view width:(MHViewLayoutLength)w_para height:(MHViewLayoutLength)h_para
                    respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGRect) setView:(UIView *)view width:(MHViewLayoutLength)w_para ratio:(CGFloat)ratio
                    respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGRect) setView:(UIView *)view height:(MHViewLayoutLength)h_para ratio:(CGFloat)ratio
                    respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGRect) setView:(UIView *)view respectToPoint:(CGPoint)point;

- (CGSize)  resetContainerWithFlexibleWidth:(BOOL)flx_w flexibleHeight:(BOOL)flx_h applyGuideLine:(MHViewLayoutGuideLine)guideline;
- (CGFloat) saveContainerWidth:(NSString *)key;
- (CGFloat) saveContainerHeight:(NSString *)key;

+ (void)    saveValue:(CGFloat)value toKey:(NSString *)key;
+ (CGFloat) retrieveValueforKey:(NSString *)key;

@end


