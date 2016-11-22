
//
//  DetailedViewController.m
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "DetailedViewController.h"
#import "Photo.h"
#import "WebViewController.h"

@interface DetailedViewController ()

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.photo.image;
    self.titleLabel.text = self.photo.title;
    if(self.photo.owner) {
        self.ownerLabel.text = self.photo.owner;
    }
    if(self.photo.description) {
        self.descriptionLabel.text = self.photo.photoDesc;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController * wvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString: @"webView"]) {
        wvc.url = self.photo.url;
    }
}

@end
