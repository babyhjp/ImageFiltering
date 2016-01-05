//
//  MaterialView.m
//  TestDemo
//
//  Created by hanjp on 15/6/10.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "MaterialView.h"

@implementation MaterialView
CGFloat Width = 0;
CGFloat Heigth = 0;
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        Width = frame.size.width;
        Heigth = frame.size.height;
        _state = YES;
        [self layoutViews];
    }
    return self;
}
//布局界面
-(void)layoutViews{
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Heigth)];
    [self addSubview:_pictureView];
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Heigth)];
    _maskView.alpha = 0.6;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.userInteractionEnabled = NO;
    [self addSubview:_maskView];
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    if (Width == 80) {
        _selectBtn.frame = CGRectMake(Width-25, 0, 25, 25);
    }else{
        _selectBtn.frame = CGRectMake(Width-30, 5, 25, 25);
    }
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"notSelected.png"] forState:UIControlStateNormal];
    _selectBtn.hidden = YES;
    [self addSubview:_selectBtn];
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
