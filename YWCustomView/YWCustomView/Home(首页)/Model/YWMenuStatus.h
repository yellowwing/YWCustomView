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

@property(nonatomic,copy)NSString *code;//简称

@property(nonatomic,copy)NSString *cityId;//所属城市的ID

@property(nonatomic,copy)NSString *title;//栏目标题

@property(nonatomic,copy)NSString *keyWords;//栏目关键字

@property(nonatomic,copy)NSString *des;//栏目描述


//（注备就是类型，1是首页， 2 是视频， 3，其他）
@property(nonatomic,copy)NSString *remarks;//备注

//（type字段0是普通栏目，1是关键字）
@property(nonatomic,copy)NSString *type;//类型

//是否正在编辑状态
@property(nonatomic,assign)BOOL isEdit;


@end
