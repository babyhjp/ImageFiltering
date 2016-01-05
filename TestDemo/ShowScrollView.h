//
//  ShowScrollView.h
//  TestDemo
//
//  Created by hanjp on 15/6/12.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "MaterialView.h"
@interface ShowScrollView : UIScrollView
@property(nonatomic,strong)NSArray *dataArray;//数据接口
@property(nonatomic,strong)UIButton *beginBtn;//开始
@property(nonatomic,strong)UIButton *againBtn;//重新开始
@property(nonatomic,strong)UIImageView *trueImage;//对号
@end
