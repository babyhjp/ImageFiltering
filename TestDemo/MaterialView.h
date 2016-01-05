//
//  MaterialView.h
//  TestDemo
//
//  Created by hanjp on 15/6/10.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialView : UIView

@property(nonatomic,assign)BOOL state;//状态
@property(nonatomic,strong)UIImageView *pictureView;//图片
@property(nonatomic,strong)UIView *maskView;//遮挡层
@property(nonatomic,strong)UIButton *selectBtn;//选择btn
@property(nonatomic,strong)NSString *num;//代表id

@end
