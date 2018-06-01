//
//  MXKeyboard.h
//  CustomKeyboard
//
//  Created by mxd on 16/1/5.
//  Copyright © 2016年 fengqingsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXKeyboardButton.h"
#import "UITextField+Extension.h"

typedef enum : NSUInteger {
    MXKeyboardOtherTypeAlphabet, // 键盘类型: 字母
    MXKeyboardOtherTypeNumeric,  // 键盘类型: 数字
    MXKeyboardOtherTypeSymbol,   // 键盘类型: 符号
} MXKeyboardOtherType;


@interface MXKeyboard : UIView

@property (nonatomic, weak) UITextField *textField;

/** 打乱按键顺序 */
- (void)exchangeTheOrder;
/** 重置按键顺序 */
- (void)sortTheOrder;
/** 设置为字母键盘 */
- (void)changeToAlphabetPad;
/** 设置为符号键盘 */
- (void)changeToSymbolPad;
/** 设置为数字键盘 */
- (void)changeToNumberPad;
/** 切为数字键盘, 且不能切到其他键盘 */
- (void)changeToNumberPadOnly;

@end
