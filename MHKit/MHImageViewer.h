//
//  MHImageViewer.h
//  MHKit
//
//  Created by Michael Hong on 5/26/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHImageViewer : NSObject <UIScrollViewDelegate>

- (instancetype) initWithInterfaceView:(UIView *) view imageData: (NSArray *) data;
- (void)registerImageView:(UIImageView *)imageView pageNumber:(NSInteger) number;

@end
