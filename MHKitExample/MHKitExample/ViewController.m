//
//  ViewController.m
//  MHKitExample
//
//  Created by Michael Hong on 5/15/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "ViewController.h"
#import <MHKit/UIView+MHLayout.h>

@interface ViewController ()

@property UIView *view1;
@property UIView *view2;

@end

@implementation ViewController

- (UIView *)newView {
    UIView *view = [[UIView alloc] init];
    CGFloat hue = (CGFloat)(arc4random_uniform(256)) / 255.0;
    view.backgroundColor = [UIColor colorWithHue:hue saturation:0.8 brightness:0.8 alpha:0.5];
    [self.contentView addSubview:view];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    self.view1 = [self newView];
    self.view2 = [self newView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self example1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) example1 {
    [self.contentView setAsLayoutContainer];
    [MHLayout moveToContainerPosition:2 margin:1];
    [MHLayout simpleMoveX:-5.0 Y:0.0];
    [self.view1 layoutWidth:-1.0 height:0.5 anchor:3 margin:1];
    [MHLayout revert];
    [MHLayout simpleMoveX:5.0 Y:0.0];
    [self.view2 layoutWidth:-1.0 height:0.5 anchor:1 margin:1];
}

@end
