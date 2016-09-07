//
//  ViewController.m
//  BGKeyboardOfNumber
//
//  Created by 周博 on 16/9/7.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "ViewController.h"
#import "BGCaculatorView.h"
#import "BGSDK.h"

@interface ViewController ()<UITextFieldDelegate,BGCaculatorDelegate>
@property (nonatomic,strong) UITextField *caculatorTextField;

@property (nonatomic,strong) BGCaculatorView * myCaculator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self creatTextfield];
}


- (void)creatTextfield{
    _caculatorTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, kScreenSize.height/2, 300, 30)];
    _caculatorTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _caculatorTextField.textColor = [UIColor blackColor];
    _caculatorTextField.center = self.view.center;
    _caculatorTextField.textAlignment = NSTextAlignmentRight;
    _caculatorTextField.delegate =self;
    [self.view addSubview:_caculatorTextField];
}

- (void)showCaculator{
    _myCaculator = [[BGCaculatorView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 220, kScreenSize.width, 220)];
    _myCaculator.delegate = self;
    [self.view addSubview:_myCaculator];
}

- (void)clickBannerImage:(int)index{
    NSLog(@"点击的是第%d张图片",index);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (!_myCaculator) {
        [self showCaculator];
    }else{
        [_myCaculator showCaculatorView];
    }
    return NO;
}

- (void)didChanged:(NSNotification *)noti{
    _caculatorTextField.text = (NSString *)noti.object;
}

- (void)scanfBGCaculatorString:(NSString *)string{
    _caculatorTextField.text = string;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_myCaculator hiddenCaculatorView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
