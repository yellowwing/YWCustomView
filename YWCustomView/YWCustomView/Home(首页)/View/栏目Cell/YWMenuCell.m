//
//  YWMenuCell.m
//  TZKB
//
//  Created by yellow on 2017/5/12.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import "YWMenuCell.h"

@interface YWMenuCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YWMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
}
-(void)setStatus:(YWMenuStatus *)status{
    
    _status = status;
    
    self.titleLabel.text = status.name;
    
    if (status.isSelected) {
        self.titleLabel.textColor = mainColor;
    }
    else{
        self.titleLabel.textColor = [UIColor blackColor];
        
    }
    
    
}
@end
