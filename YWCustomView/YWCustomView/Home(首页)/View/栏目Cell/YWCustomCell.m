//
//  YWCustomCell.m
//  TZKB
//
//  Created by yellow on 2017/9/20.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import "YWCustomCell.h"

@interface YWCustomCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteClick:(UIButton *)sender;

@end

@implementation YWCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.customLabel.layer.cornerRadius = 14;
    self.customLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customLabel.layer.borderWidth = 0.3;
    self.customLabel.clipsToBounds = YES;
    
    self.customLabel.adjustsFontSizeToFitWidth = YES;
    
    
}

-(void)setStatus:(YWMenuStatus *)status{
    
    _status = status;
    
    self.customLabel.text = status.name;
    
    if (status.selected == YES) {
        
        self.customLabel.textColor = YWColor(240, 80, 50);
        
    }else{
        
        if (status.type.integerValue == 0) {
            
            self.customLabel.textColor = [UIColor lightGrayColor];
            
        }
        else{
            
            self.customLabel.textColor = YWColor(85, 85, 85);
            
            
        }
    }
    

    
    //假如模型正在编辑状态
    if (status.isEdit) {
        
        
        //删除按钮出现
        self.deleteBtn.hidden = NO;
        
        //图片颤抖
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform.rotation";
        
        anim.values = @[@(Angle2Radian(-5)),  @(Angle2Radian(5)), @(Angle2Radian(-5))];
        anim.duration = 0.2;
        
        // 动画的重复执行次数
        anim.repeatCount = MAXFLOAT;
        
        // 保持动画执行完毕后的状态
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        
        [self.layer addAnimation:anim forKey:@"shake"];
    }
    else{
        
        //删除按钮隐藏
        self.deleteBtn.hidden = YES;
        
        //图片不颤抖
        [self.layer removeAnimationForKey:@"shake"];
    }

    
}



- (IBAction)deleteClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customCellDidClickDeleteBtn:)]) {
        [self.delegate customCellDidClickDeleteBtn:self];
    }
    
    
}
@end
