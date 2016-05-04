//
//  SVGController.m
//  ImageData
//
//  Created by Galileo Guzman on 5/4/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import "SVGController.h"

@interface SVGController ()

@end

@implementation SVGController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"male" ofType:@"svg"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:fileURL];
    self.mWebView.scalesPageToFit= NO;
    self.mWebView.multipleTouchEnabled = NO;
    self.mWebView.userInteractionEnabled = YES;
    self.mWebView.scrollView.scrollEnabled = NO;
    [self.mWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ------------------------------------------------------------------
// WEB VIEW METHODS
// ------------------------------------------------------------------
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [webView setBackgroundColor:[UIColor blueColor]];
    
}
-(BOOL)webView:(UIWebView *)_viewWeb shouldStartLoadWithRequest:(NSURLRequest *)request   navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

@end
