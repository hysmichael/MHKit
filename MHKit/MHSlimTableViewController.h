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
    MHCellText, MHCellDetail, MHCellTitle, MHCellRightText
} MHSlimTableViewCellType;


@interface MHSlimTableViewController : NSObject <MHTableViewDelegate>

@property (weak) id delegate;
@property CGFloat defaultRowHeight;
@property UIFont *defaultFont;

- (instancetype) initWithDelegate:(id) delegate;

- (void) insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type;
- (void) insert:(NSString *)identifier name:(NSString *)name customCell:(NSString *)cellName rowHeight:(CGFloat) height;
- (void) insertSeperator;

- (MHTableView *) _tableView;
- (void) reloadTableView;
- (void) reloadIdentifier:(NSString *)identifier;


@end
