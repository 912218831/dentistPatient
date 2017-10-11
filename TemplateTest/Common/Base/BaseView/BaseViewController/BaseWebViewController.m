//
//  MyPatientsViewController.m
//  TemplateTest
//
//  Created by HW on 2017/9/26.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseWebViewController.h"
#import "BaseWebViewModel.h"
#import <MJRefresh/MJRefresh.h>
@interface BaseWebViewController () <WKNavigationDelegate, WKScriptMessageHandler,
    WKUIDelegate>
@property (nonatomic, strong, readwrite) UIProgressView *progressView;
@property(strong,nonatomic)BaseWebViewModel * viewModel;
@end

@implementation BaseWebViewController
@dynamic view;
@dynamic viewModel;

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)loadView {
    self.view = [[WKWebView alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.viewModel.url.length > 0) {
        [self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.url]]];
    }
    else
    {
        [self.view loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"]]]];
    }
    @weakify(self);
    self.view.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.view reload];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if (self.url) {
        [self.view loadRequest:[NSURLRequest requestWithURL:self.url]];
    } else {
        [self.view loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"]]]];
    }
}

- (void)configContentView {
    [super configContentView];
    [self.contentView removeFromSuperview];
    
    _progressView  = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, 0, kScreenWidth, 5);
    _progressView.backgroundColor = [UIColor redColor];
    [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.hidden = true;
    [self.view addSubview:self.progressView];
    
    [self.view addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    self.view.navigationDelegate = self;
    self.view.UIDelegate = self;
}

- (void)bindViewModel
{
    
    [RACObserve(self.viewModel, title) subscribeNext:^(NSString * x) {
        self.navigationItem.titleView = [Utility navTitleView:x];
    }];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = false;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[self.view configuration].userContentController removeScriptMessageHandlerForName:@"bridge"];
    [[self.view configuration].userContentController addScriptMessageHandler:self name:@"bridge"];
    [self.view.scrollView.mj_header endRefreshing];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name=%@, body=%@", message.name, message.body);
}

//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.view) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.view.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.view.estimatedProgress
                              animated:animated];
        
        if (self.view.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)backMethod
{
    if (self.view.canGoBack) {
        [self.view goBack];
    }
    else
    {
        [super backMethod];
    }
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
