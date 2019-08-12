//
//  YWHomeController.m
//  YWCustomView
//
//  Created by yellow on 2019/8/8.
//  Copyright © 2019 YW. All rights reserved.
//

#import "YWHomeController.h"

#import "YWListController.h"

#import "YWListVCStatus.h"

//栏目
#import "YWMenuStatus.h"
#import "YWMenuCell.h"

#import "YWCustomView.h"


#define menuID @"menu"

#define menuCellWidth 60

#define menuHeight 40

#define lineWidth 15

#define lineOffsetX (menuCellWidth-lineWidth)/2

#define lineHeight 1.5

#define lineOffsetY menuHeight-lineHeight

@interface YWHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPageViewControllerDataSource,UIPageViewControllerDelegate,YWCustomViewDelegate>

@property (nonatomic, strong) NSMutableArray *contentViewControllers; //ViewControllers数组

@property (nonatomic, strong) UIPageViewController *pageViewController;//pageViewController

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;//栏目collectionView

@property (weak, nonatomic) IBOutlet UIView *menuBgView;//栏目背面的view

@property (nonatomic,strong)NSMutableArray *menuArray;//装栏目的数组

@property (nonatomic,strong)YWMenuStatus *selectedMenuStatus;//被选中的模型

@property (weak, nonatomic) UIView *lineView;//那条红线

- (IBAction)addMenuClick;

@property (weak, nonatomic) IBOutlet UIButton *addMenuBtn;

@property(nonatomic,weak)YWCustomView *customView;//自定制栏目

@property(nonatomic,strong)NSMutableArray *notUseMenuArray;//不需要显示的栏目

@property (nonatomic, strong) NSMutableArray *notUseViewControllers; //不需要显示的ViewControllers数组

@property (weak, nonatomic) IBOutlet UIView *navBar; //这个demo就不弄navigationController了，就弄个view

@end

@implementation YWHomeController
 

-(NSMutableArray*)menuArray{
    if (_menuArray == nil) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
}

-(NSMutableArray*)notUseMenuArray{
    if (_notUseMenuArray == nil) {
        _notUseMenuArray = [NSMutableArray array];
    }
    return _notUseMenuArray;
}


-(NSMutableArray*)contentViewControllers{
    
    if (_contentViewControllers == nil) {
        _contentViewControllers = [NSMutableArray array];
    }
    return _contentViewControllers;
}

-(NSMutableArray*)notUseViewControllers{
    
    if (_notUseViewControllers == nil) {
        _notUseViewControllers = [NSMutableArray array];
    }
    return _notUseViewControllers;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //注册栏目cellID
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"YWMenuCell" bundle:nil] forCellWithReuseIdentifier:menuID];
    
    //创建lineView，add在collectionView上面
    [self setupLineView];
    
    
    //创建定制栏目
    [self setupCustomView];
    
    //加载大栏目数据
    [self loadMenuData];
}


//创建lineView，add在collectionView上面
-(void)setupLineView{
    UIView *lineView = [[UIView alloc] init];
    [self.menuCollectionView addSubview:lineView];
    lineView.backgroundColor = mainColor;
    self.lineView = lineView;
    lineView.layer.cornerRadius = 1;
    
    CGFloat x = lineOffsetX;
    CGFloat h = lineHeight;
    CGFloat w = lineWidth;
    CGFloat y = self.menuCollectionView.frame.size.height - lineHeight;
    
    lineView.frame = CGRectMake(x, y, w, h);
}

//创建定制栏目
-(void)setupCustomView{
    
    
    YWCustomView *customView = [YWCustomView customView];
    CGFloat customY = CGRectGetMinY(self.menuBgView.frame);
    customView.frame = CGRectMake(0, customY, Wi, He - customY);
    
    [self.view addSubview:customView];
    
    customView.delegate = self;
    
    self.customView = customView;
    
    self.customView.transform = CGAffineTransformMakeTranslation(0, -self.customView.frame.size.height);
    
}


//加载栏目数据
-(void)loadMenuData{
    
    //这里应该是加载接口获取数据模型的，现在我这里就弄一些假数据完成这个demo
    //正在显示的频道
    NSArray *array1 = @[@"首页",@"广州",@"地产",@"财经",@"汽车",@"体育",@"NBA",@"CBA",@"科技",@"传媒"];
    
    for (NSInteger i = 0; i < array1.count; i++) {
        YWMenuStatus *status = [[YWMenuStatus alloc] init];
        status.name = array1[i];
        if (i == 0 || i ==1) { //第一个和第二个固定不变不能进行编辑的
            
            status.type = @"0";
            
        }
        else{ //其余的可以进行编辑
            
            
            status.type = @"1";
        }
        
        [self.menuArray addObject:status];
    }
    
    //频道选择的
    NSArray *array2 = @[@"军事",@"星座",@"情感",@"音乐",@"电影",@"国际",@"历史",@"时尚",@"娱乐",@"育儿"];
    
    for (NSInteger i = 0; i < array2.count; i++) {
        YWMenuStatus *status = [[YWMenuStatus alloc] init];
        status.name = array2[i];
  
        status.type = @"1"; //可以进行编辑
        
        [self.notUseMenuArray addObject:status];
    }
    
    
    //从数组拿出第一个模型选中
    YWMenuStatus *homeMenu = self.menuArray[0];

    homeMenu.selected = YES;

    self.selectedMenuStatus = homeMenu;


    //刷新列表
    [self.menuCollectionView reloadData];

    
    //建立pageViewController
    [self pageViewController];
    
    //把自定制栏目和menuView放上来最上面
    [self.view bringSubviewToFront:self.customView];
    
    [self.view bringSubviewToFront:self.menuBgView];
    
    [self.view bringSubviewToFront:self.navBar];
    

    
    //向customView赋予数据，它自动在数组的set方法会刷新的
    self.customView.allControllersArray = @[self.contentViewControllers,self.notUseViewControllers];
    
    self.customView.allMenusArray = @[self.menuArray,self.notUseMenuArray];
    
    
}


#pragma mark - collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.menuArray.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YWMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menuID forIndexPath:indexPath];
    
    cell.status = self.menuArray[indexPath.item];
    
    return cell;
    
}

//定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(menuCellWidth, self.menuCollectionView.bounds.size.height);
    
}

//定义每个UICollectionView的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置垂直间距,默认的垂直和水平间距都是0
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


//上面collectionView控制下面的
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //改变menu高亮位置
    [self changeMenuHighLightOfIndex:indexPath.item];
    
    YWListController *vc = self.contentViewControllers[indexPath.item];
    
    //显示当前controller到pageViewController
    [self.pageViewController setViewControllers:[NSArray arrayWithObjects:vc, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}



//lineView移动动画
-(void)moveLineViewAnimationWithIndexPath:(NSIndexPath*)indexPath{
    
    //lineView动画移动
    
    CGFloat x = indexPath.item * menuCellWidth + lineOffsetX;

    //执行动画
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(x, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }];
    
    
}


#pragma mark ----- UIPageViewControllerDataSource -----
/**
 *  @brief 点击或滑动 UIPageViewController 左侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回前一个视图控制器
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        
        return nil;
        
    } else {
        
        index--;
        
        return [self viewControllerAtIndex:index];
    }
    
    
}

/**
 *  @brief 点击或滑动 UIPageViewController 右侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回下一个视图控制器
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index == [self.contentViewControllers count] - 1 || index == NSNotFound) {
        
        return nil;
        
    }
    else{
        
        index++;
        
        return [self viewControllerAtIndex:index];
        
    }
    
}

//改变menu高亮位置
-(void)changeMenuHighLightOfIndex:(NSInteger)index{
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.menuCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    //执行lineView移动动画
    [self moveLineViewAnimationWithIndexPath:currentIndexPath];
    
    //把之前的模型设置为NO
    self.selectedMenuStatus.selected = NO;
    
    //拿出现在的模型
    YWMenuStatus* status = self.menuArray[currentIndexPath.item];
    
    //设置为选中
    status.selected = YES;
    
    //self.selectedColumnStatus指向status
    self.selectedMenuStatus = status;
    
    //刷新列表
    [self.menuCollectionView reloadData];
    
    //刷新一下customView
    [self.customView reloadData];
    
    
}


//通过数组找到controller的位置
- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.contentViewControllers indexOfObject:viewController];
}

//通过位置找到controller
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= [self.contentViewControllers count]) {
        return nil;
    }
    UIViewController *vc = [self.contentViewControllers objectAtIndex:index];
    return vc;
}



#pragma mark ----- UIPageViewControllerDelegate -----
//将会跳到下一个控制器的时候调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    
    
}

//已经完成跳转的时候调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed == YES) {
        
        // UIPageViewController有个属性viewControllers，如果是单页的书籍，那个数组里就只有一个对象，就是当前显示的viewController
        
        //这里要判断是哪个控制器
        
        id currentVC = pageViewController.viewControllers[0];
        
        NSInteger index = [self.contentViewControllers indexOfObject:currentVC];
        
        [self changeMenuHighLightOfIndex:index];
    }
       
}

//要先加载完数据才创建pageViewController和数组里面的子控制器
//初始化pageViewController
- (UIPageViewController *)pageViewController
{
    //假如一开始pageViewController不存在的话
    if(!_pageViewController)
    {
        //字典
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        
        //初始化
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        
        //就是在这里改变大小了
        CGFloat pageY = CGRectGetMaxY(self.menuBgView.frame);
        
        [[_pageViewController view] setFrame:CGRectMake(0, pageY, self.view.frame.size.width, self.view.frame.size.height - pageY)];
        
        
        //这里有3种情况：1首页、2视频、3其它
        
        //这里要用for循环创建控制器（和加载出来的栏目数据数组个数一样多）
        for (NSInteger i = 0; i < self.menuArray.count; i++) {
            
            YWListController *vc = [[YWListController alloc] initWithNibName:@"YWListController" bundle:nil];
            
            vc.view.backgroundColor = YWRandomColor;
        
            YWListVCStatus *vcStatus = [[YWListVCStatus alloc] init];
            
            
            //把控制器赋予模型
            vc.status = vcStatus;
                
            //把控制器添加到数组
            [self.contentViewControllers addObject:vc];
            
            
            
        }
        
        //添加与处理暂时不显示的控制器数组
        for (NSInteger i = 0; i < self.notUseMenuArray.count; i++) {
            
            //这里创建多个控制器
            YWListController *vc = [[YWListController alloc] initWithNibName:@"YWListController" bundle:nil];
            
            vc.view.backgroundColor = YWRandomColor;
            
            //创建模型
            YWListVCStatus *vcStatus = [[YWListVCStatus alloc] init];
            
            //把控制器赋予模型
            vc.status = vcStatus;
            
            //把控制器添加到不显示的数组上
            [self.notUseViewControllers addObject:vc];
            
        }
        
        
        //拿出第一个控制器
        YWListController *firstVC = self.contentViewControllers[0];
        
        //显示第一个controller到pageViewController
        [_pageViewController setViewControllers:[NSArray arrayWithObjects:firstVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        
        
        //设置代理
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        //把pageViewController作为子控制器添加到新闻控制器上
        [self addChildViewController:_pageViewController];
        
        //把pageViewController的view添加到新闻控制器的view上
        [self.view addSubview:_pageViewController.view];
        
        
    }
    return _pageViewController;
    
}


#pragma mark - 自定义栏目
//栏目添加删除排序选择
- (IBAction)addMenuClick {
    
    //    当下降customView的时候要隐藏tabBar和隐藏menuBgView。收起的时候就显示回出来
    
    // 执行动画
    [UIView animateWithDuration:0.2 animations:^{
        
        self.customView.transform = CGAffineTransformIdentity;
        
        self.menuBgView.alpha = 0;
        
        self.tabBarController.tabBar.alpha = 0;
        
    }];
}

//customView代理
-(void)customViewDidClickCancelBtn:(YWCustomView *)customView{
    
    // 执行动画
    [UIView animateWithDuration:0.2 animations:^{
        
        self.customView.transform = CGAffineTransformMakeTranslation(0, -self.customView.frame.size.height);
        
        self.menuBgView.alpha = 1;
        
        self.tabBarController.tabBar.alpha = 1;
        
        
    }];
    
    
}

//刷新栏目
//新添加栏目
-(void)customViewDidReloadData:(YWCustomView *)customView forAddMenuStatus:(YWMenuStatus *)menuStatus{
    
    //数组数据发生改变，刷新栏目
    [self.menuCollectionView reloadData];
    
    //取出正在选中的位置
    NSInteger item = [self.menuArray indexOfObject:self.selectedMenuStatus];
    
    //封装成indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    //直接调用上面控制器控制下面跳转的方法
    [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:indexPath];
    
    
}

//重新排序栏目
-(void)customViewDidReloadData:(YWCustomView *)customView forRankMenuStatus:(YWMenuStatus *)menuStatus{
    
    //数组数据发生改变，刷新栏目
    [self.menuCollectionView reloadData];
    
    //重新点击你之前选中的栏目
    NSInteger item = [self.menuArray indexOfObject:self.selectedMenuStatus];
    
    //封装成indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    //直接调用上面控制器控制下面跳转的方法
    [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:indexPath];
    
    
}

//删除栏目
-(void)customViewDidReloadData:(YWCustomView *)customView forDeleteMenuStatus:(YWMenuStatus *)menuStatus{
    
    //数组数据发生改变，刷新栏目
    [self.menuCollectionView reloadData];
    
    //假如删除了正在选中的模型
    if (self.selectedMenuStatus.cltId.integerValue == menuStatus.cltId.integerValue) {
        
        //封装成indexPath（默认选中第一个item）
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        //直接调用上面控制器控制下面跳转的方法
        [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:indexPath];
        
        
    }
    
}

//跳去该去的控制器
-(void)customView:(YWCustomView *)customView didClickMenuData:(YWMenuStatus *)menuStatus{
    
    //取出你点击的位置
    NSInteger item = [self.menuArray indexOfObject:menuStatus];
    
    //封装成indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    //直接调用上面控制器控制下面跳转的方法
    [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:indexPath];
    
    
}


@end
