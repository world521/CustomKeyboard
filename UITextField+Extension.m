//
//  UITextField+Extension.m
//  CustomKeyboard
//
//  Created by mxd on 16/1/6.
//  Copyright © 2016年 fengqingsong. All rights reserved.
//

#import "UITextField+Extension.h"
#import <objc/runtime.h>
#import "MXKeyboard.h"

@implementation UITextField (Extension)

+ (void)load {
    SEL originBFSel = @selector(becomeFirstResponder);
    SEL swizzleBFSel = @selector(becomeFirstResponder_bd_swizzle);
    Method originM = class_getInstanceMethod(self, originBFSel);
    Method swizzleM = class_getInstanceMethod(self, swizzleBFSel);
    BOOL addSuccess = class_addMethod(self, originBFSel, method_getImplementation(swizzleM), method_getTypeEncoding(swizzleM));
    if (addSuccess) {
        class_addMethod(self, swizzleBFSel, method_getImplementation(originM), method_getTypeEncoding(originM));
    } else {
        method_exchangeImplementations(originM, swizzleM);
    }
}

- (BOOL)becomeFirstResponder_bd_swizzle {
    BOOL becomeF = [self becomeFirstResponder_bd_swizzle];
    if (becomeF && [self.inputView isKindOfClass:[MXKeyboard class]]) {
        MXKeyboard *kb = (MXKeyboard *)self.inputView;
        kb.textField = self;
    }
    return becomeF;
}

/**
 *  修改textField中的文字(会调用代理方法/调用target的UIControlEvent方法/发出通知)
 */
- (void)changetext:(NSString *)text {
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = self.selectedTextRange.start;
    UITextPosition *end = self.selectedTextRange.end;
    NSInteger startIndex = [self offsetFromPosition:begin toPosition:start];
    NSInteger endIndex = [self offsetFromPosition:begin toPosition:end];
    
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        BOOL shouldChange = [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(startIndex, endIndex - startIndex) replacementString:text];
        if (!shouldChange) {
            return;
        }
    }
    
    // 将输入框中的文字分成两部分
    NSString *originText = self.text;
    NSString *part1 = [originText substringToIndex:startIndex];
    NSString *part2 = [originText substringFromIndex:endIndex];
    
    NSInteger offset;
    if ([text isEqualToString:@""]) {
        if (startIndex == endIndex) { //只删除一个字符
            if (startIndex == 0) {
                return;
            }
            offset = -1;
            part1 = [part1 substringToIndex:part1.length - 1];
        } else {
            offset = 0;
        }
    } else {
        offset = text.length;
    }
    
    NSString *newText = [NSString stringWithFormat:@"%@%@%@", part1, text, part2];
    self.text = newText;
    
    //重置光标位置
    UITextPosition *now = [self positionFromPosition:start offset:offset];
    self.selectedTextRange = [self textRangeFromPosition:now toPosition:now];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self userInfo:nil];
    
    // 调用target对应的UIControlEvents方法
    NSSet *targets = [self allTargets];
    for (NSObject *target in targets) {
        NSArray<NSString *> *actions = [self actionsForTarget:target forControlEvent:UIControlEventEditingChanged];
        for (NSString *action in actions) {
            if ([target respondsToSelector:NSSelectorFromString(action)]) {
                if ([action containsString:@":"]) {
                    [target performSelector:NSSelectorFromString(action) withObject:self];
                } else {
                    [target performSelector:NSSelectorFromString(action) withObject:nil];
                }
            }
        }
    }
}

@end
