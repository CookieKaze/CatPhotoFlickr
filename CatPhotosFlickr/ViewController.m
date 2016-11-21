//
//  ViewController.m
//  CatPhotosFlickr
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "CollectionViewCell.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) NSMutableArray * photoCollection;
@property (nonatomic) IBOutlet UICollectionView * collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoCollection = [[NSMutableArray alloc] init];
    NSURL * url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=83a51eb8204a6855817baba646a9a662&tags=cute%20cat"];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * urlConfirm = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * urlSession = [NSURLSession sessionWithConfiguration:urlConfirm];
    NSURLSessionDataTask * dataTask = [urlSession
                                       dataTaskWithRequest:urlRequest
                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                       {
                                           if (error) {
                                               NSLog(@"Something went wrong with the data task: %@", error.localizedDescription);
                                               return;
                                           }
                                           NSError * err = nil;
                                           NSDictionary * flickrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                                           if (err != nil) {
                                               NSLog(@"Something went wrong with the JSON serialization: %@", error.localizedDescription);
                                               return;
                                           }
                                           
                                           NSArray * photos = flickrData[@"photos"][@"photo"];
                                           for (NSDictionary * photo in photos){
                                               NSString * title = photo[@"title"];
                                               
                                               //Get image after gathering the required information
                                               NSString * farmID = photo[@"farm"];
                                               NSString * serverID = photo[@"server"];
                                               NSString * flickrID = photo[@"id"];
                                               NSString * secret = photo[@"secret"];
                                               
                                               NSURL * imageUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, serverID, flickrID, secret]];
                                               
                                               NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                                               UIImage *image = [UIImage imageWithData:imageData];
                                               
                                               //Create Photo object and put it into mutableArray
                                               Photo * myPhoto = [[Photo alloc] initWithImage:image andTitle:title];
                                               [self.photoCollection addObject:myPhoto];
                                           }
                                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                               [self.collectionView reloadData];
                                           }];
                                       }];
    [dataTask resume];
    
    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo * currentPhoto =  self.photoCollection[indexPath.row];
    if(currentPhoto) cell.imageView.image = currentPhoto.image;
    if ([currentPhoto.title isEqualToString: @""]) {
        cell.label.text = @"No Title";
    }else {
        cell.label.text = currentPhoto.title;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetWidth(collectionView.frame)));
}

@end
