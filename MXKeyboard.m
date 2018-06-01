//
//  MXKeyboard.m
//  CustomKeyboard
//
//  Created by mxd on 16/1/5.
//  Copyright © 2016年 fengqingsong. All rights reserved.
//

#import "MXKeyboard.h"
#import "MXBlownUpButton.h"

#define KEYBOARD_BACKGROUND_COLOR [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]
#define ALPHABET_COLOR [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]

#define KEY_BOARD_HEIGHT 258.0
#define KEY_BOARD_TOOL_HEIGHT 40.0
#define KEY_BOARD_PAD_HEIGHT (KEY_BOARD_HEIGHT-KEY_BOARD_TOOL_HEIGHT)

#define ALPHA_COLUMN_MARGIN ([UIScreen mainScreen].bounds.size.width == 320 ? 5.0 : 9.0) // 字母键列之间间隙
#define ALPHA_ROW_MARGIN 16.5 // 字母键行之间间隙
#define ALPHA_LEFT_RIGHT_MARGIN 9.0
#define ALPHA_TOP_MARGIN 10.5
#define ALPHA_BOTTOM_MARGIN 9.0


@interface MXKeyboard()

/** 字母键盘 */
@property (nonatomic, strong) UIView *alphabetView;
// 小写字母数组
@property (nonatomic, strong) NSArray *lowerAlphabetArr;
// 大写字母数组
@property (nonatomic, strong) NSArray *upperAlphabetArr;
// 展示的小写字母数组
@property (nonatomic, strong) NSMutableArray *showLowerAlpArr;
// 展示的大写字母数组
@property (nonatomic, strong) NSMutableArray *showUpperAlpArr;
// 字母按键数组
@property (nonatomic, strong) NSMutableArray *alphabetBtnArr;
// 设置大写按键
@property (nonatomic, weak) UIButton *upperBtn;

/** 符号键盘 */
@property (nonatomic, strong) UIView *symbolView;
// 符号数组
@property (nonatomic, strong) NSArray *symbolArr;
// 展示的符号数组
@property (nonatomic, strong) NSMutableArray *showSymbolArr;
// 符号按键数组
@property (nonatomic, strong) NSMutableArray *symbolBtnArr;

/** 数字键盘 */
@property (nonatomic, strong) UIView *numberView;
// 符号数组
@property (nonatomic, strong) NSArray *numberArr;
// 展示的符号数组
@property (nonatomic, strong) NSMutableArray *showNumberArr;
// 符号按键数组
@property (nonatomic, strong) NSMutableArray *numberBtnArr;
// 数字->符号
@property (nonatomic, weak) UIButton *numToSymbolBtn;
// 数字->字母
@property (nonatomic, weak) UIButton *numToAlpBtn;

/** 当前是什么键盘 */
@property (nonatomic, weak) UIView *currentKeyboardView;

/** 点击按键时的放大效果 */
@property (nonatomic, strong) MXBlownUpButton *hintView;

@end

@implementation MXKeyboard

#pragma mark -- 懒加载属性

- (NSArray *)lowerAlphabetArr {
    if (_lowerAlphabetArr == nil) {
        _lowerAlphabetArr = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u",
                              @"i", @"o", @"p", @"a", @"s", @"d", @"f",
                              @"g", @"h", @"j", @"k", @"l", @"z", @"x",
                              @"c", @"v", @"b", @"n", @"m"];
    }
    return _lowerAlphabetArr;
}

- (NSArray *)upperAlphabetArr {
    if (_upperAlphabetArr == nil) {
        _upperAlphabetArr = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U",
                              @"I", @"O", @"P", @"A", @"S", @"D", @"F",
                              @"G", @"H", @"J", @"K", @"L", @"Z", @"X",
                              @"C", @"V", @"B", @"N", @"M"];
    }
    return _upperAlphabetArr;
}

- (NSMutableArray *)showLowerAlpArr {
    if (_showLowerAlpArr == nil) {
        _showLowerAlpArr = [NSMutableArray arrayWithArray:self.lowerAlphabetArr];
    }
    return _showLowerAlpArr;
}

- (NSMutableArray *)showUpperAlpArr {
    if (_showUpperAlpArr == nil) {
        _showUpperAlpArr = [NSMutableArray arrayWithArray:self.upperAlphabetArr];
    }
    return _showUpperAlpArr;
}

- (NSMutableArray *)alphabetBtnArr {
    if (_alphabetBtnArr == nil) {
        _alphabetBtnArr = [NSMutableArray array];
    }
    return _alphabetBtnArr;
}

- (NSArray *)symbolArr {
    if (_symbolArr == nil) {
        _symbolArr = @[@"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*",
                       @"(", @")", @"'", @"\"", @"=", @"_", @":", @";",
                       @"?", @"~", @"|", @".", @"+", @"-", @"/", @"\\",
                       @"[", @"]", @"、", @"<", @">", @"¥", @"{", @"}", @"€"];
    }
    return _symbolArr;
}

- (NSMutableArray *)showSymbolArr {
    if (_showSymbolArr == nil) {
        _showSymbolArr = [NSMutableArray arrayWithArray:self.symbolArr];
    }
    return _showSymbolArr;
}

- (NSMutableArray *)symbolBtnArr {
    if (_symbolBtnArr == nil) {
        _symbolBtnArr = [NSMutableArray array];
    }
    return _symbolBtnArr;
}

- (NSArray *)numberArr {
    if (_numberArr == nil) {
        _numberArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    }
    return _numberArr;
}

- (NSMutableArray *)showNumberArr {
    if (_showNumberArr == nil) {
        _showNumberArr = [NSMutableArray arrayWithArray:self.numberArr];
    }
    return _showNumberArr;
}

- (NSMutableArray *)numberBtnArr {
    if (_numberBtnArr == nil) {
        _numberBtnArr = [NSMutableArray array];
    }
    return _numberBtnArr;
}

#pragma mark -- 子视图的初始化

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect fra = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KEY_BOARD_HEIGHT);
    self = [super initWithFrame:fra];
    if (self) {
        [self createSubviews];
    }
    return self;
}

/**
 *  初始化子控件
 */
- (void)createSubviews {
    [self createToolView];
    [self createAlphabetView];
    [self createSymbolView];
    [self createNumberView];
    
    [self addSubview:self.alphabetView];
    self.currentKeyboardView = self.alphabetView;
    self.backgroundColor = ALPHABET_COLOR;
}

- (void)createToolView {
    MXKeyboardButton *doneBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeDone];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateHighlighted];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    CGFloat doneW = 40;
    CGFloat doneH = KEY_BOARD_TOOL_HEIGHT;
    CGFloat doneX = [UIScreen mainScreen].bounds.size.width - doneW - 10;
    CGFloat doneY = 0;
    doneBtn.frame = CGRectMake(doneX, doneY, doneW, doneH);
    [doneBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];
    
    CGFloat logoW = 160.0;
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - logoW) * 0.5, 0, logoW, KEY_BOARD_TOOL_HEIGHT)];
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KEY_BOARD_TOOL_HEIGHT - 20) * 0.5, 20, 20)];
    logoImg.image = [UIImage imageNamed:@"logo"];
    [logoView addSubview:logoImg];
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 10, 0, logoW - 20 - 10, KEY_BOARD_TOOL_HEIGHT)];
    logoLabel.text = @"xxx安全输入";
    logoLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    logoLabel.textColor = [UIColor colorWithRed:111/255.0 green:109/255.0 blue:110/255.0 alpha:1];
    [logoView addSubview:logoLabel];
    [self addSubview:logoView];
}

/**
 *  @brief 创建字母键盘
 */
- (void)createAlphabetView {
    UIView *alphabetView = [[UIView alloc] initWithFrame:CGRectMake(0, KEY_BOARD_TOOL_HEIGHT, [UIScreen mainScreen].bounds.size.width, KEY_BOARD_PAD_HEIGHT)];
    alphabetView.backgroundColor = KEYBOARD_BACKGROUND_COLOR;
    self.alphabetView = alphabetView;
    NSArray *rowAlphabetCount = @[@(10), @(9), @(7)];
    NSInteger firstRowCount = [rowAlphabetCount[0] integerValue];
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - (firstRowCount - 1) * ALPHA_COLUMN_MARGIN - 2 * ALPHA_LEFT_RIGHT_MARGIN) / firstRowCount;
    CGFloat btnH = (KEY_BOARD_PAD_HEIGHT - 3 * ALPHA_ROW_MARGIN - ALPHA_TOP_MARGIN - ALPHA_BOTTOM_MARGIN) / 4;
    
    // 字母键
    for (int i = 0; i < self.showLowerAlpArr.count; ++i) {
        MXKeyboardButton *keyBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeOther];
        keyBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
        [keyBtn setTitle:self.showLowerAlpArr[i] forState:UIControlStateNormal];
        [keyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [keyBtn setBackgroundImage:[self resizedImageWithName:@"btn_bg_key"] forState:UIControlStateNormal];
        [keyBtn addTarget:self action:@selector(keyBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [keyBtn addTarget:self action:@selector(keyBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [self.alphabetBtnArr addObject:keyBtn];
        [alphabetView addSubview:keyBtn];
        
        NSInteger column = [self getTheColumnNum:rowAlphabetCount withNum:i];
        NSInteger row = [self getTheRowNum:rowAlphabetCount withNum:i];
        NSInteger rowCount = [rowAlphabetCount[row] integerValue];
        CGFloat leftMargin = ([UIScreen mainScreen].bounds.size.width - btnW * rowCount - ALPHA_COLUMN_MARGIN * (rowCount - 1)) / 2;
        CGFloat btnX = leftMargin + column * (btnW + ALPHA_COLUMN_MARGIN);
        CGFloat btnY = ALPHA_TOP_MARGIN + row * (btnH + ALPHA_ROW_MARGIN);
        keyBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 大写键
    UIButton *upperBtn = [[UIButton alloc] init];
    [upperBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_alpha"] forState:UIControlStateNormal];
    [upperBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_click_alpha"] forState:UIControlStateHighlighted];
    [upperBtn setImage:[UIImage imageNamed:@"abc_switch"] forState:UIControlStateNormal];
    [upperBtn setImage:[UIImage imageNamed:@"abc_upper_switch"] forState:UIControlStateSelected];
    upperBtn.adjustsImageWhenHighlighted = NO;
    [upperBtn addTarget:self action:@selector(upperBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.upperBtn = upperBtn;
    [alphabetView addSubview:upperBtn];
    CGFloat upperX = ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat upperY = ALPHA_TOP_MARGIN + 2 * (btnH + ALPHA_ROW_MARGIN);
    CGFloat upperW = ([UIScreen mainScreen].bounds.size.width - btnW * 7 - ALPHA_COLUMN_MARGIN * (7 - 1)) / 2 - ALPHA_LEFT_RIGHT_MARGIN - ALPHA_COLUMN_MARGIN;
    CGFloat upperH = btnH;
    upperBtn.frame = CGRectMake(upperX, upperY, upperW, upperH);
    
    // 删除键
    CGFloat delW = upperW;
    CGFloat delH = upperH;
    CGFloat delX = [UIScreen mainScreen].bounds.size.width - delW - ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat delY = upperY;
    MXKeyboardButton *delBtn = [self createDelBtn:CGRectMake(delX, delY, delW, delH)];
    [alphabetView addSubview:delBtn];
    
    // 字母->符号键
    UIButton *alpToSymbolBtn = [[UIButton alloc] init];
    alpToSymbolBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [alpToSymbolBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_alpha"] forState:UIControlStateNormal];
    [alpToSymbolBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_click_alpha"] forState:UIControlStateHighlighted];
    [alpToSymbolBtn setTitle:@"#+=" forState:UIControlStateNormal];
    [alphabetView addSubview:alpToSymbolBtn];
    CGFloat alpToSymbolW = 2 * btnW + 10;
    CGFloat alpToSymbolH = upperH;
    CGFloat alpToSymbolX = upperX;
    CGFloat alpToSymbolY = ALPHA_TOP_MARGIN + 3 * (btnH + ALPHA_ROW_MARGIN);
    [alpToSymbolBtn addTarget:self action:@selector(changeToSymbolPad) forControlEvents:UIControlEventTouchUpInside];
    alpToSymbolBtn.frame = CGRectMake(alpToSymbolX, alpToSymbolY, alpToSymbolW, alpToSymbolH);
    
    // ->数字键
    CGFloat alpToNumW = alpToSymbolW;
    CGFloat alpToNumH = alpToSymbolH;
    CGFloat alpToNumX = [UIScreen mainScreen].bounds.size.width - alpToSymbolW - ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat alpToNumY = alpToSymbolY;
    UIButton *toNumBtn = [self createToNumBtn:CGRectMake(alpToNumX, alpToNumY, alpToNumW, alpToNumH)];
    toNumBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [toNumBtn addTarget:self action:@selector(changeToNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [alphabetView addSubview:toNumBtn];
    
    // 空格键
    CGFloat spaceW = [UIScreen mainScreen].bounds.size.width - 2 * alpToNumW - ALPHA_LEFT_RIGHT_MARGIN * 2 - 4 * ALPHA_COLUMN_MARGIN;
    CGFloat spaceH = alpToNumH;
    CGFloat spaceX = alpToSymbolW + ALPHA_LEFT_RIGHT_MARGIN + 2 * ALPHA_COLUMN_MARGIN;
    CGFloat spaceY = alpToNumY;
    MXKeyboardButton *spaceBtn = [self createSpaceBtn:CGRectMake(spaceX, spaceY, spaceW, spaceH)];
    spaceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [alphabetView addSubview:spaceBtn];
}

/**
 *  @brief 创建符号键盘
 */
- (void)createSymbolView {
    UIView *symbolView = [[UIView alloc] initWithFrame:CGRectMake(0, KEY_BOARD_TOOL_HEIGHT, [UIScreen mainScreen].bounds.size.width, KEY_BOARD_PAD_HEIGHT)];
    symbolView.backgroundColor = KEYBOARD_BACKGROUND_COLOR;
    self.symbolView = symbolView;
    
    NSArray *groupCount = @[@(10), @(10), @(7), @(6)];
    NSInteger firstRowCount = [groupCount[0] integerValue];
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - (firstRowCount - 1) * ALPHA_COLUMN_MARGIN - 2 * ALPHA_LEFT_RIGHT_MARGIN) / firstRowCount;
    CGFloat btnH = (KEY_BOARD_PAD_HEIGHT - 3 * ALPHA_ROW_MARGIN - ALPHA_TOP_MARGIN - ALPHA_BOTTOM_MARGIN) / 4;
    
    // 符号按键
    CGFloat leftMargin = 0;
    CGFloat delW = ([UIScreen mainScreen].bounds.size.width - btnW * 6 - (6 + 1) * ALPHA_COLUMN_MARGIN - ALPHA_LEFT_RIGHT_MARGIN * 2) / 2;
    for (int i = 0; i < self.showSymbolArr.count; ++i) {
        MXKeyboardButton *keyBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeOther];
        keyBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
        [keyBtn setTitle:self.showSymbolArr[i] forState:UIControlStateNormal];
        [keyBtn setBackgroundImage:[self resizedImageWithName:@"btn_bg_key"] forState:UIControlStateNormal];
        [keyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [keyBtn addTarget:self action:@selector(keyBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [keyBtn addTarget:self action:@selector(keyBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [self.symbolBtnArr addObject:keyBtn];
        [symbolView addSubview:keyBtn];
        
        NSInteger column = [self getTheColumnNum:groupCount withNum:i];
        NSInteger row = [self getTheRowNum:groupCount withNum:i];
        
        NSInteger rowCount = [groupCount[row] integerValue];
        if (row == 2) {
            leftMargin = ([UIScreen mainScreen].bounds.size.width - rowCount * btnW - (rowCount - 1) * ALPHA_COLUMN_MARGIN - delW - ALPHA_LEFT_RIGHT_MARGIN) / 2;
        } else if (row == 3) {
            leftMargin = ([UIScreen mainScreen].bounds.size.width - rowCount * btnW - (rowCount - 1) * ALPHA_COLUMN_MARGIN) / 2;
        } else {
            leftMargin = ALPHA_LEFT_RIGHT_MARGIN;
        }
        CGFloat btnX = leftMargin + column * (btnW + ALPHA_COLUMN_MARGIN);
        CGFloat btnY = ALPHA_TOP_MARGIN + row * (btnH + ALPHA_ROW_MARGIN);
        keyBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 删除按键
    CGFloat delH = btnH;
    CGFloat delX = [UIScreen mainScreen].bounds.size.width - delW - ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat delY = ALPHA_TOP_MARGIN + 2 * (btnH + ALPHA_ROW_MARGIN);
    MXKeyboardButton *delBtn = [self createDelBtn:CGRectMake(delX, delY, delW, delH)];
    [symbolView addSubview:delBtn];
    
    // 符号->字母键
    UIButton *symbolToAlpBtn = [[UIButton alloc] init];
    symbolToAlpBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [symbolToAlpBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_alpha"] forState:UIControlStateNormal];
    [symbolToAlpBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_click_alpha"] forState:UIControlStateHighlighted];
    [symbolToAlpBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [symbolView addSubview:symbolToAlpBtn];
    CGFloat symbolToAlpW = delW;
    CGFloat symbolToAlpH = btnH;
    CGFloat symbolToAlpX = ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat symbolToAlpY = ALPHA_TOP_MARGIN + 3 * (btnH + ALPHA_ROW_MARGIN);
    [symbolToAlpBtn addTarget:self action:@selector(changeToAlphabetPad) forControlEvents:UIControlEventTouchUpInside];
    symbolToAlpBtn.frame = CGRectMake(symbolToAlpX, symbolToAlpY, symbolToAlpW, symbolToAlpH);
    
    // ->数字键
    CGFloat toNumW = delW;
    CGFloat toNumH = btnH;
    CGFloat toNumX = [UIScreen mainScreen].bounds.size.width - toNumW - ALPHA_LEFT_RIGHT_MARGIN;
    CGFloat toNumY = symbolToAlpY;
    UIButton *toNumBtn = [self createToNumBtn:CGRectMake(toNumX, toNumY, toNumW, toNumH)];
    toNumBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [toNumBtn addTarget:self action:@selector(changeToNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [symbolView addSubview:toNumBtn];
}

/**
 *  @brief 创建数字键盘
 */
- (void)createNumberView {
    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, KEY_BOARD_TOOL_HEIGHT, [UIScreen mainScreen].bounds.size.width, KEY_BOARD_PAD_HEIGHT)];
    numberView.backgroundColor = KEYBOARD_BACKGROUND_COLOR;
    self.numberView = numberView;
    
    CGFloat btnH = KEY_BOARD_PAD_HEIGHT / 4;
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / 4;
    
    // 数字键
    for (int i = 0; i < 10; ++i) {
        MXKeyboardButton *keyBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeNum];
        [keyBtn setTitle:self.showNumberArr[i] forState:UIControlStateNormal];
        [self.numberBtnArr addObject:keyBtn];
        [keyBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg"] forState:UIControlStateNormal];
        [keyBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg_click"] forState:UIControlStateHighlighted];
        [keyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        keyBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:36];
        [keyBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [numberView addSubview:keyBtn];
        
        NSInteger column = i % 3;
        NSInteger row = i / 3;
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        if (i == 9) {
            btnX = btnW;
            btnY = 3 * btnH;
        } else {
            btnX = column * btnW;
            btnY = row * btnH;
        }
        keyBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 数字->符号
    UIButton *numToSymbolBtn = [[UIButton alloc] init];
    self.numToSymbolBtn = numToSymbolBtn;
    numToSymbolBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    [numToSymbolBtn setTitle:@"#+=" forState:UIControlStateNormal];
    [numToSymbolBtn addTarget:self action:@selector(changeToSymbolPad) forControlEvents:UIControlEventTouchUpInside];
    numToSymbolBtn.frame = CGRectMake(0, 3 * btnH, btnW, btnH);
    [numToSymbolBtn setBackgroundImage:[self resizedImageWithName:@"num_trans_bg"] forState:UIControlStateNormal];
    [numToSymbolBtn setBackgroundImage:[self resizedImageWithName:@"num_trans_bg_click"] forState:UIControlStateHighlighted];
    [numberView addSubview:numToSymbolBtn];
    
    // 数字->字母
    UIButton *numToAlpBtn = [[UIButton alloc] init];
    self.numToAlpBtn = numToAlpBtn;
    numToAlpBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    [numToAlpBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [numToAlpBtn addTarget:self action:@selector(changeToAlphabetPad) forControlEvents:UIControlEventTouchUpInside];
    numToAlpBtn.frame = CGRectMake(2 * btnW, 3 * btnH, btnW, btnH);
    [numToAlpBtn setBackgroundImage:[self resizedImageWithName:@"num_trans_bg"] forState:UIControlStateNormal];
    [numToAlpBtn setBackgroundImage:[self resizedImageWithName:@"num_trans_bg_click"] forState:UIControlStateHighlighted];
    [numberView addSubview:numToAlpBtn];
    
    // 删除键
    MXKeyboardButton *delBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeDel];
    [delBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.frame = CGRectMake(3 * btnW, 0, btnW, btnH * 2);
    delBtn.adjustsImageWhenHighlighted = NO;
    [delBtn setImage:[UIImage imageNamed:@"delet_num"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg_click"] forState:UIControlStateHighlighted];
    [numberView addSubview:delBtn];
    
    // 点
    MXKeyboardButton *dotBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeOther];
    [dotBtn setTitle:@"." forState:UIControlStateNormal];
    [dotBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    dotBtn.frame = CGRectMake(3 * btnW, 2 * btnH, btnW, btnH * 2);
    [dotBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg"] forState:UIControlStateNormal];
    [dotBtn setBackgroundImage:[self resizedImageWithName:@"num_btn_bg_click"] forState:UIControlStateHighlighted];
    [numberView addSubview:dotBtn];
    
    //分割线
    for (int i = 0; i < 4; i++) {
        CGFloat lineW = 0;
        if (i % 2 == 0) {
            lineW = [UIScreen mainScreen].bounds.size.width;
        } else {
            lineW = [UIScreen mainScreen].bounds.size.width - btnW;
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * btnH, lineW, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
        [numberView addSubview:lineView];
    }
    //分割线
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * btnW, 0, 1, KEY_BOARD_PAD_HEIGHT)];
        lineView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
        [numberView addSubview:lineView];
    }
}


/**
 *  @brief 创建删除按键
 *
 *  @param delBtnFrame 删除按键的frame
 *
 *  @return 删除按键
 */
- (MXKeyboardButton *)createDelBtn:(CGRect)delBtnFrame {
    MXKeyboardButton *delBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeDel];
    delBtn.frame = delBtnFrame;
    delBtn.adjustsImageWhenHighlighted = NO;
    [delBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_alpha"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_click_alpha"] forState:UIControlStateHighlighted];
    [delBtn setImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return delBtn;
}

/**
 *  @brief 创建切到数字键的按钮
 *
 *  @param toNumBtnFrame frame
 *
 *  @return 切到数字键的按钮
 */
- (UIButton *)createToNumBtn:(CGRect)toNumBtnFrame {
    UIButton *toNumBtn = [[UIButton alloc] init];
    [toNumBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_alpha"] forState:UIControlStateNormal];
    [toNumBtn setBackgroundImage:[self resizedImageWithName:@"btn_blue_click_alpha"] forState:UIControlStateHighlighted];
    [toNumBtn setTitle:@"123" forState:UIControlStateNormal];
    toNumBtn.frame = toNumBtnFrame;
    return toNumBtn;
}

/**
 *  @brief 创建空格键
 *
 *  @param spaceBtnFrame frame
 *
 *  @return 空格键
 */
- (MXKeyboardButton *)createSpaceBtn:(CGRect)spaceBtnFrame {
    MXKeyboardButton *spaceBtn = [[MXKeyboardButton alloc] initWithType:MXKeyButtonTypeSpace];
    [spaceBtn setBackgroundImage:[self resizedImageWithName:@"btn_bg_key"] forState:UIControlStateNormal];
    [spaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [spaceBtn setTitle:@"空  格" forState:UIControlStateNormal];
    [spaceBtn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    spaceBtn.frame = spaceBtnFrame;
    return spaceBtn;
}

/**
 *  @brief 获取地i个字母按键位于字母的第几列
 *
 *  @param groupNumArr 一行有几个按钮 num 第i个字母按键
 *
 */
- (NSInteger)getTheColumnNum:(NSArray *)groupNumArr withNum:(NSInteger)num {
    NSInteger count = groupNumArr.count;
    for (NSInteger i = count - 1; i >= 0; --i) {
        NSInteger sum = 0;
        for (int j = 0; j < i; j++) {
            sum += [groupNumArr[j] integerValue];
        }
        if (num >= sum) {
            return num - sum;
        }
    }
    return 0;
}

/**
 *  @brief 获取地i个字母按键位于字母的第几行
 *
 *  @param groupNumArr 一行有几个按钮 num 第i个字母按键
 *
 */
- (NSInteger)getTheRowNum:(NSArray *)groupNumArr withNum:(NSInteger)num {
    NSInteger count = groupNumArr.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        NSInteger sum = 0;
        for (int j = 0; j < i; j++) {
            sum += [groupNumArr[j] integerValue];
        }
        if (num >= sum) {
            return i;
        }
    }
    return 0;
}



#pragma mark -- 按键事件的处理

/**
 *  @brief 按键被点击
 *
 *  @param keyBtn 按键
 */
- (void)keyBtnClicked:(MXKeyboardButton *)keyBtn {
    if (keyBtn.type == MXKeyButtonTypeDone) {
        [self.textField resignFirstResponder];
    } else if (keyBtn.type == MXKeyButtonTypeDel) {
        [self.textField changetext:@""];
    } else if (keyBtn.type == MXKeyButtonTypeSpace) {
        [self.textField changetext:@" "];
    } else {
        [self.textField changetext:keyBtn.currentTitle];
    }
}

/**
 *  @brief 大写键被点击
 *
 *  @param upperBtn 大写键
 */
- (void)upperBtnClicked:(UIButton *)upperBtn {
    upperBtn.selected = !upperBtn.selected;
    NSArray *arr = self.upperBtn.selected ? self.showUpperAlpArr : self.showLowerAlpArr;
    for (int i = 0; i < arr.count; ++i) {
        MXKeyboardButton *btn = self.alphabetBtnArr[i];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
    }
}

/**
 *  重置按键顺序
 */
- (void)sortTheOrder {
    self.showLowerAlpArr = [NSMutableArray arrayWithArray:self.lowerAlphabetArr];
    self.showUpperAlpArr = [NSMutableArray arrayWithArray:self.upperAlphabetArr];
    self.showSymbolArr = [NSMutableArray arrayWithArray:self.symbolArr];
    self.showNumberArr = [NSMutableArray arrayWithArray:self.numberArr];
    [self updateKeyboard];
}

/**
 *  打乱按键顺序
 */
- (void)exchangeTheOrder {
    // 字母按键
    [self exchangeTheArr:self.lowerAlphabetArr newArray:self.showLowerAlpArr];
    [self exchangeTheArr:self.upperAlphabetArr newArray:self.showUpperAlpArr];
    // 符号按键
    [self exchangeTheArr:self.symbolArr newArray:self.showSymbolArr];
    // 数字按键
    [self exchangeTheArr:self.numberArr newArray:self.showNumberArr];
    
    [self updateKeyboard];
}

/**
 *  刷新键盘显示
 */
- (void)updateKeyboard {
    NSArray *arr = self.upperBtn.selected ? self.showUpperAlpArr : self.showLowerAlpArr;
    for (int i = 0; i < arr.count; ++i) {
        MXKeyboardButton *btn = self.alphabetBtnArr[i];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
    }
    for (int i = 0; i < self.showSymbolArr.count; ++i) {
        MXKeyboardButton *btn = self.symbolBtnArr[i];
        [btn setTitle:self.showSymbolArr[i] forState:UIControlStateNormal];
    }
    for (int i = 0; i < self.showNumberArr.count; ++i) {
        MXKeyboardButton *btn = self.numberBtnArr[i];
        [btn setTitle:self.showNumberArr[i] forState:UIControlStateNormal];
    }
}

/**
 *  @brief 打乱数组的方法
 *
 *  @param array    要打乱顺序的数组
 *  @param newArray 打乱顺序后的数组
 */
- (void)exchangeTheArr:(NSArray *)array newArray:(NSMutableArray *)newArray {
    [newArray removeAllObjects];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    NSInteger count = array.count;
    NSInteger num = 0;
    for (NSInteger i = 0; i < count; ++i) {
        num = arc4random() % tempArr.count;
        [newArray addObject:tempArr[num]];
        [tempArr removeObjectAtIndex:num];
    }
}

#pragma mark -- 键盘切换

/**
 *  切为字母键盘
 */
- (void)changeToAlphabetPad {
    if (self.currentKeyboardView != self.alphabetView) {
        [self.currentKeyboardView removeFromSuperview];
        [self addSubview:self.alphabetView];
        self.currentKeyboardView = self.alphabetView;
    }
}

/**
 *  切为符号键盘
 */
- (void)changeToSymbolPad {
    if (self.currentKeyboardView != self.symbolView) {
        [self.currentKeyboardView removeFromSuperview];
        [self addSubview:self.symbolView];
        self.currentKeyboardView = self.symbolView;
    }
}

/**
 *  切为数字键盘
 */
- (void)changeToNumberPad {
    if (self.currentKeyboardView != self.numberView) {
        [self.currentKeyboardView removeFromSuperview];
        [self addSubview:self.numberView];
        self.currentKeyboardView = self.numberView;
    }
    self.numToAlpBtn.enabled = YES;
    self.numToSymbolBtn.enabled = YES;
}

/**
 *  切为数字键盘, 且不能切到其他键盘
 */
- (void)changeToNumberPadOnly {
    if (self.currentKeyboardView != self.numberView) {
        [self.currentKeyboardView removeFromSuperview];
        [self addSubview:self.numberView];
        self.currentKeyboardView = self.numberView;
    }
    self.numToAlpBtn.enabled = NO;
    self.numToSymbolBtn.enabled = NO;
}

#pragma mark -- 点击键盘放大效果

/**
 *  部分键盘点击时的放大效果
 *
 *  @param btn 被点击的按键
 */
- (void)keyBtnTouchDown:(MXKeyboardButton *)btn {
    if (self.hintView == nil) {
        self.hintView = [MXBlownUpButton buttonWithType:UIButtonTypeCustom];
        self.hintView.userInteractionEnabled = NO;
        self.hintView.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.hintView.titleLabel.font = [UIFont systemFontOfSize:30];
    }
    
    CGFloat scalePic = 188.0 / 188.0; //按键放大的背景图的宽高比
    CGFloat scaleW = 188.0 / 52.0; //背景图片的总宽度与某些内容的宽度比
    CGFloat scaleLeft = 46.0 / 188.0; //背景图中左侧间隙占总宽度比
    
    CGFloat hintW = btn.frame.size.width * scaleW;
    CGFloat hintH = hintW * scalePic;
    CGFloat hintX = 0;
    CGFloat hintY = CGRectGetMaxY(btn.frame) - hintH + KEY_BOARD_TOOL_HEIGHT + 1; //+1是调整一点误差
    
    NSInteger alphaIndex = [self.alphabetBtnArr indexOfObject:btn];
    NSInteger symbolIndex = [self.symbolBtnArr indexOfObject:btn];
    if (self.currentKeyboardView == self.alphabetView) {
        if (alphaIndex == 0) {
            hintX = btn.frame.origin.x - hintW * scaleLeft;
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"leftside_click_bg"] forState:UIControlStateNormal];
        } else if (alphaIndex == 9) {
            hintX = CGRectGetMaxX(btn.frame) - hintW * (1 - scaleLeft) - 1; //-1用于调整一点误差
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"rightside_click_bg"] forState:UIControlStateNormal];
        } else {
            hintX = btn.frame.origin.x - (hintW - btn.frame.size.width) / 2.0;
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"abc_click_bg"] forState:UIControlStateNormal];
        }
    } else if (self.currentKeyboardView == self.symbolView) {
        if (symbolIndex == 0 || symbolIndex == 10) {
            hintX = btn.frame.origin.x - hintW * scaleLeft;
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"leftside_click_bg"] forState:UIControlStateNormal];
        } else if (symbolIndex == 9 || symbolIndex == 19) {
            hintX = CGRectGetMaxX(btn.frame) - hintW * (1 - scaleLeft) - 1; //-1用于调整一点误差
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"rightside_click_bg"] forState:UIControlStateNormal];
        } else {
            hintX = btn.frame.origin.x - (hintW - btn.frame.size.width) / 2.0;
            [self.hintView setBackgroundImage:[UIImage imageNamed:@"abc_click_bg"] forState:UIControlStateNormal];
        }
    }
    self.hintView.frame = CGRectMake(hintX, hintY, hintW, hintH);
    [self.hintView setTitle:btn.currentTitle forState:UIControlStateNormal];
    [self addSubview:self.hintView];
}

/**
 *  键盘弹起时,隐藏放大效果
 *
 *  @param btn 被点击的按键
 */
- (void)keyBtnTouchUp:(MXKeyboardButton *)btn {
    if (self.hintView) {
        [self.hintView removeFromSuperview];
    }
    [self keyBtnClicked:btn];
}


#pragma mark Tools

- (UIImage *)resizedImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


@end
