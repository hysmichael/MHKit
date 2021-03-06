//
//  UITableViewCellExtension.m
//  MHKit
//
//  Created by Michael Hong on 3/13/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "UITableViewCellExtension.h"

@implementation UITableViewCell_Auto
- (CGFloat)height { return 44.0; }
@end


@implementation UITableViewCell_Editable
- (id)formValue { return nil; }
- (void)formIsRequired:(BOOL)required {}
@end


@implementation UITableViewCellValue1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    return self;
}

@end