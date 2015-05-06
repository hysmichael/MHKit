//
//  UITableViewCellExtension.h
//  MHKit
//
//  Created by Michael Hong on 3/13/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell_Auto : UITableViewCell
- (CGFloat) height;
@end

@interface UITableViewCell_Editable : UITableViewCell
- (id) formValue;
- (void) formIsRequired:(BOOL)required;
@end
