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

/* callback that responds to user interactions */
@property (nonatomic, copy) void(^userDidTapPageView)(NSUInteger);
@property (nonatomic, copy) void(^userDidScroll)(NSUInteger);

/* MHPageView is a horizontally scrollling, paginated scroll view. 
 to configure the contents for MHPageView, one should call initializeView
 that tells the MHPageView the total number of pages that it should display.
 Then when coming to display, MHPageView will call the display callback to
 prompt the client configure each page properly.
 
 Moreover, MHPageView provides a convinient method for setting up a
 series of pages that display images. One can call loadImageURLs to set up
 such a MHPageView and all image urls will be loaded when necessary. */

- (void) initializeView:(void(^)(NSUInteger, UIView *))content_block totalPages:(NSUInteger)pageNum;
- (void) loadImageURLs:(NSArray *)images;

- (void) enableAutoScrollingWithInterval:(NSTimeInterval)time;
- (void) setPageIndicatorHidden: (BOOL) hidden;

- (void) setToPageNumber:(NSUInteger) number animated:(BOOL) animated;
- (UIView *) viewForPageNumber:(NSUInteger) page;

@end
