//
//  MHTableViewCell.m
//  StylePuzzle
//
//  Created by Michael Hong on 3/3/15.
//  Copyright (c) 2015 Tobias Kin Hou Lei. All rights reserved.
//

#import "MHTableViewCell.h"

@interface MHTableViewCell()

@property (copy) void(^layout_block)(void);
@property NSInteger tagCounter;
@property BOOL configured;

@end

@implementation MHTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font         = [UIFont systemFontOfSize:self.textLabel.font.pointSize];
        self.detailTextLabel.font   = [UIFont systemFontOfSize:self.detailTextLabel.font.pointSize];
        self.tagCounter = 0;
        self.configured = false;
    }
    return self;
}

- (void)prepareForReuse {
    self.tagCounter = 0;
}

- (void)configureOnce:(void (^)(void))configuration_block {
    if (!self.configured) {
        if (configuration_block) configuration_block();
    }
}

- (id)createOrReuseView:(Class)className {
    self.tagCounter++;
    UIView * view = [self.contentView viewWithTag:self.tagCounter];
    if (!view) {
        view = [[className alloc] init];
        view.tag = self.tagCounter;
        [self.contentView addSubview:view];
    }
    return view;
}

- (id)createOrReuseViewWithCustomConfigure:(void (^)(UIView *__autoreleasing *))configureBlock {
    self.tagCounter++;
    UIView * view = [self.contentView viewWithTag:self.tagCounter];
    if (!view) {
        configureBlock(&view);
        view.tag = self.tagCounter;
        [self.contentView addSubview:view];
    }
    return view;
}

- (void)layout:(void (^)(void))layout_block {
    self.layout_block = layout_block;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layout_block) self.layout_block();
}

@end
