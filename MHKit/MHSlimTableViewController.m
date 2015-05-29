//
//  MHSlimTableViewController.m
//  MHKit
//
//  Created by Michael Hong on 5/28/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHSlimTableViewController.h"
#import "MHTableViewCell.h"
#import "UITableViewCellExtension.h"

@interface MHSlimTableViewController()

@property MHTableView *tableView;
@property NSMutableDictionary *presetAttributes;
@property NSMutableDictionary *identifierMap;
@property NSMutableDictionary *indexPathMap;

@end

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
        self.indexPathMap = [[NSMutableDictionary alloc] init];
        
        self.tableView.exteriorSpacing = 5.0;
        self.tableView.sectionSpacing = 0.0;
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.defaultRowHeight = 44.0;
    }
    return self;
}

- (NSIndexPath *) linkIdentifier: (NSString *)identifier {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowN inSection:sectionN];
    if (identifier) {
        NSArray *tokens = [identifier componentsSeparatedByString:@" "];
        for (NSString *token in tokens) {
            if (self.indexPathMap[token]) {
                NSMutableArray *indexPathArray = (NSMutableArray *)self.indexPathMap[token];
                [indexPathArray addObject:indexPath];
            } else {
                self.indexPathMap[token] = [NSMutableArray arrayWithObject:indexPath];
            }
        }
        NSMutableArray *normalizedTokens = [NSMutableArray array];
        for (NSString *token in tokens) {
            NSArray *subTokens = [token componentsSeparatedByString:@"_"];
            NSMutableString *normalizedToken = [NSMutableString string];
            for (NSString *subToken in subTokens) {
                [normalizedToken appendString:[subToken capitalizedString]];
            }
            [normalizedTokens addObject:normalizedToken];
        }
        if (self.identifierMap[indexPath]) {
            [self.identifierMap[indexPath] addObjectsFromArray:normalizedTokens];
        } else {
            self.identifierMap[indexPath] = normalizedTokens;
        }
    }
    return indexPath;
}

- (void)insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type {
    [self insert:identifier name:name presetType:type rowHeight:self.defaultRowHeight];
}

- (void)insert:(NSString *)identifier name:(NSString *)name presetType:(MHSlimTableViewCellType)type rowHeight:(CGFloat)height {
    if (type == MHCellEmpty) {
        [self.tableView addRow:name cellClassString:@"MHTableViewCell" height:height];
    } else if (type == MHCellDetail) {
        [self.tableView addRow:name cellClassString:@"UITableViewCellValue1" height:height];
    } else {
        [self.tableView addRow:name cellClassString:@"UITableViewCell" height:height];
    }
    
    NSIndexPath *indexPath = [self linkIdentifier:identifier];
    self.presetAttributes[indexPath] = @(type);
    rowN ++;
}

- (void)insert:(NSString *)identifier name:(NSString *)name customCell:(NSString *)cellName rowHeight:(CGFloat)height {
    [self.tableView addRow:name cellClassString:cellName height:height];
    [self linkIdentifier:identifier];
    rowN ++;
}

- (void)insertSeperator {
    [self.tableView addRow:nil cellClassString:PresetCell_Seperator height:15.0];
    [self.tableView addSection:@"*"];
    sectionN ++;
    rowN = 0;
}

- (void)addIdentifier:(NSString *)identifier {
    rowN --;
    [self linkIdentifier:identifier];
    rowN ++;
}

- (void)renderCellContents:(UITableViewCell *)cell atSection:(NSUInteger)section atRow:(NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.defaultFont) {
        cell.textLabel.font = self.defaultFont;
        cell.detailTextLabel.font = self.defaultFont;
    }
    NSArray *identifiers = self.identifierMap[indexPath];
    if (identifiers) {
        NSNumber *presetType = self.presetAttributes[indexPath];
        if (presetType) {
            MHSlimTableViewCellType preset_t = (MHSlimTableViewCellType)[presetType integerValue];
            switch (preset_t) {
                case MHCellTitle:
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                    
                case MHCellRightText:
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
                    break;
                    
                case MHCellMultiLine:
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    
                default:
                    break;
            }
        }
        
        for (NSString *identifier in identifiers) {
            SEL action = NSSelectorFromString([NSString stringWithFormat:@"render%@:", identifier]);
            [self performSelectorOnDelegate:action withObject:cell];
        }
    }
}

- (void)registerCellActionsAtSection:(NSUInteger)section atRow:(NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *identifiers = self.identifierMap[indexPath];
    if (identifiers) {
        for (NSString *identifier in identifiers) {
            SEL action = NSSelectorFromString([NSString stringWithFormat:@"onClick%@", identifier]);
            [self performSelectorOnDelegate:action withObject:nil];
        }
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
    [self reloadIdentifier:identifier withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadIdentifier:(NSString *)identifier withRowAnimation:(UITableViewRowAnimation)animation {
    NSMutableArray *allIndexPaths = [NSMutableArray array];
    NSArray *tokens = [identifier componentsSeparatedByString:@" "];
    for (NSString *token in tokens) {
        if (self.indexPathMap[token]) {
            [allIndexPaths addObjectsFromArray:self.indexPathMap[token]];
        }
    }
    if ([allIndexPaths count] > 0) {
        [self.tableView reloadRowsAtIndexPaths:allIndexPaths withRowAnimation:animation];
    }
}

@end



