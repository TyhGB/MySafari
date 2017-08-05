//
//  ViewController.m
//  MySafari
//
//  Created by TyhOS on 2017/8/5.
//  Copyright © 2017年 TyhOS. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTableViewController.h"
#import "LikeTableViewController.h"

@interface ViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *_webView;
    UITextField * _seachBar;
    BOOL _isUp;
    UILabel * _titleLabel;
    UISwipeGestureRecognizer * _upSwipe;
    UISwipeGestureRecognizer * _downSwipe;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _webView.scrollView.bounces=NO;
    _webView.delegate=self;
    _isUp=NO;
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 20)];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.font=[UIFont systemFontOfSize:14];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.baidu.com"]];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [self createSearchBar];
    
    [self createGesture];
    
    [self createToolBar];
}

-(void)createSearchBar
{
    _seachBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 30)];
    _seachBar.borderStyle=UITextBorderStyleRoundedRect;
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    goBtn.frame=CGRectMake(0, 0, 30, 30);
    [goBtn setTitle:@"Go" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goWeb) forControlEvents:UIControlEventTouchUpInside];
    
    _seachBar.rightView=goBtn;
    _seachBar.rightViewMode=UITextFieldViewModeAlways;
    _seachBar.placeholder=@"请输入网址";
    self.navigationItem.titleView=_seachBar;
}

-(void)goWeb
{
    if(_titleLabel.text.length>0)
    {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_titleLabel.text]];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    else
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"输入的网址不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

-(void)createGesture
{
    _upSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipe)];
    _upSwipe.delegate=self;
    _upSwipe.direction=UISwipeGestureRecognizerDirectionUp;
    [_webView addGestureRecognizer:_upSwipe];
    
    _downSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipe)];
    _downSwipe.delegate=self;
    _downSwipe.direction=UISwipeGestureRecognizerDirectionDown;
    [_webView addGestureRecognizer:_downSwipe];
    

}

-(void)downSwipe
{
    if(_webView.scrollView.contentOffset.y==0&&_isUp)
    {
        self.navigationItem.titleView=nil;
        _webView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.frame=CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 64);
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
        } completion:^(BOOL finished) {
            self.navigationItem.titleView=_seachBar;
        }];
        [self.navigationController setToolbarHidden:NO animated:YES];
        _isUp=NO;
    }
}

-(void)upSwipe
{
        if(_isUp)
        {
            return;
        }
    self.navigationItem.titleView=nil;
    _webView.frame=CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.frame=CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 40);
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
    } completion:^(BOOL finished) {
        self.navigationItem.titleView=_titleLabel;
    }];
    [self.navigationController setToolbarHidden:YES animated:YES];
    _isUp=YES;
}

-(void)createToolBar
{
    self.navigationController.toolbarHidden=NO;
    UIBarButtonItem *itemHistory=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(goHistory)];
    UIBarButtonItem *itemLike=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(goLike)];
    UIBarButtonItem *itemBack=[[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIBarButtonItem *itemForward=[[UIBarButtonItem alloc]initWithTitle:@"forward" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    UIBarButtonItem *emptyItem2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *emptyItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *emptyItem3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems=@[itemHistory,emptyItem,itemLike,emptyItem2,itemBack,emptyItem3,itemForward];
    

}

-(void)goHistory
{
    HistoryTableViewController *controller=[[HistoryTableViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goLike
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"添加收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array=[[NSUserDefaults standardUserDefaults]valueForKey:@"Like"];
        if(!array)
        {
            array=[[NSArray alloc]init];
        }
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithArray:array];
        [newArray addObject:_webView.request.URL.absoluteString];
        [[NSUserDefaults standardUserDefaults]setValue:newArray forKey:@"Like"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
    
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"查看收藏夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LikeTableViewController *controller=[[LikeTableViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    UIAlertAction *action3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    LikeTableViewController *controller=[[LikeTableViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goBack
{
    if([_webView canGoBack])
    {
        [_webView goBack];
    }
}

-(void)goForward
{
    if([_webView canGoForward])
    {
        [_webView goForward];
    }
}

-(void)loadURL:(NSString *)urlStr
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView  loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    _titleLabel.text=webView.request.URL.absoluteString;
    NSArray * array=[[NSUserDefaults standardUserDefaults]valueForKey:@"History"];
    if(!array)
    {
        array=[[NSArray alloc]init];
    }
    NSMutableArray * newArray=[[NSMutableArray alloc]initWithArray:array];
    [newArray addObject:_titleLabel.text];
    [[NSUserDefaults standardUserDefaults]setValue:newArray forKey:@"History"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecogizerSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == _upSwipe || gestureRecognizer == _downSwipe)
    {
        return YES;
    }
    return  NO;
}
@end
