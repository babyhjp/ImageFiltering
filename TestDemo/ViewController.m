//
//  ViewController.m
//  TestDemo
//
//  Created by jzkj on 15/6/4.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ShowScrollView.h"
#import "AFNetworking.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import "GuideViewController.h"
#define KopenURL @"http://202.85.218.51:8070/soulManager/userCondition/userMatch.action"
#define KImageURL @"http://202.85.218.51:8070/soulManager"
#define UploadURL(U) [NSString stringWithFormat:@"http://202.85.218.51:8070/soulManager/userCondition/addUserCondition.action?userId=%ld&conditionIds=",U]
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define myx [UIScreen mainScreen].bounds.size.width/375.0
#define myy [UIScreen mainScreen].bounds.size.height/667.0
#define KImage @"image"
#define KMp3 @"mp3"
#define BackColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UISwipeGestureRecognizer *_imageSwipe;
    UISwipeGestureRecognizer *_mp3Swipe;
//    UITapGestureRecognizer *_imageTap;//轻拍
    NSTimer *_imageTimer;
    NSTimer *_musicTimer;
    CGRect _imageFrame;
    NSInteger _count;//当前播放的音乐
}
@property(nonatomic)NSInteger index;//标记button
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;//存储选择项
@property(nonatomic,strong)NSMutableArray *imageArray;//图片数组
@property(nonatomic,strong)NSMutableArray *mp3ImageArray;//音乐图片
@property(nonatomic,strong)AVAudioPlayer *player;//音乐
@property(nonatomic,strong)TableViewCell *lastCell;//记录上一个cell
@property(nonatomic,strong)NSMutableArray *imageDataArray;//图片数据数据
@property(nonatomic,strong)NSMutableArray *mp3DataArray;//音乐数据数组
@property(nonatomic,strong)UIActivityIndicatorView *testActivityIndicator;//指示器
@property(nonatomic,strong)NSMutableArray *allMp3Data;//音乐文件
@property(nonatomic,strong)GuideViewController *guideVC;//引导页

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = BackColor(178, 179, 194);
    //初始化所有数组
    self.imageArray=[NSMutableArray array];
    self.dataArray=[NSMutableArray array];
    self.mp3ImageArray=[NSMutableArray array];
    self.imageDataArray=[NSMutableArray array];
    self.mp3DataArray=[NSMutableArray array];
    self.allMp3Data=[NSMutableArray array];
    //创建手势
    _imageSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMp3Image:)];
    _imageSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    _mp3Swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMp3Image:)];
    _mp3Swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    _imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageView:)];
    _count = 0;//从0开始计数
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, KWidth) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BackColor(33, 34, 43);
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //tableview逆时针旋转90度。
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _tableView.center = CGPointMake(KWidth / 2, KHeight - 50);
    // scrollbar 不显示
    _tableView.showsVerticalScrollIndicator = NO;
    
    //添加引导页
        self.guideVC = [[GuideViewController alloc] init];
        [self.view addSubview:_guideVC.view];
        [_guideVC.btnBtn addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)pressButton{
    [_guideVC.view removeFromSuperview];
    
    //请求数据
    [self requestData];
}
-(void)requestData{
    _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _testActivityIndicator.center = self.view.center;
    [self.view addSubview:_testActivityIndicator];
    _testActivityIndicator.color = [UIColor redColor]; // 改变圈圈的颜色为红色；
    [_testActivityIndicator startAnimating]; // 开始旋转
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:KopenURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dic in (NSArray*)responseObject) {
            NSString *type = [dic objectForKey:@"type"];
            DataModel *model = [[DataModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([type isEqualToString:@"P"]) {
                [self.imageDataArray addObject:model];
            }
            else{
                [self.mp3DataArray addObject:model];
            }
        }
        //布局视图
        [self layoutSubViews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//启动计时器
-(void)startTimer{
    [_testActivityIndicator stopAnimating]; // 结束旋转
    [_testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    //持续下滑
    _imageTimer = [NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(imageMove) userInfo:nil repeats:YES];
    NSRunLoop * main=[NSRunLoop currentRunLoop];
    [main addTimer:_imageTimer forMode:NSRunLoopCommonModes];
}
//播放音乐
-(void)playerMusic{
    if (!_mp3ImageArray) {
        [_player stop];
        _player = nil;
        return;
    }
    if (_player.currentTime > _player.duration-1) {
        //下移
        [_mp3ImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            __block CGRect frame=[(MaterialView*)obj frame];
            [UIView animateWithDuration:1 animations:^{
                frame.origin.y += 100;
                [(UIImageView*)obj setFrame:frame];
            }];
            [(MaterialView*)obj maskView].alpha=0.6;
            [(MaterialView*)obj selectBtn].hidden = YES;
            if (frame.origin.y == KHeight - 200) {
                [(MaterialView*)obj maskView].alpha=0;
                [(MaterialView*)obj selectBtn].hidden = NO;
                [(MaterialView*)obj addGestureRecognizer:_mp3Swipe];
            }
        }];
        [_player stop];
        _player = nil;
        if ([(UIImageView*)[_mp3ImageArray lastObject] frame].origin.y >= KHeight-100) {
            //关闭音乐定时器
            [_musicTimer setFireDate:[NSDate distantFuture]];
            return;
        }
        [self requestMp3Data:_mp3DataArray[_count % _mp3DataArray.count]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//布局
-(void)layoutSubViews{
    //添加图片
    for (int i=0; i<_imageDataArray.count; i++) {
        MaterialView *materView=[[MaterialView alloc] initWithFrame:CGRectMake(120*myx , KHeight-180*i-270, 250*myx, 170)];
        materView.num = [NSString stringWithFormat:@"%@",[(DataModel*)_imageDataArray[i] modelID]];
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",KImageURL,[(DataModel*)_imageDataArray[i] url]];
        [materView.pictureView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        materView.tag=100+i;
        [materView.selectBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            materView.maskView.alpha = 0;
            materView.selectBtn.hidden = NO;
            //添加手势
            [materView addGestureRecognizer:_imageSwipe];
//            [materView addGestureRecognizer:_imageTap];
        }
        [_imageArray addObject:materView];
        [self.view addSubview:materView];
    }
    [_mp3DataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MaterialView *materView=[[MaterialView alloc] initWithFrame:CGRectMake(18*myx, KHeight -100*(idx+1)-100, 80, 80)];
        materView.num = [NSString stringWithFormat:@"%@",[(DataModel*)_imageDataArray[idx] modelID]];
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",KImageURL,[(DataModel*)_mp3DataArray[idx] smurl]];
        [materView.pictureView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        materView.pictureView.layer.cornerRadius=40;
        materView.pictureView.layer.masksToBounds=YES;
        materView.maskView.layer.cornerRadius = 40;
        materView.tag = 200 + idx;
        [materView.selectBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            materView.maskView.alpha = 0;
            materView.selectBtn.hidden = NO;
            [materView addGestureRecognizer:_mp3Swipe];
            //开启音乐计时器
            _musicTimer = [NSTimer timerWithTimeInterval:1/2 target:self selector:@selector(playerMusic) userInfo:nil repeats:YES];
            NSRunLoop * main=[NSRunLoop currentRunLoop];
            //音乐部分
            [main addTimer:_musicTimer forMode:NSRunLoopCommonModes];
            //请求数据
            [self requestMp3Data:(DataModel*)obj];
        }
        materView.userInteractionEnabled=YES;//用户交互
        [_mp3ImageArray addObject:materView];
        [self.view addSubview:materView];
    }];
    //1秒后开始计时
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:1];
    //添加tableview
    [self.view addSubview:_tableView];
}
//请求音乐数据并存储
-(void)requestMp3Data:(DataModel*)dataModel{
    //关闭定时器===========
    [_musicTimer setFireDate:[NSDate distantFuture]];
    [_player stop];
    _player = nil;
    if (_count < _mp3DataArray.count) {
        NSString *mp3Url = [NSString stringWithFormat:@"%@%@",KImageURL,dataModel.url];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:mp3Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_allMp3Data addObject:operation.responseData];
            self.player = [[AVAudioPlayer alloc] initWithData:_allMp3Data[_count] error:nil];
            [_player play];
            _count++;
            //开启定时器
            [_musicTimer setFireDate:[NSDate distantPast]];
            return ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        self.player = [[AVAudioPlayer alloc] initWithData:_allMp3Data[_count % _mp3DataArray.count] error:nil];
        [_player play];
        _count++;
        //开启定时器
        [_musicTimer setFireDate:[NSDate distantPast]];
    }
}

//滑动图片删除音乐===========
-(void)swipeMp3Image:(UISwipeGestureRecognizer*)swipe{
    [swipe.view removeFromSuperview];
    [self performSelector:@selector(addViewTolast:) withObject:swipe.view afterDelay:1.0];
    if (swipe.view.frame.size.width == 80){
        //图片下移
        [self traverseImageWith];
        if ([(UIImageView*)[_mp3ImageArray lastObject] frame].origin.y >= KHeight-100) {
            [_player stop];
            _player = nil;
            //关闭音乐定时器
            [_musicTimer setFireDate:[NSDate distantFuture]];
        }else{
            NSInteger num = [_mp3ImageArray indexOfObject:swipe.view];
            [self requestMp3Data:_mp3DataArray[num]];
        }
    }else{
        //开启定时器
        [_imageTimer setFireDate:[NSDate distantPast]];
    }
}
-(void)addViewTolast:(MaterialView*)lastView{
    //添加上被删除的view
    [self.view addSubview:lastView];
    //移动到底层
    [self.view sendSubviewToBack:lastView];
}

//点击方法图片
-(void)enlargeImageView:(UITapGestureRecognizer*)tap{
    //关闭定时器
    [_imageTimer setFireDate:[NSDate distantFuture]];
    UIImageView *bigImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 50, KWidth-100, KHeight-100)];
    bigImageView.image=[[(MaterialView*)tap.view pictureView] image];
    bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bigImageView];
    [self performSelector:@selector(dimissImage:) withObject:bigImageView afterDelay:2.0];
}
-(void)dimissImage:(UIImageView*)image{
    [image removeFromSuperview];
    //开启定时器
    [_imageTimer setFireDate:[NSDate distantPast]];
}
#pragma make -点击重选后 图片的点击方法失效
//点击 收藏或取消收藏
-(void)selectedBtnClick:(UIButton*)btn{
    MaterialView *mater = (MaterialView*)[btn superview];
    if (mater.state) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_dataArray insertObject:mater atIndex:0];
        [_tableView insertRowsAtIndexPaths:@[firstIndex] withRowAnimation:UITableViewRowAnimationMiddle];
        mater.state = NO;
    }
}
#pragma make -重选时只做了这一个处理
//初始化图片位置
-(void)initializeImageViewFrame{
    [_imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame=CGRectMake(120, KHeight-180*(idx+1)-90-180, 240, 170);
        [(MaterialView*)obj setFrame:frame];
        if (idx != 0) {
            [(MaterialView*)obj removeGestureRecognizer:_imageSwipe];
//            [(MaterialView*)obj removeGestureRecognizer:_imageTap];
        }
    }];
    [_mp3ImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame=CGRectMake(20, KHeight -100*(idx+1)-100 , 80, 80);
        [(MaterialView*)obj setFrame:frame];
        [(MaterialView*)obj maskView].alpha=0.6;
        [(MaterialView*)obj selectBtn].hidden = YES;
        [(MaterialView*)obj removeGestureRecognizer:_mp3Swipe];
        if (idx == 0) {
            [(MaterialView*)obj maskView].alpha=0;
            [(MaterialView*)obj selectBtn].hidden = NO;
            [(MaterialView*)obj addGestureRecognizer:_mp3Swipe];
        }
    }];
    
}
//图片自动移动
-(void)imageMove{
    [_imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        __block CGRect frame=[(MaterialView*)obj frame];
        [UIView animateWithDuration:0.5 animations:^{
            frame.origin.y += 180;
            [(UIImageView*)obj setFrame:frame];
            [(MaterialView*)obj maskView].alpha=0.6;
            [(MaterialView*)obj selectBtn].hidden = YES;
            if (frame.origin.y == KHeight - 270) {
                [(MaterialView*)obj maskView].alpha=0;
                [(MaterialView*)obj selectBtn].hidden = NO;
                //添加手势
                [(MaterialView*)obj addGestureRecognizer:_imageSwipe];
//                [(MaterialView*)obj addGestureRecognizer:_imageTap];
            }
        }];
        
        [(MaterialView*)obj setFrame:frame];
        [self lightLastImageView:(MaterialView*)obj];
        if (idx == _imageArray.count-1 && frame.origin.y > KHeight-100) {
            //关闭定时器  防止重复调用
            [_imageTimer setFireDate:[NSDate distantFuture]];
            [self screeningEnd];
        }
    }];
}
//点亮最后一张图片  未使用
-(void)lightLastImageView:(MaterialView*)mater{
    if (mater.frame.origin.y == KHeight - 270) {
        [mater maskView].alpha=0;
        [mater selectBtn].hidden = NO;
    }
}
//筛选结束
-(void)screeningEnd{
    
    //关闭定时器
    [_imageTimer setFireDate:[NSDate distantFuture]];
    [_player stop];
    _player = nil;
    [_musicTimer setFireDate:[NSDate distantFuture]];
    ShowScrollView *showView = [[ShowScrollView alloc] initWithFrame:self.view.bounds];
    showView.dataArray = self.dataArray;
    [showView.beginBtn addTarget:self action:@selector(bttonClick:) forControlEvents:UIControlEventTouchUpInside];
    showView.beginBtn.tag=301;
    [showView.againBtn addTarget:self action:@selector(bttonClick:) forControlEvents:UIControlEventTouchUpInside];
    showView.againBtn.tag=302;
    [self.view addSubview:showView];
}
//button点击事件
-(void)bttonClick:(UIButton*)btn{
    [btn.superview removeFromSuperview];
    if (301 == btn.tag) {
        NSInteger userId = 1;
        __block NSString *upURL = UploadURL(userId);
        [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            upURL = [upURL stringByAppendingString:[(MaterialView *)obj num]];
            upURL = [upURL stringByAppendingString:@","];
        }];
        NSString *upLoadURL = [upURL substringToIndex:(upURL.length - 1)];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:upLoadURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        return;
    }else{
        [self initializeImageViewFrame];
        [self requestMp3Data:_mp3DataArray[0]];
        //开启定时器
        [_imageTimer setFireDate:[NSDate distantPast]];
        [_musicTimer setFireDate:[NSDate distantPast]];
        return;
    }
}
//遍历视图之后的图片下移
-(void)traverseImageWith{
    [_mp3ImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = [(MaterialView*)obj frame];
        frame.origin.y += 100;
        [(MaterialView*)obj setFrame:frame];
        [(MaterialView*)obj maskView].alpha=0.6;
        [(MaterialView*)obj selectBtn].hidden = YES;
        if (frame.origin.y == KHeight - 200) {
            [(MaterialView*)obj maskView].alpha=0;
            [(MaterialView*)obj selectBtn].hidden = NO;
            [(MaterialView*)obj addGestureRecognizer:_mp3Swipe];
        }
        
    }];
}

#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KImage];
    if (!cell) {
        cell=[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KImage];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.imageAndMp3.image = [(MaterialView*)_dataArray[indexPath.row] pictureView].image;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPress.minimumPressDuration=1;//几秒响应
    longPress.allowableMovement=10;//允许移动的位置
    [cell addGestureRecognizer:longPress];
    //关闭cell 隐藏删除按钮
    _lastCell.cellState = NO;
    _lastCell.deleteImage.hidden = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.cellState) {
        //在数组中删除
        [[(MaterialView*)_dataArray[indexPath.row] selectBtn] setBackgroundImage:[UIImage imageNamed:@"notSelected.png"] forState:UIControlStateNormal];
        [(MaterialView*)_dataArray[indexPath.row] setState:YES];
        cell.cellState = NO;
        cell.deleteImage.hidden = YES;
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}
//长按时间
-(void)cellLongPress:(UILongPressGestureRecognizer*)longPress{
    _lastCell.cellState = NO;
    _lastCell.deleteImage.hidden = YES;
    [(TableViewCell*)longPress.view setCellState:YES];
    [(TableViewCell*)longPress.view deleteImage].hidden = NO;
    self.lastCell = (TableViewCell*)longPress.view;
}


@end
