//
//  YWCustomView.m
//  TZKB
//
//  Created by yellow on 2017/9/19.
//  Copyright © 2017年 TZKB. All rights reserved.
//

#import "YWCustomView.h"

#import "YWMenuStatus.h"

#import "YWCustomCell.h"

#import "CustomHeaderView.h"

#define customID @"custom"

#define headerID @"customHeader"

@interface YWCustomView ()<UICollectionViewDelegate,UICollectionViewDataSource,YWCustomCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

- (IBAction)cancelClick:(UIButton *)sender;

- (IBAction)editClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,weak)YWCustomCell *longPressCell;

@property (weak, nonatomic) IBOutlet UILabel *editLabel;

@property(nonatomic,weak)UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation YWCustomView





+(instancetype)customView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"YWCustomView" owner:nil options:nil].lastObject;
}



//重写allMenusArray
-(void)setAllMenusArray:(NSArray *)allMenusArray{
    
    //存储
    _allMenusArray = allMenusArray;

    
    //刷新列表
    [self.collectionView reloadData];
    
}

//重写allControllersArray
-(void)setAllControllersArray:(NSArray *)allControllersArray{
    
    //存储
    _allControllersArray = allControllersArray;
    
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.editBtn.layer.cornerRadius = 10;
    
    self.editBtn.layer.borderColor = YWColor(255, 50, 0).CGColor;
    
    self.editBtn.layer.borderWidth = 1;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YWCustomCell" bundle:nil] forCellWithReuseIdentifier:customID];
    
    //注册创建header
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
}


//从缓存池拿出footer或者header
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *resuableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        return nil;
        
    }
    else if (kind == UICollectionElementKindSectionHeader){
        
        CustomHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        
        resuableview = headerview;
        
    }
    
    return resuableview;
    
}

//header 大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    }
    else{
        return CGSizeMake(0, 0);
    }
}


//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //编辑状态下只显示一组
    if (self.editBtn.selected) {
        return 1;
    }
    
    //数量和大数组一样
    return self.allMenusArray.count;
}

//返回每组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //第几组
    NSArray *sec = self.allMenusArray[section];
    
    //每组个数
    return sec.count;
    
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //拿出cell
    YWCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:customID forIndexPath:indexPath];
    
    cell.delegate = self;
    
    //拿出小数组
    NSArray *sec = self.allMenusArray[indexPath.section];
    
    //传递模型
    cell.status = sec[indexPath.item];
    
    //返回cell
    return cell;
    
}

//点击cell方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //拿出模型
    YWMenuStatus *status = self.allMenusArray[indexPath.section][indexPath.item];
    
    YWLog(@"点击了%@",status.name);
    
    //假如点击的是第0组
    if (indexPath.section == 0 && self.editBtn.selected == NO) {
        
    //直接收起customView
        [self cancelClick:nil];
        
    //通过代理叫上一个控制器跳去该去的控制器
        if ([self.delegate respondsToSelector:@selector(customView:didClickMenuData:)]) {
            [self.delegate customView:self didClickMenuData:status];
        }
        
        
    }
    
    //第一组后要移到第0组后
    else{
        
        //假如在编辑环境下不能从第一组添加栏目到第0组
        if (self.editBtn.selected == YES) {
            return;
        }
        
        //拿出第1组（源数组）
        NSMutableArray *sorceArray = self.allMenusArray[indexPath.section];
        
        //拿出第0组（目标数组）
        NSMutableArray *destinationArray = self.allMenusArray[0];
        
        //拿出模型
        id objc = [sorceArray objectAtIndex:indexPath.item];
        
        //从源数组中移除该数据
        [sorceArray removeObject:objc];
        
        //将数据插入到资源数组中的目标位置上
        [destinationArray addObject:objc];
        
        //改变样式
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:destinationArray.count-1 inSection:0]];
        
        //拿出第1组（源数组）
        NSMutableArray *sorceControllersArray = self.allControllersArray[indexPath.section];
        
        //拿出第0组（目标数组）
        NSMutableArray *destinationControllersArray = self.allControllersArray[0];
        
        id controller = [sorceControllersArray objectAtIndex:indexPath.item];
        
        //从第1组移除模型
        [sorceControllersArray removeObject:controller];
        
        //把模型添加到第0组
        [destinationControllersArray addObject:controller];
        
        //添加栏目后刷新上一个控制器的栏目数据
        if ([self.delegate respondsToSelector:@selector(customViewDidReloadData:forAddMenuStatus:)]) {
            [self.delegate customViewDidReloadData:self forAddMenuStatus:(YWMenuStatus*)objc];
        }
        
    }
    
}


//长按手势拖拽排序
- (void)handlepanGesture:(UIPanGestureRecognizer *)panGesture {
    
    //判断手势状态
    switch (panGesture.state) {
            
            //一开始拖拽
        case UIGestureRecognizerStateBegan:{
            
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            
            //假如不是在indexPath范围内的，直接返回
            if (indexPath == nil) {
                break;
            }
            
            YWCustomCell *cell = (YWCustomCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            self.longPressCell = cell;
            
            YWMenuStatus *menuStatus = self.allMenusArray[indexPath.section][indexPath.item];
            
            //放大
            [UIView animateWithDuration:0.2 animations:^{
               
                if (self.editBtn.selected && indexPath.section == 0 && menuStatus.type.integerValue == 1) {
                    
                   cell.customLabel.transform = CGAffineTransformMakeScale(1.12, 1.12);
                    
                }
            }];
            
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            //获取正在移动的位置
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            
            //不能与普通栏目交换
            YWMenuStatus *menuStatus = self.allMenusArray[indexPath.section][indexPath.item];
            
            if (menuStatus.type.integerValue == 0) {
                break;
            }
            
            
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[panGesture locationInView:self.collectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
        
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            
            //变回原来大小
            [UIView animateWithDuration:0.2 animations:^{
                
                self.longPressCell.customLabel.transform = CGAffineTransformIdentity;
                
            }];
        }
            
            
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

//是否允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //普通栏目不能被移动
    YWMenuStatus *menuStatus = self.allMenusArray[indexPath.section][indexPath.item];
    
    if (menuStatus.type.integerValue == 0) {
        return  NO;
    }
    
    //一定要在第0组并且编辑模式下才可以移动，不然不可以
    if (indexPath.section == 1 || self.editBtn.selected == NO) {
      return  NO;
    }
    
    //返回YES允许其item移动
    return YES;
}

//当手势移动成功后会调用这个方法 ，这个方法用来改变模型，因为在手势里一直都是改变样式并没有改变模型
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    //从大数组取出源数组
    NSMutableArray *menuSorceArray = self.allMenusArray[sourceIndexPath.section];
    
    //从大数组取出目标数组
    NSMutableArray *menuDestinationArray = self.allMenusArray[destinationIndexPath.section];
    
    //拿出改变的模型
    id objc = [menuSorceArray objectAtIndex:sourceIndexPath.item];
    
    //从源数组中移除该数据
    [menuSorceArray removeObject:objc];
    
    //将数据插入到资源数组中的目标位置上
    [menuDestinationArray insertObject:objc atIndex:destinationIndexPath.item];
    
    //改变了控制器数组
    //从大数组取出源数组
    NSMutableArray *controllerSorceArray = self.allControllersArray[sourceIndexPath.section];
    
    //从大数组取出目标数组
    NSMutableArray *controllerDestinationArray = self.allControllersArray[destinationIndexPath.section];
    
    //拿出改变的模型
    id controller = [controllerSorceArray objectAtIndex:sourceIndexPath.item];
    
    //从源数组中移除该数据
    [controllerSorceArray removeObject:controller];
    
    //将数据插入到资源数组中的目标位置上
    [controllerDestinationArray insertObject:controller atIndex:destinationIndexPath.item];
    
    //排序栏目后刷新上一个控制器的栏目数据
    if ([self.delegate respondsToSelector:@selector(customViewDidReloadData:forRankMenuStatus:)]) {
        [self.delegate customViewDidReloadData:self forRankMenuStatus:(YWMenuStatus*)objc];
    }
    
}


//取消
- (IBAction)cancelClick:(UIButton *)sender {
    
    self.editBtn.selected = NO;
    
    self.editLabel.text = @"切换栏目";
    
    //拿出第一组的数组
    NSMutableArray *menuArray = self.allMenusArray[0];
    
    for (YWMenuStatus *menuStatus in menuArray) {
        
        //假如是关键字的模型
        if (menuStatus.type.integerValue == 1) {
            
            menuStatus.isEdit = NO;
        }
        
    }
    
    [_collectionView removeGestureRecognizer:self.longPressRecognizer];
    
    //刷新列表，进入编辑状态
    [self.collectionView reloadData];
    
    
    if ([self.delegate respondsToSelector:@selector(customViewDidClickCancelBtn:)]) {
        [self.delegate customViewDidClickCancelBtn:self
         ];
    }
}

//编辑
- (IBAction)editClick:(UIButton *)sender {
    
    self.editBtn.selected = !self.editBtn.selected;
    
    //假如是编辑状态
    if (self.editBtn.selected) {
        
        self.editLabel.text = @"长按排序标签";
        
        //拿出第一组的数组
        NSMutableArray *menuArray = self.allMenusArray[0];
        
        for (YWMenuStatus *menuStatus in menuArray) {
            
            //假如是关键字的模型
            if (menuStatus.type.integerValue == 1) {
                
                menuStatus.isEdit = YES;
            }
            
        }
        
        //解决collectionView手势冲突，拖拽手势变成长按手势
        //此处给collectionView增加长按的拖拽手势，用此手势触发cell移动效果
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGesture:)];
        longPress.minimumPressDuration = 0.1;
        [_collectionView addGestureRecognizer:longPress];
        self.longPressRecognizer = longPress;
        
        
        
    }
    //假如不是编辑状态
    else{
        
        self.editLabel.text = @"切换栏目";
        
        //拿出第一组的数组
        NSMutableArray *menuArray = self.allMenusArray[0];
        
        for (YWMenuStatus *menuStatus in menuArray) {
            
            //假如是关键字的模型
            if (menuStatus.type.integerValue == 1) {
                
                menuStatus.isEdit = NO;
            }
            
        }
        
        
        [_collectionView removeGestureRecognizer:self.longPressRecognizer];
    
    }
    

    //刷新列表，进入编辑状态
    [self.collectionView reloadData];
}


//YWCustomCell代理
-(void)customCellDidClickDeleteBtn:(YWCustomCell *)customCell{

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:customCell];
    
    //获取你点击的模型
    YWMenuStatus *menuStatus = self.allMenusArray[indexPath.section][indexPath.item];
    
    //普通栏目不能删除
    if (menuStatus.type.integerValue == 0) {
        return;
    }
    
    menuStatus.isEdit = NO;
    
    //拿出第0组（源数组）
    NSMutableArray *sorceArray = self.allMenusArray[indexPath.section];
    
    //拿出第一组（目标数组）
    NSMutableArray *destinationArray = self.allMenusArray[1];
    
    //从源数组中移除该数据
    [sorceArray removeObject:menuStatus];
    
    //将数据插入到资源数组中的目标位置上
    [destinationArray addObject:menuStatus];
    
    //刷新列表
    [self.collectionView reloadData];
    
    
    //拿出第1组（源数组）
    NSMutableArray *sorceControllersArray = self.allControllersArray[indexPath.section];
    
    //拿出第1组（目标数组）
    NSMutableArray *destinationControllersArray = self.allControllersArray[1];
    
    id controller = [sorceControllersArray objectAtIndex:indexPath.item];
    
    //从第1组移除模型
    [sorceControllersArray removeObject:controller];
    
    //把模型添加到第0组
    [destinationControllersArray addObject:controller];

    //删除栏目后刷新上一个控制器的栏目数据
    if ([self.delegate respondsToSelector:@selector(customViewDidReloadData:forDeleteMenuStatus:)]) {
        [self.delegate customViewDidReloadData:self forDeleteMenuStatus:menuStatus];
    }
    
    

}


-(void)reloadData{
    
    [self.collectionView reloadData];
    
}

@end
