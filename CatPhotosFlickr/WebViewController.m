//
//  WebViewController.m
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * url = [NSURL URLWithString:self.url];
    NSURLRequest * urlRequest = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:urlRequest];

}
@end
