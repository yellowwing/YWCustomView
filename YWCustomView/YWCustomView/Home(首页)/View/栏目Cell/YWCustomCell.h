//
//  YWCustomCell.h
//  TZKB
//
//  Created by yellow on 2017/9/20.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWMenuStatus.h"


@class YWCustomCell;

@protocol YWCustomCellDelegate <NSObject>

@optional
-(void)customCellDidClickDeleteBtn:(YWCustomCell*)customCell;

@end


@interface YWCustomCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *customLabel;

@property(nonatomic,strong)YWMenuStatus *status;


@property(nonatomic,weak)id<YWCustomCellDelegate>delegate;

@end
