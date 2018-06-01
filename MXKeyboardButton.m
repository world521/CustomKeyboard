//
//  MXKeyboardButton.m
//  CustomKeyboard
//
//  Created by mxd on 16/1/5.
//  Copyright © 2016年 fengqingsong. All rights reserved.
//

#import "MXKeyboardButton.h"

@implementation MXKeyboardButton

- (instancetype)initWithType:(MXKeyButtonType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

@end
