//
//  MHSlimTableViewController.h
//  MHKit
//
//  Created by Michael Hong on 5/28/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHTableView.h"

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
