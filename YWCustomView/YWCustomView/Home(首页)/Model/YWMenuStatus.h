//
//  YWMenuStatus.h
//  TZKB
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMenuStatus : NSObject


//用来判断是不是选中状态
@property(nonatomic,assign,getter = isSelected)BOOL selected;

@property(nonatomic,copy)NSString *cltId;//资讯类型ID

@property(nonatomic,copy)NSString *name;//资讯类型名称


//（type字段0是普通栏目，1是关键字）
@property(nonatomic,copy)NSString *type;//类型

//是否正在编辑状态
@property(nonatomic,assign)BOOL isEdit;


@end
