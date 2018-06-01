//
//  MXKeyboardButton.h
//  CustomKeyboard
//
//  Created by mxd on 16/1/5.
//  Copyright © 2016年 fengqingsong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MXKeyButtonTypeDone,   // 按键类型：完成
    MXKeyButtonTypeDel,    // 按键类型：删除
    MXKeyButtonTypeNum,    // 按键类型：数字
    MXKeyButtonTypeSpace,  // 按键类型：空格
    MXKeyButtonTypeOther   // 按键类型：其他
} MXKeyButtonType;


@interface MXKeyboardButton : UIButton

@property (nonatomic, assign) MXKeyButtonType type;

- (instancetype)initWithType:(MXKeyButtonType)type;

@end
