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
    
    
    
    [self setupWebViewForMale:NO];
    
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
    
    // Break apart request URL
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    // Check for your protocol
    if ([components count] > 1 &&
        [(NSString *)[components objectAtIndex:0] isEqualToString:@"ulnaxapp"])
    {
        // Look for specific actions
        if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"bodyPartSelected"])
        {
            // Your parameters can be found at
            //   [components objectAtIndex:n]
            // where 'n' is the ordinal position of the colon-delimited parameter
            
            NSString *bodyPart = [components objectAtIndex:2];
            
            [self showMessageWithInfoBodyPart:bodyPart];
        }
        
        // Return 'NO' to prevent navigation
        return NO;
    }
    
    // Return 'YES', navigate to requested URL as normal
    return YES;
}

-(void)showMessageWithInfoBodyPart:(NSString*)bodyPart{
    
    NSString *msg = [NSString stringWithFormat:@"You selected %@", bodyPart];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Body Part"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) setupWebViewForMale:(BOOL)male{
    
    NSString *svgFile = (male) ? @"male" : @"female";
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:svgFile ofType:@"svg"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:fileURL];
    self.mWebView.scalesPageToFit= NO;
    self.mWebView.multipleTouchEnabled = NO;
    self.mWebView.userInteractionEnabled = YES;
    self.mWebView.scrollView.scrollEnabled = NO;
    [self.mWebView loadRequest:req];

}

@end
