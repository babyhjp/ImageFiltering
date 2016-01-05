//
//  ShowScrollView.m
//  TestDemo
//
//  Created by hanjp on 15/6/12.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "ShowScrollView.h"

@implementation ShowScrollView
static CGFloat Widths = 0;
static CGFloat Heigths = 0;
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
        _dataArray = [NSArray alloc];//初始化
        Widths = frame.size.width;
        Heigths = frame.size.height;
        _trueImage = [[UIImageView alloc] initWithFrame:CGRectMake(Widths/2-30, 13, 60, 60)];
        _trueImage.image = [UIImage imageNamed:@"true.png"];
        [self addSubview: _trueImage];
        _beginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_beginBtn setBackgroundImage:[UIImage imageNamed:@"begin.png"] forState:UIControlStateNormal];
        [self addSubview:_beginBtn];
        _againBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_againBtn setBackgroundImage:[UIImage imageNamed:@"again.png"] forState:UIControlStateNormal];
        [self addSubview:_againBtn];
    }
    return self;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self layoutView];
}
//布局图片
-(void)layoutView{
//    NSInteger i = 0;
    NSInteger row = _dataArray.count/4;
    NSInteger line = _dataArray.count%4;
    for (NSInteger i = 0; i< row; i++) {
        for (int j=0; j<4; j++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Widths-30)/4*j, 40+(Widths-30)/4*i, (Widths-30)/4-10, (Widths-30)/4-10)];
            imageView.image = [(MaterialView*)_dataArray[i*4+j] pictureView].image;
            [self addSubview:imageView];
        }
    }
    for (int i=0; i<line; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(Widths-30)/4*i, 40+(Widths-30)/4*row, (Widths-30)/4-10, (Widths-30)/4-10)];
        imageView.image = [(MaterialView*)_dataArray[row*4+i] pictureView].image;
        [self addSubview:imageView];
    }
    [self layoutButtonAndLabel:row line:line];
}
//布局button
-(void)layoutButtonAndLabel:(NSInteger)row line:(NSInteger)line{
    if (line) {
        row++;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Widths/2 - 100, ((Widths-40)/4)*(row+1), 200, 50)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"选择结束啦\n确定开始你的心灵之旅了吗";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    //按钮
    self.beginBtn.frame = CGRectMake(Widths/2 -120, 130+((Widths-40)/4)*(row+1), 100, 40);
    self.againBtn.frame = CGRectMake(Widths/2 +20, 130+((Widths-40)/4)*(row+1), 100, 40);
    //scroll属性
    self.contentSize = CGSizeMake(Widths, ((Widths-40)/4)*(row+1) +250);
    self.showsVerticalScrollIndicator = NO;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
