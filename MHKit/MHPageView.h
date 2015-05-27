//
//  MHPageView.h
//  SPFramework
//
//  Created by Michael Hong on 5/7/15.
//  Copyright (c) 2015 StylePuzzle Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHView.h"

@interface MHPageView : MHView <UIScrollViewDelegate>

@property CGFloat indicatorOffset;

@property (nonatomic, copy) void(^userDidTapPageView)(NSUInteger);
@property (nonatomic, copy) void(^userDidScroll)(NSUInteger);

- (void) initializeView:(void(^)(NSUInteger, UIView *))content_block totalPages:(NSUInteger)pageNum;
- (void) loadImageURLs:(NSArray *)images;

- (void) enableAutoScrollingWithInterval:(NSTimeInterval)time;
- (void) setPageIndicatorHidden: (BOOL) hidden;

- (void) setToPageNumber:(NSUInteger) number animated:(BOOL) animated;
- (UIView *) viewForPageNumber:(NSUInteger) page;

@end
