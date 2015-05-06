//
//  ActionListViewController.h
//  MHKit
//
//  Created by Michael Hong on 1/23/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHTableViewDelegate <NSObject>
@optional
- (void) renderCellContents: (UITableViewCell *)cell atSection:(NSUInteger)section atRow:(NSUInteger)row;
- (void) registerCellActionsAtSection:(NSUInteger)section atRow:(NSUInteger)row;
@end

@interface MHTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

-(instancetype) initWithStyle:(UITableViewStyle)style delegate:(id<MHTableViewDelegate>)delegate;

@property (weak) id<MHTableViewDelegate> mh_delegate;
@property BOOL showSectionHeader;

-(void) addSection:(NSString *)name;

-(void) addRow:(NSString *)name;
-(void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString;
-(void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString height:(CGFloat)height;

-(void) ready;

-(void) activateFirstEditingView;
-(void) resignAllEditingViews;
-(BOOL) validateAllEditingViews;
-(id)   postEditValueForEditableCellAtSection:(NSInteger)section atRow:(NSInteger)row;

@end
