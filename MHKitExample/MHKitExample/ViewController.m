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

@property UITextView *view1;
@property UITextView *view2;
@property UITextView *view3;
@property UITextView *view4;
@property UITextView *view5;

@property int counter;

@end

@implementation ViewController

- (UITextView *)newView {
    self.counter ++;
    UITextView *view = [[UITextView alloc] init];
    CGFloat hue = (CGFloat)(arc4random_uniform(256)) / 255.0;
    UIColor *color =  [UIColor colorWithHue:hue saturation:0.8 brightness:0.8 alpha:0.5];
    view.backgroundColor = [color colorWithAlphaComponent:.1];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1.0f;
    view.text = [NSString stringWithFormat:@"View %d", self.counter];
    view.textColor = [color colorWithAlphaComponent:1.0];
    view.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:view];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.counter = 0;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    self.view1 = [self newView];
    self.view2 = [self newView];
    self.view3 = [self newView];
    self.view4 = [self newView];
    self.view5 = [self newView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self example2];
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

- (void) example2 {
    [self.contentView setAsLayoutContainer];
    
    /* layout view1 and its subviews */
    [self.view1 layoutWidth:1.0 height:100.0 anchor:1 margin:0];
    [MHLayout pushLayoutSubcontainer:self.view1];
    [MHLayout setXMargin:20.0];
    [MHLayout setYMargin:10.0];
    [MHLayout moveToContainerPosition:1 margin:1];
    [self.view4 layoutRatio:1.0 height:1.0 anchor:1 margin:1];
    [MHLayout moveToPosition:3];
    [MHLayout simpleMoveX:20.0 Y:0.0];
    [self.view5 layoutWidth:-1.0 height:1.0 anchor:1 margin:1];
    [MHLayout popLayoutSubcontainer];
    
    /* Layout the remaining views */
    [MHLayout moveToPosition:8];
    [MHLayout setXMargin:20.0];
    [self.view2 layoutWidth:1.0 height:-50.0 anchor:2 margin:MHMarginEdgeX];
    [MHLayout moveToPosition:8];
    [self.view3 layoutWidth:1.0 height:-1.0 anchor:2 margin:0];
}

@end
