//
//  ActionlistView.m
//  MHKit
//
//  Created by Michael Hong on 1/23/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "MHTableView.h"
#import "UITableViewCellExtension.h"

#define kMinimalHeight 0.0001f

@class ALSection;
@class ALRow;

@interface ALSection : NSObject
@property NSString *name;
@property NSMutableArray *data;
@property int section_number;
- (instancetype)initWithName:(NSString *)name index:(int) index;
- (void) addRow:(ALRow *) row;
@end

@interface ALRow : NSObject
@property NSString *name;
@property NSString *cellClass;
@property CGFloat height;
@property int row_number;
@property id formValue;
- (instancetype)initWithName:(NSString *)name index:(int) index;
@end

@implementation ALSection
- (instancetype)initWithName:(NSString *)name index:(int) index {
    self = [super init];
    if (self) {
        self.name = name;
        self.section_number = index;
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)addRow:(ALRow *)row { [self.data addObject:row]; }
@end

@implementation ALRow
- (instancetype)initWithName:(NSString *)name index:(int)index {
    self = [super init];
    if (self) {
        self.name = name;
        self.row_number = index;
        self.height = 44.0;
    }
    return self;
}
@end


@implementation MHTableView {
    NSMutableArray *data;
    int section_i, row_i;
    BOOL keyboardOpen;
}

- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id<MHTableViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectZero style:style]) {
        data = [[NSMutableArray alloc] init];
        section_i = 0;
        row_i = 0;
        keyboardOpen = false;
        self.showSectionHeader = false;
        self.mh_delegate = delegate;
        
        self.delegate = self;
        self.dataSource = self;
        
        self.sectionSpacing = 15.0f;
        self.exteriorSpacing = 30.0f;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self ready];
}

- (void) addSection:(NSString *)name {
    ALSection *newSection = [[ALSection alloc] initWithName:name index:section_i];
    [data addObject:newSection];
    section_i++;
    row_i = 0;
}

- (void) addRow:(NSString *)name {
    [self addRow:name cellClassString:nil height:0.0];
}

- (void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString {
    [self addRow:name cellClassString:cellClassString height:0.0];
}

- (void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString height:(CGFloat)height {
    ALRow *newRow = [[ALRow alloc] initWithName:name index:row_i];
    newRow.cellClass = (cellClassString ? cellClassString : @"UITableViewCell");
    newRow.height = (height > 0) ? height : 44.0;
    [(ALSection *)(data[section_i - 1]) addRow:newRow];
    row_i++;
}

- (Class)objcOrSwiftClassFromName:(NSString *)name {
    Class cellClass = NSClassFromString(name);
    if (cellClass) return cellClass;
    NSString *className = name;
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *swiftClassStringName = [NSString stringWithFormat:@"_TtC%lu%@%lu%@", (unsigned long)[appName length], appName, (unsigned long)[className length], className];
    return NSClassFromString(swiftClassStringName);
}

- (void)ready {
    for (ALSection *aSection in data)
        for (ALRow *aRow in aSection.data) {
            Class cellClass = [self objcOrSwiftClassFromName:aRow.cellClass];
            if (cellClass) [self registerClass:cellClass forCellReuseIdentifier:aRow.cellClass];
        }
    UITapGestureRecognizer *tap_recognizor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllEditingViews)];
    tap_recognizor.cancelsTouchesInView = false;
    [self addGestureRecognizer:tap_recognizor];
}

- (ALRow *)rowAtIndexPath: (NSIndexPath *) indexPath {
    return ((ALSection *)(data[indexPath.section])).data[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rowAtIndexPath:indexPath].height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((ALSection *)(data[section])).data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat spacing;
    if (section == 0) {
        spacing = self.exteriorSpacing;
    } else {
        spacing = self.sectionSpacing;
    }
    if ([self tableView:tableView titleForHeaderInSection:section]) spacing += 25.0f;
    if (spacing == 0) spacing = kMinimalHeight;
    return spacing;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [data count] - 1) return self.exteriorSpacing;
    return kMinimalHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALRow *aRow = [self rowAtIndexPath:indexPath];
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:aRow.cellClass forIndexPath:indexPath];
    if (![aRow.name hasSuffix:@"*"]) cell.textLabel.text = aRow.name;
    if ([aRow.cellClass hasSuffix:@"_Editable"]) {
        [(UITableViewCell_Editable *)cell formIsRequired:[aRow.name hasSuffix:@"!"]];
        if ([aRow.name hasSuffix:@"!"]) cell.textLabel.text = [aRow.name substringToIndex:[aRow.name length] - 1];
    }
    if (self.mh_delegate && [self.mh_delegate respondsToSelector:@selector(renderCellContents:atSection:atRow:)])
        [self.mh_delegate renderCellContents:cell atSection:indexPath.section atRow:indexPath.row];
    if ([aRow.cellClass hasSuffix:@"_Auto"]) {
        CGFloat updatedHeight = ((UITableViewCell_Auto *)cell).height;
        if (aRow.height != updatedHeight) {
            aRow.height = updatedHeight;
            [tableView reloadData];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self resignAllEditingViews];
    if (self.mh_delegate && [self.mh_delegate respondsToSelector:@selector(registerCellActionsAtSection:atRow:)])
        [self.mh_delegate registerCellActionsAtSection:indexPath.section atRow:indexPath.row];
    [self deselectRowAtIndexPath:indexPath animated:true];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.showSectionHeader) return nil;
    ALSection *aSection = data[section];
    if (![aSection.name hasSuffix:@"*"]) return aSection.name;
    return nil;
}

- (void) activateFirstEditingView {
    for (ALSection *aSection in data)
        for (ALRow *aRow in aSection.data)
            if ([aRow.cellClass hasSuffix:@"_Editable"]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:aRow.row_number inSection:aSection.section_number];
                [(UITableViewCell_Editable *)([self cellForRowAtIndexPath:indexPath]) becomeFirstResponder];
                return;
            }
}

- (void) resignAllEditingViews {
    for (ALSection *aSection in data)
        for (ALRow *aRow in aSection.data)
            if ([aRow.cellClass hasSuffix:@"_Editable"]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:aRow.row_number inSection:aSection.section_number];
                [(UITableViewCell_Editable *)([self cellForRowAtIndexPath:indexPath]) resignFirstResponder];
            }
}

- (BOOL) validateAllEditingViews {
    for (ALSection *aSection in data)
        for (ALRow *aRow in aSection.data)
            if ([aRow.cellClass hasSuffix:@"_Editable"] && [aRow.name hasSuffix:@"!"]) {
                if ([self postEditValueForEditableCellAtSection:aSection.section_number atRow:aRow.row_number] == nil) return false;
            }
    return true;
}

- (id) postEditValueForEditableCellAtSection:(NSInteger)section atRow:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    ALRow *aRow = [self rowAtIndexPath:indexPath];
    if ([aRow.cellClass hasSuffix:@"_Editable"]) {
        if ([[self indexPathsForVisibleRows] containsObject:indexPath]) {
            // a cell is visible, directly use the value in the cell
            return [(UITableViewCell_Editable *)([self cellForRowAtIndexPath:indexPath]) formValue];
        } else {
            // a cell is invisible, use the stored value
            return aRow.formValue;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ALRow *aRow = [self rowAtIndexPath:indexPath];
    if ([aRow.cellClass hasSuffix:@"_Editable"]) aRow.formValue = [(UITableViewCell_Editable *)cell formValue];
}

@end
