//
//  MHImageViewer.m
//  MHKit
//
//  Created by Michael Hong on 5/26/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHImageViewer.h"
#import "MHPageView.h"
#import "UIView+MHKit.h"
#import <UIImageView+WebCache.h>

#define IMAGE_VIEW_TAG 1
#define SCROLL_VIEW_TAG_BASE 100

@interface MHImageViewer ()

@property UIView *layerView;
@property MHPageView *pageView;
@property NSArray *dataSource;
@property UIImageView *transitionView;
@property (weak) UIView *interfaceView;

@property (weak) UIScrollView *scrollViewInActive;
@property NSInteger lastActiveBoundsChangeNotificationID;

@end

@implementation MHImageViewer

- (instancetype)initWithInterfaceView:(UIView *)view imageData:(NSArray *)data {
    self = [super init];
    if (self) {
        CGRect screeenBounds = [[UIScreen mainScreen] bounds];
        self.pageView = [[MHPageView alloc] init];
        self.pageView.frame = screeenBounds;
        [self.pageView layoutSubviews];
        [self.pageView initializeView:^(NSUInteger pageNum, UIView *view) {
            UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:view.bounds];
            innerScrollView.contentSize = view.bounds.size;
            innerScrollView.delegate = self;
            innerScrollView.tag = pageNum + SCROLL_VIEW_TAG_BASE;
            innerScrollView.maximumZoomScale = 1.5;
            innerScrollView.showsHorizontalScrollIndicator = false;
            innerScrollView.showsVerticalScrollIndicator = false;
            [view addSubview:innerScrollView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = IMAGE_VIEW_TAG;
            [innerScrollView addSubview:imageView];
        } totalPages:[data count]];
        [self.pageView setPageIndicatorHidden:true];
        [self setUpPageViewActions];
        self.pageView.alpha = 0.0;
        
        self.layerView = [[UIView alloc] init];
        self.layerView.frame = screeenBounds;
        self.layerView.backgroundColor = [UIColor blackColor];
        self.layerView.alpha = 0.0;
        
        self.dataSource = data;
        self.interfaceView = view;
    }
    return self;
}

- (void)registerImageView:(UIImageView *)imageView pageNumber:(NSInteger) number {
    [imageView addTapTarget:self selector:@selector(userDidTapImageView:)];
    imageView.tag = number;
}

- (void)userDidTapImageView: (UITapGestureRecognizer *)sender {
    UIImageView *imageView = (UIImageView *)(sender.view);
    self.transitionView = [[UIImageView alloc] init];
    self.transitionView.image = imageView.image;
    self.transitionView.contentMode = imageView.contentMode;
    CGRect windowFrame = [imageView.superview convertRect:imageView.frame toView:nil];
    self.transitionView.frame = windowFrame;
    
    UIView *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:self.layerView];
    [mainWindow addSubview:self.pageView];
    [mainWindow addSubview:self.transitionView];
    
    NSInteger pageNumber = imageView.tag;
    [self.pageView setToPageNumber:pageNumber animated:false];
    [self loadImageOnPage:pageNumber withExistingImage:self.transitionView.image];
    [UIView animateWithDuration:0.3 animations:^{
        self.transitionView.frame = [mainWindow bounds];
        self.layerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.pageView.alpha = 1.0;
        [self.transitionView removeFromSuperview];
    }];
    [self loadAdjacentImagesToPage:pageNumber];
}

- (void) loadImageOnPage: (NSUInteger) number withExistingImage:(UIImage *) image {
    UIScrollView *scrollView = (UIScrollView *)[[self.pageView viewForPageNumber:number] viewWithTag:number + SCROLL_VIEW_TAG_BASE];
    UIImageView *backgroundImageView = (UIImageView *)[scrollView viewWithTag:IMAGE_VIEW_TAG];
    if (scrollView.zoomScale > 1.0) [scrollView setZoomScale:1.0 animated:true];
    if (!backgroundImageView.image) {
        if (image) {
            backgroundImageView.image = image;
        } else {
            id object = self.dataSource[number];
            if ([object isKindOfClass:[UIImage class]]) backgroundImageView.image = object;
            if ([object isKindOfClass:[NSString class]]) [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:object]];
        }
    }
}

- (void) loadAdjacentImagesToPage:(NSUInteger) number {
    if (number > 0) [self loadImageOnPage:number - 1 withExistingImage:nil];
    if (number < [self.dataSource count] - 1) [self loadImageOnPage:number + 1 withExistingImage:nil];
}

- (void) setUpPageViewActions {
    __weak MHImageViewer *weakSelf = self;
    [self.pageView setUserDidTapPageView:^(NSUInteger pageNumber) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.pageView.alpha = 0.0;
            weakSelf.layerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf.pageView removeFromSuperview];
            [weakSelf.transitionView removeFromSuperview];
        }];
    }];
    [self.pageView setUserDidScroll:^(NSUInteger pageNumber) {
        [weakSelf loadAdjacentImagesToPage:pageNumber];
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:IMAGE_VIEW_TAG];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewInActive != scrollView) {
        self.scrollViewInActive = scrollView;
        self.lastActiveBoundsChangeNotificationID = 0;
    }
    self.lastActiveBoundsChangeNotificationID ++;
    NSInteger currentNotificationID = self.lastActiveBoundsChangeNotificationID;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (currentNotificationID == self.lastActiveBoundsChangeNotificationID) {
            self.lastActiveBoundsChangeNotificationID = 0;
            [self resetScrollViewOffset:scrollView withBoundsCheck:NO];
        }
    });
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self resetScrollViewOffset:scrollView withBoundsCheck:YES];
}

- (void)resetScrollViewOffset:(UIScrollView *)scrollView withBoundsCheck:(BOOL) boundsCheck {
    CGPoint offset = scrollView.contentOffset;
    CGSize contentSize = scrollView.contentSize;
    CGFloat scale = scrollView.zoomScale;
    if (scale > scrollView.maximumZoomScale) scale = scrollView.maximumZoomScale;
    NSInteger pageNum = scrollView.tag - SCROLL_VIEW_TAG_BASE;
    if ((offset.x < 0 && pageNum == 0) || (offset.x + scrollView.bounds.size.width > contentSize.width && pageNum == [self.dataSource count] - 1)) {
        if (pageNum == 0) {
            offset.x = 0;
        } else {
            offset.x = contentSize.width - scrollView.bounds.size.width;
        }
    } else {
        if (boundsCheck) {
            if (offset.x < 0 || offset.x + scrollView.bounds.size.width > contentSize.width) return;
        }
    }
    offset.y = (contentSize.height * (1 - 1/scale)) / 2;
    [scrollView setContentOffset:offset animated:YES];
}

@end
