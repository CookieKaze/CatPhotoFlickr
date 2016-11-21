//
//  CollectionViewCell.h
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UILabel * label;

@end
