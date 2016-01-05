//
//  TableViewCell.m
//  TestDemo
//
//  Created by hanjp on 15/6/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor clearColor];
        _cellState = NO;
        UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 14, 72, 72)];
        backLabel.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:backLabel];
        _imageAndMp3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        [self.contentView addSubview:_imageAndMp3];
        _deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake(79, 9, 16, 16)];
        _deleteImage.layer.cornerRadius = 8;
        _deleteImage.layer.masksToBounds = YES;
        _deleteImage.image = [UIImage imageNamed:@"delete.jpg"];
        _deleteImage.hidden = YES;
        [self addSubview:_deleteImage];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
