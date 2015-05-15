//
//  MHPageView.m
//  SPFramework
//
//  Created by Michael Hong on 5/7/15.
//  Copyright (c) 2015 StylePuzzle Inc. All rights reserved.
//

#import "MHPageView.h"
#import "MHViewLayoutManager.h"

@interface MHPageView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property NSTimer *timer;

@property BOOL timerEnabled;

@end

@implementation MHPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = false;
        
        [self addSubviews:@[self.scrollView, self.pageControl]];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
        tapRecognizer.numberOfTapsRequired = 1;
        [tapRecognizer addTarget:self action:@selector(userTapped)];
        [self.scrollView addGestureRecognizer:tapRecognizer];
        self.scrollView.userInteractionEnabled = true;
        
        __weak MHPageView *weakSelf = self;
        [self setLayout_block:^(UIView *view, MHViewLayoutManager *lm) {
            weakSelf.scrollView.frame = view.bounds;
            [lm moveCursorToContainerPosition:8 applyGuideLine:0];
            [lm simpleMoveX:0.0 Y:-weakSelf.indicatorOffset];
            [lm setView:weakSelf.pageControl width:1.0 height:36.0 respectToPosition:8 applyGuideLine:1];
        }];
        
        self.timerEnabled = false;
    }
    return self;
}

- (void) initializeView:(void (^)(NSUInteger, UIView *))content_block totalPages:(NSUInteger)pageNum {
    
    // clean up from reuseable cells
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    self.pageControl.numberOfPages = pageNum;
    self.pageControl.currentPage = 0;
    [self.scrollView setContentOffset: CGPointMake(0.0, 0.0)];
    
    if (pageNum == 1){
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    
    for (int i=0; i < pageNum; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i) * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        content_block(i, view);
        [self.scrollView addSubview:view];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * pageNum, self.scrollView.frame.size.height)];
}


- (void)userTapped {
    if (self.userDidTapPageView) {
        self.userDidTapPageView(self.pageControl.currentPage);
    }
}

- (void)enableAutoScrollingWithInterval:(NSTimeInterval)time {
    if (!self.timerEnabled) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
        self.timerEnabled = true;
    }
}


- (void)scrollingTimer {
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    
    // calculate next page to display
    int nextPage = (int)(contentOffset / self.scrollView.frame.size.width) + 1 ;
    
    if (nextPage != self.pageControl.numberOfPages) {
        [self.scrollView scrollRectToVisible:CGRectMake(nextPage * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        self.pageControl.currentPage = nextPage;
    } else {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        self.pageControl.currentPage = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    float xPos = scrollView.contentOffset.x;
    
    // calculate the page we are on based on x coordinate position and width of scroll view
    self.pageControl.currentPage = (lround(xPos / width));
    
    // stop auto scrolling when user manutally scrolls
    [self.timer invalidate];
}


@end

