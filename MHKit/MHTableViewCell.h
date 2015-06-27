//
//  MHTableViewCell.h
//  StylePuzzle
//
//  Created by Michael Hong on 3/3/15.
//  Copyright (c) 2015 Tobias Kin Hou Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MHKit/MHView.h>

@interface MHTableViewCell : UITableViewCell

/* Configuration Block will only be executed once during the 
 entire reuse cycle. */
- (void) configureOnce:(void(^)(void)) configuration_block;
- (void) layout:(void(^)(void)) layout_block;

- (id) createOrReuseView:(Class) className;
- (id) createOrReuseViewWithCustomConfigure:(void(^)(UIView **)) configureBlock;

@end
