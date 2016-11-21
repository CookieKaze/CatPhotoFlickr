//
//  Photo.m
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "Photo.h"

@implementation Photo
- (instancetype)initWithImage: (UIImage *) image andTitle: (NSString *) title andID: (NSString *) flickrID
{
    self = [super init];
    if (self) {
        _image = image;
        _title = title;
        _flickrID = flickrID;
    }
    return self;
}
@end
