//
//  ViewController.m
//  operatingInstructions
//
//  Created by mijibao on 15/6/10.
//  Copyright (c) 2015年 mijibao. All rights reserved.
//

#import "GuideViewController.h"
#import "ZTypewriteEffectLabel.h"
//#import "MyRectXY.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define myx [UIScreen mainScreen].bounds.size.width/375.0
#define myy [UIScreen mainScreen].bounds.size.height/667.0

@interface GuideViewController ()
{
    UIScrollView *scroll;//滚动视图
    UIImageView *imageV1;//背景图片
    UIPageControl *pageCon;//分页
    UIView *viewCircle;
    UIView *viewSqure;
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBtn.tag = 44;
    [self.btnBtn setBackgroundImage:[UIImage imageNamed:@"u26.jpg"] forState:UIControlStateNormal];
    self.btnBtn.frame = CGRectMake(WIDTH/2-80, HEIGHT/2, 160, 40);
    [self configUI];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configUI{
    //背景图片
    imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    imageV1.image = [UIImage imageNamed:@"SOUL_match.jpg"];
    [imageV1 setUserInteractionEnabled:YES];
    [self.view addSubview:imageV1];
    
    pageCon = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH/2-40, HEIGHT-70, 80, 30)];
    pageCon.backgroundColor = [UIColor clearColor];
    pageCon.numberOfPages = 2;
    pageCon.currentPage = 0;
    pageCon.currentPageIndicatorTintColor = [UIColor colorWithRed:93/255.0 green:192/255.0 blue:181/255.0 alpha:1];
    pageCon.pageIndicatorTintColor = [UIColor whiteColor];
    
    //滚动视图
    scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.contentSize = CGSizeMake(WIDTH * 2, HEIGHT);
    
    [imageV1 addSubview:scroll];
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.delegate = self;
    //视图1
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    view1.tag = 15;
    [scroll addSubview:view1];
    UIImageView *littlePerson = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-60, HEIGHT/3-70, 120, 80)];
    littlePerson.image = [UIImage imageNamed:@"cat.png"];
    [view1 addSubview:littlePerson];
    [self textAnimation];
    //视图2
    [imageV1 addSubview:pageCon];
    
    
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/WIDTH;
    pageCon.currentPage = page;
    static int onlyOne =1;
    if (page == 1 && onlyOne == 1){
        if ([self respondsToSelector:@selector(secondView)]){
            NSLog(@"第二页面已经执行");
             onlyOne = 2;
        }else{
            [self secondView];
      }
    }
}
/*
 *第二页效果
 */
- (void)secondView{
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    view2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    view2.tag = 16;
    [scroll addSubview:view2];
    UIImageView *daiGanD = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-60, HEIGHT/3-100, 120, 120)];
    daiGanD.image = [UIImage imageNamed:@"ziti.png"];
    [view2 addSubview:daiGanD];
    [self performSelector:@selector(threeHeart) withObject:nil afterDelay:0.5];
}
//三个heart❤️闪动的方法
- (void)threeHeart{
    [UIView animateWithDuration:0.1 animations:^{
        UIView *view2 = (UIView *)[self.view viewWithTag:16];
    UIImageView *imageHeart = [[UIImageView alloc]initWithFrame:CGRectMake(68*myx, (675-199)*myy, 15*myx, 15*myy)];
    imageHeart.image = [UIImage imageNamed:@"smallHeart"];
    imageHeart.tag = 101;
    [view2 addSubview:imageHeart];
    
    UIImageView *imageHeart1 = [[UIImageView alloc]initWithFrame:CGRectMake((375 - 40)*myx, (667-260)*myy, 20*myx, 20*myy)];
    imageHeart1.tag = 102;
    imageHeart1.image = [UIImage imageNamed:@"smallHeart"];
    [view2 addSubview:imageHeart1];
    
    UIImageView *imageHeart2 = [[UIImageView alloc]initWithFrame:CGRectMake((375/2+15)*myx, (667/3-150)*myy, 70*myx, 60*myy)];
    imageHeart2.tag = 103;
    imageHeart2.image = [UIImage imageNamed:@"heart"];
    [view2 addSubview:imageHeart2];
    } completion:nil];
        
    [self performSelector:@selector(heart1) withObject:nil afterDelay:0.2];
    
    
}
- (void)heart1{
    UIImageView *image1 = (UIImageView *)[self.view viewWithTag:101];
    UIImageView *image2 = (UIImageView *)[self.view viewWithTag:102];
    UIImageView *image3 = (UIImageView *)[self.view viewWithTag:103];
    image1.hidden = YES;
    image2.hidden = YES;
    image3.hidden = YES;
    [self performSelector:@selector(heart2) withObject:nil afterDelay:0.2];
    
}
- (void)heart2{
    UIImageView *image1 = (UIImageView *)[self.view viewWithTag:101];
    UIImageView *image2 = (UIImageView *)[self.view viewWithTag:102];
    UIImageView *image3 = (UIImageView *)[self.view viewWithTag:103];
    image1.hidden = NO;
    image2.hidden = NO;
    image3.hidden = NO;
    //[self performSelector:@selector(heart2) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(secondAnimation) withObject:nil afterDelay:0.5];
}
- (void)secondAnimation{
    UIView *view2 = (UIView *)[self.view viewWithTag:16];
    //左边手势
    UIImageView *imageLeft = [[UIImageView alloc]initWithFrame:CGRectMake(5*myx, (667-170)*myy, 80*myx, 20*myy)];
    imageLeft.image = [UIImage imageNamed:@"left"];
    [view2 addSubview:imageLeft];
    
    UIImageView *imageLeftHand = [[UIImageView alloc]initWithFrame:CGRectMake(50*myx, (667-145)*myy, 50*myx, 50*myy)];
    imageLeftHand.image = [UIImage imageNamed:@"head"];
    imageLeftHand.tag =41;
    [view2 addSubview:imageLeftHand];
   
    //右边手势
    UIImageView *imageRight = [[UIImageView alloc]initWithFrame:CGRectMake((375 - 100)*myx, (667-210)*myy, 80*myx, 20*myy)];
    imageRight.image = [UIImage imageNamed:@"right"];
    [view2 addSubview:imageRight];
    
    UIImageView *imageRightHand = [[UIImageView alloc]initWithFrame:CGRectMake((375-120)*myx, (667-185)*myy, 50*myx, 50*myy)];
    imageRightHand.image = [UIImage imageNamed:@"hand2"];
    imageRightHand.tag =42;
    [view2 addSubview:imageRightHand];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(leftMove) userInfo:nil repeats:YES];
    [self performSelector:@selector(deletePicture) withObject:nil afterDelay:1.5];
}
- (void)leftMove{
    static int leftCount = 1;
    UIImageView *imageLeft = (UIImageView *)[self.view viewWithTag:41];
    int leftY = imageLeft.frame.origin.y;
    imageLeft.frame = CGRectMake((50-leftCount)*myx, leftY, 50*myx, 50*myy);
    UIImageView *imageRight = (UIImageView *)[self.view viewWithTag:42];
    int rithtY = imageRight.frame.origin.y;
    imageRight.frame = CGRectMake((375-120 + leftCount * 1.6)*myx, rithtY, 50*myx, 50*myy);
    leftCount ++;
    leftCount = leftCount % 50;
}
//叉号放大方法
- (void)deletePicture{
    [UIView animateWithDuration:0.1 animations:^{
    UIView *view2 = (UIView *)[self.view viewWithTag:16];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((375/2-150)*myx, (667-105)*myy, 300*myx, 20*myy)];
    label.text = @"后悔了~可以长按图片消除哦~";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label];
    } completion:^(BOOL finished) {
    [self performSelector:@selector(deletePP) withObject:nil afterDelay:0.2];
    }];
    }
- (void)deletePP{
    UIView *view2 = (UIView *)[self.view viewWithTag:16];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(70*myx, (667-80)*myy, 15*myx, 15*myy)];
    imageV.image = [UIImage imageNamed:@"close"];
    imageV.tag = 99;
    [view2 addSubview:imageV];
    [self performSelector:@selector(deleteOne) withObject:nil afterDelay:0.2];
}
- (void)deleteOne{
    UIImageView *imageV = (UIImageView *)[self.view viewWithTag:99];
    imageV.frame = CGRectMake(65*myx, (667-85)*myy, 25*myx, 25*myy);
    [self performSelector:@selector(deleteTwo) withObject:nil afterDelay:0.2];
}
- (void)deleteTwo{
    UIImageView *imageV = (UIImageView *)[self.view viewWithTag:99];
    imageV.frame = CGRectMake(70*myx, (667-80)*myy, 15*myx, 15*myy);
    [self performSelector:@selector(deleteThree) withObject:nil afterDelay:0.2];
}
- (void)deleteThree{
    UIImageView *imageV = (UIImageView *)[self.view viewWithTag:99];
    imageV.frame = CGRectMake(65*myx, (667-85)*myy, 25*myx, 25*myy);
    [self performSelector:@selector(deleteFour) withObject:nil afterDelay:0.2];
}
- (void)deleteFour{
    UIImageView *imageV = (UIImageView *)[self.view viewWithTag:99];
    imageV.frame = CGRectMake(70*myx, (667-80)*myy, 15*myx, 15*myy);
    [self performSelector:@selector(buttonB) withObject:nil afterDelay:0.2];
}
//button 快闪方法
- (void)buttonB{
    UIView *view2 = (UIView *)[self.view viewWithTag:16];
//    [self.btnBtn addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:self.btnBtn];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(buttonC) userInfo:nil repeats:YES];
}
- (void)buttonC{
    static BOOL bAndS = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:44];
    if (bAndS){
        btn.frame = CGRectMake(WIDTH/2-90, HEIGHT/2-5, 180, 50);
        bAndS = NO;
    }else{
        btn.frame = CGRectMake(WIDTH/2-80, HEIGHT/2, 160, 40);
        bAndS = YES;
    }
}
//点击button调入主界面方法
- (void)pressButton{
    [imageV1 removeFromSuperview];
}

/*
 *第一页动画效果
 */
- (void)textAnimation{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label1 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2-130, HEIGHT/3+20, 260, 30)];
    label1.typewriteEffectColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:20];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"寻找心灵相通的小伙伴?";
    [view1 addSubview:label1];
    label1.typewriteEffectBlock = ^{
        [self textLabel2];
    };
    [label1 startTypewrite];
}
- (void)textLabel2{
    UIView *view1 = (UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label2 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2-90, HEIGHT/3+55, 85, 30)];
    label2.typewriteEffectColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:27];
    label2.text = @"带上";
    label2.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:label2];
    label2.typewriteEffectBlock = ^{
        [self textLabel3];
    };
    [label2 startTypewrite];
}
- (void)textLabel3{
    UIView *view1 = (UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label2 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2, HEIGHT/3+55, 85, 30)];
    label2.typewriteEffectColor = [UIColor colorWithRed:95/255.0 green:197/255.0 blue:184/255.0 alpha:1];
    label2.font = [UIFont systemFontOfSize:27];
    label2.text = @"耳机";
    label2.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:label2];
    label2.typewriteEffectBlock = ^{
        [self textLabel4];
    };
    [label2 startTypewrite];
}
- (void)textLabel4{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label1 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2-130, HEIGHT/2-10, 130, 30)];
    label1.typewriteEffectColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:20];
    label1.textAlignment = NSTextAlignmentRight;
    label1.text = @"选择对你有";
    [view1 addSubview:label1];
    label1.typewriteEffectBlock = ^{
        [self performSelector:@selector(textLabel5) withObject:nil afterDelay:0.3];
    };
    [label1 startTypewrite];
}
- (void)textLabel5{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label5 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2+5, HEIGHT/2-10, 40, 30)];
    label5.typewriteEffectColor = [UIColor whiteColor];
    label5.typewriteTimeInterval = 0.0;
    label5.tag = 29;
    label5.font = [UIFont systemFontOfSize:20];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = @"触动";
    [view1 addSubview:label5];
    label5.typewriteEffectBlock = ^{
        [self performSelector:@selector(twinkle) withObject:nil afterDelay:0.3];
        //[self twinkle];
    };
    [label5 startTypewrite];
}
//触动 放大闪烁方法
- (void)twinkle{
    UILabel *label5 = (UILabel *)[self.view viewWithTag:29];
    label5.frame = CGRectMake(WIDTH/2, HEIGHT/2-15, 60, 40);
    label5.font = [UIFont systemFontOfSize:30];
    [self performSelector:@selector(twinkle1) withObject:nil afterDelay:0.5];
}
- (void)twinkle1{
    UILabel *label5 = (UILabel *)[self.view viewWithTag:29];
    label5.frame = CGRectMake(WIDTH/2+5, HEIGHT/2-10, 40, 30);
    label5.font = [UIFont systemFontOfSize:20];
    [self performSelector:@selector(textLabel6) withObject:nil afterDelay:0.3];
}
- (void)textLabel6{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label1 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2+45, HEIGHT/2-10, 30, 30)];
    label1.typewriteEffectColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:20];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"的";
    [view1 addSubview:label1];
    label1.typewriteEffectBlock = ^{
        [self performSelector:@selector(textLabel7) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(circleTwinkle) withObject:nil afterDelay:0.2];
        //[self twinkleWithItem:viewCircle];
    };
    [label1 startTypewrite];
}
//图片闪烁方法
//- (void)twinkleWithItem:(id)item
//{
//    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(go:) userInfo:item repeats:YES];
//}
//- (void)go:(NSTimer *)item
//{
//    static int count = 0;
//    UIView *view = (UIView *)item.userInfo;
//    static BOOL flag = YES;
//    if (flag) {
//        view.hidden = NO;
//        flag = NO;
//    }
//    else{
//        view.hidden = YES;
//        flag = YES;
//    }
//    count++;
//    if (count == 4) {
//        [item invalidate];
//        [view removeFromSuperview];
//        count = 0;
//    }
//}

- (void)textLabel7{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label1 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2-80, HEIGHT/2+20, 60, 30)];
    label1.typewriteEffectColor = [UIColor colorWithRed:95/255.0 green:197/255.0 blue:184/255.0 alpha:1];
    label1.font = [UIFont systemFontOfSize:30];
    label1.textAlignment = NSTextAlignmentRight;
    label1.text = @"音乐";
    [view1 addSubview:label1];
    label1.typewriteEffectBlock = ^{
        [self performSelector:@selector(textLabel8) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(squreTwinkle) withObject:nil afterDelay:0.9];
        //[self twinkleWithItem:viewSqure];
    };
    [label1 startTypewrite];
}
- (void)textLabel8{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    ZTypewriteEffectLabel *label1 = [[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(WIDTH/2-10, HEIGHT/2+20, 120, 30)];
    label1.typewriteEffectColor = [UIColor colorWithRed:95/255.0 green:197/255.0 blue:184/255.0 alpha:1];
    label1.font = [UIFont systemFontOfSize:30];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"& 图片";
    [view1 addSubview:label1];
    //[self twinkleWithItem:label1];
    label1.typewriteEffectBlock = ^{
        [self performSelector:@selector(textLabel9) withObject:nil afterDelay:0.3];
    };
    [label1 startTypewrite];
}
//跳转到下一个scroll页面
- (void)textLabel9{
    if (scroll.contentOffset.x == 0){
        [self performSelector:@selector(pushToNextView) withObject:nil afterDelay:0.0];
    }else{
        NSLog(@"当前在第二页面");
    }
}
- (void)pushToNextView{
    [UIView animateWithDuration:0.3 animations:^{
        scroll.contentOffset = CGPointMake(WIDTH, 0);
    } completion:nil];
    [self performSelector:@selector(secondView) withObject:nil afterDelay:0.0];
}
//音乐框闪烁方法
- (void)circleTwinkle{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
   viewCircle = [[UIView alloc]initWithFrame:CGRectMake(16 * myx, (667-190)*myy, 74 * myx, 74 * myy)];
    viewCircle.layer.borderWidth = 3;
    viewCircle.layer.cornerRadius = 34.0f;
    viewCircle.layer.borderColor = [UIColor colorWithRed:95/255.0 green:197/255.0 blue:184/255.0 alpha:1].CGColor;
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(50*myx, (667-220)*myy, 20*myx, 20*myy)];
    image1.tag = 28;
    image1.image = [UIImage imageNamed:@"arriver"];
    [view1 addSubview:image1];
    //[self twinkleWithItem:image1];
    [view1 addSubview:viewCircle];
    [self performSelector:@selector(circleOne) withObject:nil afterDelay:0.2];
}
- (void)circleOne{
    viewCircle.hidden = YES;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:28];
    image.hidden = YES;
    [self performSelector:@selector(circleTwo) withObject:nil afterDelay:0.2];
}
- (void)circleTwo{
    viewCircle.hidden = NO;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:28];
    image.hidden = NO;
    [self performSelector:@selector(circleThree) withObject:nil afterDelay:0.2];
}
- (void)circleThree{
    viewCircle.hidden = YES;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:28];
    image.hidden = YES;
}
//图片框闪烁方法
- (void)squreTwinkle{
    UIView *view1 =(UIView *)[self.view viewWithTag:15];
    viewSqure = [[UIView alloc]initWithFrame:CGRectMake(100*myx, (667-280)*myy, 250*myx, 190*myy)];
    viewSqure.layer.borderWidth = 3;
    viewSqure.layer.borderColor = [UIColor colorWithRed:95/255.0 green:197/255.0 blue:184/255.0 alpha:1].CGColor;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(210*myx, (667-240)*myy, 20*myx, 20*myy)];
    imageView.tag = 27;
    imageView.image = [UIImage imageNamed:@"arriver"];
    [view1 addSubview:imageView];
    //[self twinkleWithItem:imageView];
    [view1 addSubview:viewSqure];
    [self performSelector:@selector(squreOne) withObject:nil afterDelay:0.2];
}
- (void)squreOne{
    viewSqure.hidden = YES;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:27];
    image.hidden = YES;
    [self performSelector:@selector(squreTwo) withObject:nil afterDelay:0.2];
}
- (void)squreTwo{
    viewSqure.hidden = NO;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:27];
    image.hidden = NO;
    [self performSelector:@selector(squreThree) withObject:nil afterDelay:0.2];
}
- (void)squreThree{
    viewSqure.hidden = YES;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:27];
    image.hidden = YES;
}



@end
