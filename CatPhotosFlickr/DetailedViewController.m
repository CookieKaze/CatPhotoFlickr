//
//  DetailedViewController.m
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "DetailedViewController.h"
#import "Photo.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
