//
//  MHSlimTableViewController.m
//  MHKit
//
//  Created by Michael Hong on 5/28/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHSlimTableViewController.h"

@interface MHSlimTableViewController()

@property MHTableView *tableView;
@property NSMutableDictionary *presetAttributes;
@property NSMutableDictionary *identifierMap;
@property NSMutableDictionary *indexPathMap;

@end

#define PresetCell_Value1 @"MPCellValue1"
#define PresetCell_Seperator @"SCSeperatorCell"

@implementation MHSlimTableViewController {
    NSUInteger rowN, sectionN;
}

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.tableView = [[MHTableView alloc] initWithStyle:UITableViewStyleGrouped delegate:self];
        self.delegate = delegate;
        [self.tableView addSection:@"*"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        sectionN = 0;
        rowN = 0;
        self.presetAttributes = [[NSMutableDictionary alloc] init];
        self.identifierMap = [[NSMutableDictionary alloc] init];
        
        self.tableView.exteriorSpacing = 5.0;
        self.tableView.sectionSpacing = 0.0;
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.defaultRowHeight = 44.0;
    }
    return self;
}

- (void)insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type {
    if (type == MHCellDetail) {
        [self.tableView addRow:name cellClassString:PresetCell_Value1 height:self.defaultRowHeight];
    } else {
        [self.tableView addRow:name cellClassString:@"UITableViewCell" height:self.defaultRowHeight];
    }
    
    self.presetAttributes[identifier] = @(type);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowN inSection:sectionN];
    self.identifierMap[indexPath] = identifier;
    self.indexPathMap[identifier] = indexPath;
    rowN ++;
}

- (void)insert:(NSString *)identifier name:(NSString *)name customCell:(NSString *)cellName rowHeight:(CGFloat)height {
    [self.tableView addRow:name cellClassString:cellName height:height];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowN inSection:sectionN];
    self.identifierMap[indexPath] = identifier;
    self.indexPathMap[identifier] = indexPath;
    rowN ++;
}

- (void)insertSeperator {
    [self.tableView addRow:nil cellClassString:PresetCell_Seperator height:15.0];
    [self.tableView addSection:@"*"];
    sectionN ++;
    rowN = 0;
}

- (void)renderCellContents:(UITableViewCell *)cell atSection:(NSUInteger)section atRow:(NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.defaultFont) {
        cell.textLabel.font = self.defaultFont;
        cell.detailTextLabel.font = self.defaultFont;
    }
    NSString *identifier = self.identifierMap[indexPath];
    if (identifier) {
        NSNumber *presetType = self.presetAttributes[identifier];
        if (presetType) {
            MHSlimTableViewCellType preset_t = (MHSlimTableViewCellType)[presetType integerValue];
            switch (preset_t) {
                case MHCellTitle:
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                    
                case MHCellRightText:
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
                    break;
                    
                default:
                    break;
            }
        }
        
        NSMutableString *normalizedIdentifier = [[identifier capitalizedString] mutableCopy];
        [normalizedIdentifier replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, [normalizedIdentifier length])];
        SEL action = NSSelectorFromString([NSString stringWithFormat:@"render%@:", normalizedIdentifier]);
        [self performSelectorOnDelegate:action withObject:cell];
    }
}

- (void)registerCellActionsAtSection:(NSUInteger)section atRow:(NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSString *identifier = self.identifierMap[indexPath];
    if (identifier) {
        NSMutableString *normalizedIdentifier = [[identifier capitalizedString] mutableCopy];
        [normalizedIdentifier replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, [normalizedIdentifier length])];
        SEL action = NSSelectorFromString([NSString stringWithFormat:@"onClick%@:", normalizedIdentifier]);
        [self performSelectorOnDelegate:action withObject:nil];
    }
}

- (void) performSelectorOnDelegate:(SEL) action_SEL withObject:(id) obj {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.delegate respondsToSelector:action_SEL]) {
        if (obj) {
            [self.delegate performSelector:action_SEL withObject:obj];
        } else {
            [self.delegate performSelector:action_SEL];
        }
    }
#pragma clang diagnostic pop
}

- (MHTableView *)_tableView {
    return self.tableView;
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)reloadIdentifier:(NSString *)identifier {
    NSIndexPath *indexPath = self.indexPathMap[identifier];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end



