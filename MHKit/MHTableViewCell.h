//
//  MHTableViewCell.h
//  StylePuzzle
//
//  Created by Michael Hong on 3/3/15.
//  Copyright (c) 2015 Tobias Kin Hou Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHView.h"

/* MHTableViewCell provides a set of functions to create and configure
 a UITableView with extra customized contents without subclassing.
 It internally keeps track of the tags of the subviews in the cell's
 contentview and never reallocates them when a cell has been reused.
 
 To create a new subview or reuse the already configured subview,
 simply call createOrReuseView or createOrReuseViewWithCustomConfigure.
 Then call configureOnce to configure these views. Configuration Block will
 only be executed once during the entire reuse cycle. so refactor things
 that only needs to be configued once inside this block.
 
 the layout block is called when layoutSubviews of UITableViewCell is
 called. note that the tableview's delegate method cellForIndexPath might
 not be called when a tableview needs relayout. so putting layout code
 directly in cellForIndexPath might result in misaligned layout.
 so make sure to put all layout code in the layout block. */


@interface MHTableViewCell : UITableViewCell

- (void) configureOnce:(void(^)(void)) configuration_block;
- (void) layout:(void(^)(void)) layout_block;

- (id) createOrReuseView:(Class) className;
- (id) createOrReuseViewWithCustomConfigure:(void(^)(UIView **)) configureBlock;

@end
