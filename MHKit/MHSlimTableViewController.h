//
//  MHSlimTableViewController.h
//  MHKit
//
//  Created by Michael Hong on 5/28/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHTableView.h"

/* MHSlimTableViewController is a dedicated tableview controller
 that manages a MHTableView. (refer to its documentation for further 
 details on MHTableView)
 
 MHSlimTableViewController is developed pretty recently and only used
 by OrderDetailController. The motivation behind this is to seperate
 the monolithic rendering and action handling functions into several
 light and straightforward functions of which each manages a predefined
 selection of rows. 
 
 so the idea here is pretty mush how CSS is used to format HTML contents,
 but much simplified. for every row that the controller inserts into
 MHTableView, an identifier, a counterpart to "class=" in HTML, is specified
 and corresponding render_ or onClick_ selectors will be called on the 
 delegate to perform rendering and action handling logistics. 
 
 note that an identifier is an array of space-seperated class names for
 a tableview row, ex. "caption order_id" (associates two class names,
 "caption" and "order_id" with the row). when MHTableView requests 
 this controller to render this row, two selectors renderCaption and
 renderOrderId will be called on the delegate. You should abide to this
 nomenclature when writing up delegate methods. The underscore lines in
 the class name will be removed and the whole function name will be 
 written in the camel captalized format. 
 
 the seletors corresponding to selection are in the format onClick...
 ex. onClickCaption or onClickOrderId
 
 */

typedef enum MHSlimTableViewCellType_t {
    MHCellEmpty, MHCellText, MHCellDetail, MHCellTitle, MHCellRightText, MHCellMultiLine
} MHSlimTableViewCellType;


@interface MHSlimTableViewController : NSObject <MHTableViewDelegate>

@property (weak) id delegate;
@property CGFloat defaultRowHeight;
@property UIFont *defaultFont;

- (instancetype) initWithDelegate:(id) delegate;

- (void) insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type;
- (void) insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type rowHeight:(CGFloat) height;
- (void) insert:(NSString *)identifier name:(NSString *)name customCell:(NSString *)cellName rowHeight:(CGFloat) height;
- (void) insertSeperator;
- (void) addIdentifier:(NSString *)identifier;

- (MHTableView *) _tableView;
- (void) reloadTableView;
- (void) reloadIdentifier:(NSString *)identifier;
- (void) reloadIdentifier:(NSString *)identifier withRowAnimation:(UITableViewRowAnimation) animation;

@end
