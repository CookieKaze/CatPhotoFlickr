//
//  Photo.h
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Photo : NSObject
@property (nonatomic) UIImage * image;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * owner;
@property (nonatomic) NSString * photoDesc;

- (instancetype)initWithImage: (UIImage *) image andTitle: (NSString *) title;
@end
