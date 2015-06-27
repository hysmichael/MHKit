//
//  MHSwitcher.m
//  MHKit
//
//  Created by Michael Hong on 4/29/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHSwitcher.h"

@interface MHSwitcher()

@property UIView *selectedSegmentBackgroundView;
@property NSMutableArray *segmentButtons;

@end

@implementation MHSwitcher

- (instancetype) initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        self.selectedSegmentBackgroundView = [UIView new];
        [self addSubview:self.selectedSegmentBackgroundView];
        self.segmentButtons = [[NSMutableArray alloc] init];
        self.selectedIndex = 0;
        NSUInteger count = 0;
        for (NSString *title in titles) {
            UIButton *button = [UIButton new];
            button.tag = count ++;
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchDown];
            [self.segmentButtons addObject:button];
            [self addSubview:button];
        }
        __weak MHSwitcher *weakSelf = self;
        [self setLayout_block:^(UIView *view, MHViewLayoutManager *lm) {
            for (NSUInteger index = 0; index < count; index ++) {
                [lm setView:weakSelf.segmentButtons[index] width:(1.0 / count) height:1.0 respectToPosition:1 applyGuideLine:0];
                [lm moveCursorToPosition:3];
            }
            weakSelf.selectedSegmentBackgroundView.frame = [(weakSelf.segmentButtons)[weakSelf.selectedIndex] frame];
        }];
    }
    return self;
}

- (void) setToIndex:(NSUInteger)index {
    self.selectedIndex = index;
    UIButton *selectedButton = self.segmentButtons[index];
    self.selectedSegmentBackgroundView.frame = selectedButton.frame;
    
    for (UIButton *button in self.segmentButtons) {
        if (self.textColor) [button setTitleColor:self.textColor forState:UIControlStateNormal];
        if (self.font) [button.titleLabel setFont:self.font];
    }
    
    if (self.selectedTextColor) [selectedButton setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    if (self.selectedBackgroundColor) self.selectedSegmentBackgroundView.backgroundColor = self.selectedBackgroundColor;
}

- (void) buttonDidTap: (id)sender {
    UIButton *destinationButton = (UIButton *)sender;
    UIButton *originButton = self.segmentButtons[self.selectedIndex];
    if (destinationButton == originButton) return;
    self.selectedSegmentBackgroundView.frame = originButton.frame;
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedSegmentBackgroundView.frame = destinationButton.frame;
    }];
    if (self.selectedTextColor) [destinationButton setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    if (self.textColor) [originButton setTitleColor:self.textColor forState:UIControlStateNormal];
    self.selectedIndex = destinationButton.tag;
    if (self.userTapped) self.userTapped(self.selectedIndex);
}

@end
