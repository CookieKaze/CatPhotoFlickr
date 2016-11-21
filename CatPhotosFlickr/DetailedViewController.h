//
//  DetailedViewController.h
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;
@interface DetailedViewController : UIViewController

@property (nonatomic) Photo * photo;
@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel * descriptionLabel;

@end
