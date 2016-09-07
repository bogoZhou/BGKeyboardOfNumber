//
//  BGCaculatorView.m
//  BGBanner
//
//  Created by 周博 on 16/9/6.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGCaculatorView.h"
#import "BGSDK.h"

@implementation BGCaculatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatCaculatorBody];
    }
    return self;
}


- (void)creatCaculatorBody{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, self.frame.size.height)];
    [self addSubview:backView];
    
    CGSize backViewSize = backView.frame.size;
    
    for (int i = 0 ; i < 4; i ++) {
        for (int j = 0 ; j < 4 ; j ++ ) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            NSString * buttonStr;
            
            CGRect buttonFrame = CGRectMake(0 + backViewSize.width/4 * j,0.25 + backViewSize.height/4 * i, backViewSize.width/4, backViewSize.height/4);
            
            UIColor *titleColor = kColorFrom0x(0x404040);
            
            if (i < 3 && j < 3) {//创建数字键
                
                buttonStr =[NSString stringWithFormat:@"%d",(j+1)+i*3];
                
            }else if (j == 3 && i ==0){//创建删除号
                
                buttonStr = @"delete";
                
                buttonFrame.size.height = backViewSize.height/2;
                
            }else if (i == 2 &&  j == 3){//创建确定键
                
                buttonStr = @"OK";
                
                buttonFrame.size.height = backViewSize.height/2;
                
                titleColor = kColorFrom0x(0xffffff);
                
                [button setBackgroundColor:kColorFrom0x(0x1E90FF)];
                
            }else if (i == 3 && j == 0){//创建点
                
                buttonStr = @".";
                
            }else if (i == 3 && j == 1) {//创建0
                
                buttonStr = @"0";
                
            }else if (i == 3 && j == 2){//创建收回键盘
                
                buttonStr = @"⬇️";
                
            }else{
                continue;
            }
            
            button.frame = buttonFrame;
            
            [button setTitle:buttonStr forState:UIControlStateNormal];
            
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            
            button.layer.borderWidth = .5f;
            
            button.layer.borderColor = [kColorFrom0x(0xd0d0d0) CGColor];
            
            [button addTarget:self action:@selector(printScanf:) forControlEvents:UIControlEventTouchUpInside];
            
            [backView addSubview:button];
        }
    }
}

- (void)printScanf:(UIButton *)button{//输出button上的字,并进行操作
    if (!_stringContent && ![_stringContent isEqualToString:@"."]) {//如果内容为空,或是0,置为0
        _stringContent = @"";
    }
    //当点击删除按钮并且输入内容不为空时
    if ([button.titleLabel.text isEqualToString:@"delete"] && _stringContent.length > 0) {
        //删除字符串中最后一个字符
        _stringContent = [_stringContent substringToIndex:_stringContent.length-1];
        
        //如果点击的不是删除,不是OK,不是收键盘,不是点字符
    }else if (![button.titleLabel.text isEqualToString:@"delete"]
              && ![button.titleLabel.text isEqualToString:@"OK"]
              && ![button.titleLabel.text isEqualToString:@"⬇️"]
              && ![button.titleLabel.text isEqualToString:@"."]){
        if ([BGFunctionHelper majorString:_stringContent isContainMinorString:@"."]) {
            NSArray * array = [BGFunctionHelper cutString:_stringContent ByCutString:@"."];
            NSString * str = array[1];
            if (str.length <2) {
                if (_stringContent.length > 0) {
                    if ([[_stringContent substringWithRange:NSMakeRange(_stringContent.length-1, 1)] isEqualToString:@"0"] && [button.titleLabel.text isEqualToString:@"0"]) {
                        if (str.length == 1) {
                            _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
                        }else{
                            _stringContent = @"0";
                        }
                    }else if ([[_stringContent substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]
                              && [button.titleLabel.text isEqualToString:@"."]){
                        _stringContent = @"0.";
                    }else{
                        //拼接输出的内容
                        _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
                    }
                }else{
                    //拼接输出的内容
                    _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
                }
            }
        }else{
            if (_stringContent.length > 0) {
                if ([[_stringContent substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"] && [button.titleLabel.text isEqualToString:@"0"]) {
                    _stringContent = @"0";
                }else if ([[_stringContent substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]
                          && [button.titleLabel.text isEqualToString:@"."]){
                    _stringContent = @"0.";
                }else if ([[_stringContent substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"] && button.titleLabel.text.integerValue > 0){
                    _stringContent = [NSString stringWithFormat:@"%@",button.titleLabel.text];
                }
                else{
                    //拼接输出的内容
                    _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
                }
            }else{
                //拼接输出的内容
                _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
            }
        }
        
        
        
        
        //如果点击的是OK键
    }else if ([button.titleLabel.text isEqualToString:@"OK"]){
//        kAlert(@"点击完成");
        [_delegate clickBGCaculatorSuccess];
        
        //如果点击的是收键盘,隐藏view
    }else if ([button.titleLabel.text isEqualToString:@"⬇️"]){
        [self hiddenCaculatorView];
        
        //如果button 上是小数点,对小数点进行判断
    }else if ([button.titleLabel.text isEqualToString:@"."]){
        //小数点只能出现一次
        NSString *str = _stringContent;
        //判断小数点是否已经出现过
        if (![BGFunctionHelper majorString:str isContainMinorString:@"."]) {
            if (_stringContent.length == 0) {
                _stringContent = [NSString stringWithFormat:@"%@%@",@"0",button.titleLabel.text];
            }else            {
                _stringContent = [NSString stringWithFormat:@"%@%@",_stringContent,button.titleLabel.text];
            }
        }
    }
    
    //长度如果是0,就让输出的字符为0
    if (_stringContent.length == 0) {
        _stringContent = @"0";
    }
    
    NSLog(@"%@",_stringContent);
    [_delegate scanfBGCaculatorString:_stringContent];
    
}


//显示输入页面
- (void)showCaculatorView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height - self.frame.size.height, kScreenSize.width, self.frame.size.height);
    }];
}

//隐藏输入页面
- (void)hiddenCaculatorView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, self.frame.size.height);
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
