//
//  YWCustomView.h
//  TZKB
//
//  Created by yellow on 2017/9/19.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWCustomView,YWMenuStatus;

@protocol YWCustomViewDelegate <NSObject>

@optional
-(void)customViewDidClickCancelBtn:(YWCustomView*)customView;

-(void)customViewDidReloadData:(YWCustomView*)customView forAddMenuStatus:(YWMenuStatus *)menuStatus;

-(void)customViewDidReloadData:(YWCustomView*)customView forDeleteMenuStatus:(YWMenuStatus *)menuStatus;

-(void)customViewDidReloadData:(YWCustomView*)customView forRankMenuStatus:(YWMenuStatus *)menuStatus;

-(void)customView:(YWCustomView*)customView didClickMenuData:(YWMenuStatus*)menuStatus;

@end
@interface YWCustomView : UIView

+(instancetype)customView;


@property(nonatomic,strong)NSArray *allMenusArray;//栏目，结构是大数组包含2个小数组

@property(nonatomic,strong)NSArray *allControllersArray;//控制器，结构是大数组包含2个小数组

-(void)reloadData;

@property(nonatomic,weak)id<YWCustomViewDelegate>delegate;

@end
