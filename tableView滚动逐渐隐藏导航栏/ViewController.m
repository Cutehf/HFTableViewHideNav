//
//  ViewController.m
//  tableView滚动逐渐隐藏导航栏
//
//  Created by 黄飞 on 17/2/16.
//  Copyright © 2017年 黄飞. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *topImgView;
@property (nonatomic, assign) CGFloat alphaMemory;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //tableView初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    //    self.tableView.contentOffset = CGPointMake(0, -44);
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300)];
    backView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = backView;
    
    
    //    头部图片初始化
    self.topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300)];
    self.topImgView.image = [UIImage imageNamed:@"meinv"];
    //使得图片拉动时可以伸展效果  重要属性
    self.topImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImgView.clipsToBounds = YES;
    [self.view addSubview:self.topImgView];
    
    
    //这里写无效 设置导航栏透明
    // [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //这里写有效
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:37.0/255 green:180.0/255 blue:237.0/255 alpha:1]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试%ld",indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    scrollView.contentOffset.y
    
    NSLog(@"--+++%lf---",scrollView.contentOffset.y);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect topImgRect = self.topImgView.frame;
    if (offsetY >= 0) {
        topImgRect.origin.y = -offsetY;
        self.topImgView.frame = topImgRect;
        
        if (offsetY <= 300) {
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:offsetY/(300) >= 1 ? 1 : offsetY/(300)];
        }else if (offsetY > 300){
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
            
        }
        
    }else{
        self.topImgView.transform = CGAffineTransformMakeScale(1+offsetY/(-300), 1+offsetY/(-300));
        CGRect imgRect = self.topImgView.frame;
        imgRect.origin.y = 0;
        self.topImgView.frame = imgRect;
    }
    
}



@end
