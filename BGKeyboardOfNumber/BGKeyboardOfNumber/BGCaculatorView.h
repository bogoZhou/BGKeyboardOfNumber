//
//  BGCaculatorView.h
//  BGBanner
//
//  Created by 周博 on 16/9/6.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGetMessage @"GETMESSAGE"

@protocol BGCaculatorDelegate <NSObject>

- (void)scanfBGCaculatorString:(NSString *)string;

- (void)clickBGCaculatorSuccess;

@end

@interface BGCaculatorView : UIView <BGCaculatorDelegate>
{
    NSString *_stringContent;
}

@property (nonatomic, assign) id <BGCaculatorDelegate> delegate;

//显示输入页面
- (void)showCaculatorView;

//隐藏输入页面
- (void)hiddenCaculatorView;

@end
