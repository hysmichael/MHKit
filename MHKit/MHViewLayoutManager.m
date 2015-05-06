//
//  MHViewLayoutManager.m
//  MHKit
//
//  Created by Michael Hong on 2/14/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHViewLayoutManager.h"

#define NEGLECTED 0.0


@interface MHViewLayoutStorage : NSObject

@property NSMutableDictionary *data;

+ (MHViewLayoutStorage *) sharedStorage;

@end

@implementation MHViewLayoutStorage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (MHViewLayoutStorage *)sharedStorage {
    static MHViewLayoutStorage *_sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStorage = [[MHViewLayoutStorage alloc] init];
    });
    return _sharedStorage;
}

@end




@interface MHViewLayoutManager()
@property CGFloat containerWidth;
@property CGFloat containerHeight;
@property NSMutableArray *cursorHistory;
@property CGRect lastFrame;
@end

@implementation MHViewLayoutManager

- (instancetype)initWithContainerView:(UIView *)view {
    self = [super init];
    if (self) {
        [self resetToView:view];
    }
    return self;
}

- (void)resetToView:(UIView *)view {
    self.containerWidth = view.frame.size.width;
    self.containerHeight = view.frame.size.height;
    self.leftRightGuideLine = 10.0;
    self.upDownGuideline = 10.0;
    self.cursor = CGPointMake(0, 0);
    self.cursorHistory = [[NSMutableArray alloc] init];
    self.lastFrame = view.frame;
}

#pragma mark - Primitives
- (CGPoint)pointOfRect:(CGRect)rect position:(MHViewLayoutPosition)position {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    switch (position) {
        case MHViewLayoutUpperLeft:
            return CGPointMake(x, y);
        case MHViewLayoutUpperMiddle:
            return CGPointMake(x + width / 2, y);
        case MHViewLayoutUpperRight:
            return CGPointMake(x + width, y);
        case MHViewLayoutMiddleLeft:
            return CGPointMake(x, y + height / 2);
        case MHViewLayoutCenter:
            return CGPointMake(x + width / 2, y + height / 2);
        case MHViewLayoutMiddleRight:
            return CGPointMake(x + width, y + height / 2);
        case MHViewLayoutLowerLeft:
            return CGPointMake(x, y + height);
        case MHViewLayoutLowerMiddle:
            return CGPointMake(x + width / 2, y + height);
        case MHViewLayoutLowerRight:
            return CGPointMake(x + width, y + height);
    }
}

- (CGPoint)originOfPoint:(CGPoint)point rectSize:(CGSize)size position:(MHViewLayoutPosition)position {
    CGFloat x = point.x;
    CGFloat y = point.y;
    CGFloat width = size.width;
    CGFloat height = size.height;
    switch (position) {
        case MHViewLayoutUpperLeft:
            return CGPointMake(x, y);
        case MHViewLayoutUpperMiddle:
            return CGPointMake(x - width / 2, y);
        case MHViewLayoutUpperRight:
            return CGPointMake(x - width, y);
        case MHViewLayoutMiddleLeft:
            return CGPointMake(x, y - height / 2);
        case MHViewLayoutCenter:
            return CGPointMake(x - width / 2, y - height / 2);
        case MHViewLayoutMiddleRight:
            return CGPointMake(x - width, y - height / 2);
        case MHViewLayoutLowerLeft:
            return CGPointMake(x, y - height);
        case MHViewLayoutLowerMiddle:
            return CGPointMake(x - width / 2, y - height);
        case MHViewLayoutLowerRight:
            return CGPointMake(x - width, y - height);
    }
}

- (CGRect)validFrameOfContainer:(MHViewLayoutGuideLine)guideline {
    CGFloat x = 0;
    CGFloat width = self.containerWidth;
    if (guideline == MHViewLayoutAllGuideLines || guideline == MHViewLayoutOnlyLeftRightGuideLines) {
        x = self.leftRightGuideLine;
        width -= self.leftRightGuideLine * 2;
    }
    CGFloat y = 0;
    CGFloat height = self.containerHeight;
    if (guideline == MHViewLayoutAllGuideLines || guideline == MHViewLayoutOnlyUpDownGuideLines) {
        y = self.upDownGuideline;
        height -= self.upDownGuideline * 2;
    }
    return CGRectMake(x, y, width, height);
}

- (BOOL) isRightward:(MHViewLayoutDirection)direction {
    return (direction == 1 || direction == 4);
}

- (BOOL) isDownward:(MHViewLayoutDirection)direction {
    return (direction == 3 || direction == 4);
}

- (MHViewLayoutDirection) directionIfRightward:(BOOL)rightward downward:(BOOL)downward {
    if (rightward) {
        if (downward) { return 4; } else { return 1; }
    } else {
        if (downward) { return 3; } else { return 2; }
    }
}

- (MHViewLayoutDirection) directionFromPosition: (MHViewLayoutPosition)position {
    BOOL rightward = (position == MHViewLayoutUpperLeft || position == MHViewLayoutMiddleLeft || position == MHViewLayoutLowerLeft);
    BOOL downward = (position == MHViewLayoutUpperLeft || position == MHViewLayoutUpperMiddle || position == MHViewLayoutUpperRight);
    return [self directionIfRightward:rightward downward:downward];
}

- (CGSize) convertLayoutLength:(CGSize)matrix direction:(MHViewLayoutDirection)direction applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGFloat w_para = matrix.width;
    CGFloat h_para = matrix.height;
    CGRect container = [self validFrameOfContainer:guideline];
    CGFloat w_actual, h_actual;
    
    if (w_para > 1.0) {
        w_actual = w_para;
    } else if (w_para == 0.0) {
        w_actual = 1.0;
    } else if (w_para <= 1.0 && w_para > 0.0) {
        w_actual = container.size.width * w_para;
    } else {
        if ([self isRightward:direction]) {
            w_actual = (container.origin.x + container.size.width) - self.cursor.x;
        } else {
            w_actual = self.cursor.x - container.origin.x;
        }
        if (w_para >= -1.0) {
            w_actual *= (-w_para);
        } else {
            w_actual += w_para;
        }
    }
    
    if (h_para > 1.0) {
        h_actual = h_para;
    } else if (h_para == 0.0) {
        h_actual = 1.0;
    } else if (h_para <= 1.0 && h_para > 0.0) {
        h_actual = container.size.height * h_para;
    } else {
        if ([self isDownward:direction]) {
            h_actual = (container.origin.y + container.size.height) - self.cursor.y;
        } else {
            h_actual = self.cursor.y - container.origin.y;
        }
        if (h_para >= -1.0) {
            h_actual *= (-h_para);
        } else {
            h_actual += h_para;
        }
    }
    
    return CGSizeMake(w_actual, h_actual);
}

- (CGPoint) moveCursor:(CGPoint) point {
    self.cursor = point;
    [self.cursorHistory addObject:[NSValue valueWithCGPoint:point]];
    return point;
}

#pragma mark - Getting Position
- (CGPoint)pointOfPosition:(MHViewLayoutPosition)position {
    return [self pointOfRect:self.lastFrame position:position];
}

- (CGPoint)pointOfContainerPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline {
    return [self pointOfRect:[self validFrameOfContainer:guideline] position:position];
}

- (CGPoint)pointOfView:(UIView *)view AtPosition:(MHViewLayoutPosition)position {
    return [self pointOfRect:view.frame position:position];
}

#pragma mark - Setting Cursor Position
- (CGPoint)moveCursorToPosition:(MHViewLayoutPosition)position {
    return [self moveCursor:[self pointOfRect:self.lastFrame position:position]];
}

- (CGPoint)moveCursorToContainerPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline {
    self.cursor = [self pointOfRect:[self validFrameOfContainer:guideline] position:position];
    return self.cursor;
}

- (CGPoint)moveCursorToView:(UIView *)view AtPosition:(MHViewLayoutPosition)position {
    self.lastFrame = view.frame;
    return [self moveCursor:[self pointOfRect:view.frame position:position]];
}

- (CGPoint)moveCursorToFrame:(CGRect)frame AtPosition:(MHViewLayoutPosition)position {
    self.lastFrame = frame;
    return [self moveCursor:[self pointOfRect:frame position:position]];
}

- (CGPoint)moveCursorHorizontally:(MHViewLayoutLength)x_para rightward:(BOOL)rightward applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGFloat offset = [self convertLayoutLength:CGSizeMake(x_para, NEGLECTED) direction:[self directionIfRightward:rightward downward:false] applyGuideLine:guideline].width;
    CGFloat new_x = self.cursor.x + (rightward ? offset : -offset);
    CGFloat new_y = self.cursor.y;
    return [self moveCursor:CGPointMake(new_x, new_y)];
}

- (CGPoint)moveCursorVertically:(MHViewLayoutLength)y_para downward:(BOOL)downward applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGFloat offset = [self convertLayoutLength:CGSizeMake(NEGLECTED, y_para) direction:[self directionIfRightward:false downward:downward] applyGuideLine:guideline].height;
    CGFloat new_x = self.cursor.x;
    CGFloat new_y = self.cursor.y + (downward ? offset : -offset);
    return [self moveCursor:CGPointMake(new_x, new_y)];
}

- (CGPoint)moveCursorByOffsetX:(MHViewLayoutLength)x_para offsetY:(MHViewLayoutLength)y_para direction:(MHViewLayoutDirection)direction applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGSize offset = [self convertLayoutLength:CGSizeMake(x_para, y_para) direction:direction applyGuideLine:guideline];
    CGFloat new_x = self.cursor.x + ([self isRightward:direction] ? offset.width : -offset.width);
    CGFloat new_y = self.cursor.y + ([self isDownward:direction] ? offset.height : -offset.height);
    return [self moveCursor:CGPointMake(new_x, new_y)];
}

- (CGPoint)simpleMoveX:(CGFloat)x Y:(CGFloat)y {
    return [self moveCursor:CGPointMake(self.cursor.x + x, self.cursor.y + y)];
}

- (CGPoint)revert {
    [self.cursorHistory removeLastObject];
    CGPoint point = [(NSValue *)[self.cursorHistory lastObject] CGPointValue];
    self.cursor = point;
    return point;
}

#pragma mark - Setting Frames
- (CGRect)setView:(UIView *)view width:(MHViewLayoutLength)w_para height:(MHViewLayoutLength)h_para respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGSize size = [self convertLayoutLength:CGSizeMake(w_para, h_para) direction:[self directionFromPosition:position] applyGuideLine:guideline];
    CGPoint origin = [self originOfPoint:self.cursor rectSize:size position:position];
    CGRect rect = (CGRect){origin, size};
    view.frame = rect;
    self.lastFrame = rect;
    return rect;
}

- (CGRect)setView:(UIView *)view width:(MHViewLayoutLength)w_para ratio:(CGFloat)ratio respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGSize size = [self convertLayoutLength:CGSizeMake(w_para, NEGLECTED) direction:[self directionFromPosition:position] applyGuideLine:guideline];
    size.height = size.width * ratio;
    CGPoint origin = [self originOfPoint:self.cursor rectSize:size position:position];
    CGRect rect = (CGRect){origin, size};
    view.frame = rect;
    self.lastFrame = rect;
    return rect;
}

- (CGRect)setView:(UIView *)view height:(MHViewLayoutLength)h_para ratio:(CGFloat)ratio respectToPosition:(MHViewLayoutPosition)position applyGuideLine:(MHViewLayoutGuideLine)guideline {
    CGSize size = [self convertLayoutLength:CGSizeMake(NEGLECTED, h_para) direction:[self directionFromPosition:position] applyGuideLine:guideline];
    size.width = size.height * ratio;
    CGPoint origin = [self originOfPoint:self.cursor rectSize:size position:position];
    CGRect rect = (CGRect){origin, size};
    view.frame = rect;
    self.lastFrame = rect;
    return rect;
}

- (CGRect)setView:(UIView *)view respectToPoint:(CGPoint)point {
    CGSize size = CGSizeMake(ABS(self.cursor.x - point.x), ABS(self.cursor.y - point.y));
    CGPoint origin = CGPointMake(MIN(self.cursor.x, point.x), MIN(self.cursor.y, point.y));
    CGRect rect = (CGRect){origin, size};
    view.frame = rect;
    self.lastFrame = rect;
    return rect;
}

#pragma mark - Flexible Canvas and Value Storage
- (CGSize)resetContainerWithFlexibleWidth:(BOOL)flx_w flexibleHeight:(BOOL)flx_h applyGuideLine:(MHViewLayoutGuideLine)guideline {
    if (flx_w) {
        self.containerWidth = self.cursor.x;
        if (guideline == MHViewLayoutAllGuideLines || guideline == MHViewLayoutOnlyLeftRightGuideLines) self.containerWidth += self.leftRightGuideLine;
    }
    if (flx_h) {
        self.containerHeight = self.cursor.y;
        if (guideline == MHViewLayoutAllGuideLines || guideline == MHViewLayoutOnlyUpDownGuideLines) self.containerHeight += self.upDownGuideline;
    }
    return CGSizeMake(self.containerWidth, self.containerHeight);
}

- (CGFloat)saveContainerWidth:(NSString *)key {
    [MHViewLayoutStorage sharedStorage].data[key] = @(self.containerWidth);
    return self.containerWidth;
}

- (CGFloat)saveContainerHeight:(NSString *)key {
    [MHViewLayoutStorage sharedStorage].data[key] = @(self.containerHeight);
    return self.containerHeight;
}

+ (void)saveValue:(CGFloat)value toKey:(NSString *)key {
    [MHViewLayoutStorage sharedStorage].data[key] = @(value);
}

+ (CGFloat)retrieveValueforKey:(NSString *)key {
    NSNumber *value = [MHViewLayoutStorage sharedStorage].data[key];
    if (value == nil) { return 0.0; } else { return (CGFloat)[value floatValue]; }
}

@end

