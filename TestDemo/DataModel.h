//
//  DataModel.h
//  TestDemo
//
//  Created by hanjp on 15/6/12.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property(nonatomic,strong)NSNumber* modelID;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* invalid;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* smurl;
@property(nonatomic,copy)NSString* url;
@end
