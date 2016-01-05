//
//  TableViewCell.h
//  TestDemo
//
//  Created by hanjp on 15/6/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageAndMp3;
@property(nonatomic,assign)BOOL cellState;
@property(nonatomic,strong)UIImageView *deleteImage;//叉
@end
