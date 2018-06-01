//
//  MXBlownUpButton.m
//  MXDminxin
//
//  Created by mxd on 16/1/30.
//  Copyright © 2016年 minxin. All rights reserved.
//

#import "MXBlownUpButton.h"

@implementation MXBlownUpButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.size.width * 0.25, 0, contentRect.size.width * 0.5, contentRect.size.height * 0.5);
}


@end
