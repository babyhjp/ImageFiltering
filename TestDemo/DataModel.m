//
//  DataModel.m
//  TestDemo
//
//  Created by hanjp on 15/6/12.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.modelID = value;
    }
}
@end
