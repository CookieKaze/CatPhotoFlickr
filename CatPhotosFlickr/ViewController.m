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
#import "DetailedViewController.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) NSMutableArray * photoCollection;
@property (nonatomic) IBOutlet UICollectionView * collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoCollection = [[NSMutableArray alloc] init];
    
    //Create URL and URL request
    NSURL * url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=83a51eb8204a6855817baba646a9a662&tags=cute%20cat&per_page=100&sort=interestingness-desc"];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    
    //Create URL session and get the data
    NSURLSessionConfiguration * urlConfirm = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * urlSession = [NSURLSession sessionWithConfiguration:urlConfirm];
    NSURLSessionDataTask * dataTask = [urlSession
                                       dataTaskWithRequest:urlRequest
                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                       {
                                           //Check for error from data task
                                           if (error) {
                                               NSLog(@"Something went wrong with the data task: %@", error.localizedDescription);
                                               return;
                                           }
                                           
                                           //Store data in a dictionary and check for error with serialization
                                           NSError * err = nil;
                                           NSDictionary * flickrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                                           if (err != nil) {
                                               NSLog(@"Something went wrong with the JSON serialization: %@", error.localizedDescription);
                                               return;
                                           }
                                           
                                           //Setup photo object and store it
                                           NSArray * photos = flickrData[@"photos"][@"photo"];
                                           for (NSDictionary * photo in photos){
                                               NSString * title = photo[@"title"];
                                               
                                               //Get image after gathering the required information
                                               NSString * farmID = photo[@"farm"];
                                               NSString * serverID = photo[@"server"];
                                               NSString * flickrID = photo[@"id"];
                                               NSString * secret = photo[@"secret"];
                                               NSURL * imageUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, serverID, flickrID, secret]];
                                               
                                               //Convert image from data to UIImage
                                               NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                                               UIImage *image = [UIImage imageWithData:imageData];
                                               
                                               //Create a Photo object and store it in mutableArray
                                               Photo * myPhoto = [[Photo alloc] initWithImage:image andTitle:title andID: flickrID];
                                               [self.photoCollection addObject:myPhoto];
                                           }
                                           
                                           //Reload the collection view on main thread
                                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                               [self.collectionView reloadData];
                                           }];
                                       }];
    [dataTask resume];
    
    //Remove all spacing from flow layout
    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;
}

-(void) getPhotoInfo: (NSIndexPath *) indexPath{
    //Get Photo
    Photo * photo = self.photoCollection[indexPath.row];
    //Setup URL
    NSURL * photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getinfo&format=json&nojsoncallback=1&api_key=83a51eb8204a6855817baba646a9a662&photo_id=%@", photo.flickrID]];
    NSURLRequest * photoRequest = [NSURLRequest requestWithURL:photoUrl];
    
    //Setup Session
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * photoSession = [NSURLSession sessionWithConfiguration:config];
    
    //Get data
    NSURLSessionDataTask * photoTask = [photoSession
                                        dataTaskWithRequest:photoRequest
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (error) {
                                                NSLog(@"Something went wrong with the data task: %@", error.localizedDescription);
                                                return;
                                            }
                                            NSError * err = nil;
                                            NSDictionary * flickrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                                            if (err != nil) {
                                                NSLog(@"Something went from with the JSON serialization: %@", err.localizedDescription);
                                                return;
                                            }
                                            NSDictionary * photoDetails = flickrData[@"photo"];
                                            photo.owner = photoDetails[@"owner"][@"realname"];
                                            photo.photoDesc = photoDetails[@"description"][@"_content"];
                                            photo.url = flickrData[@"photo"][@"urls"][@"url"][0][@"_content"];
                                            
                                            self.photoCollection[indexPath.row] = photo;
                                            
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                               [self performSegueWithIdentifier:@"detailedView" sender:indexPath];
                                            }];
                                        }];
    [photoTask resume];
    
}




#pragma mark - Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo * currentPhoto =  self.photoCollection[indexPath.row];
    
    //Check if image exist
    if(currentPhoto) cell.imageView.image = currentPhoto.image;
    
    //Check if there is a title
    if ([currentPhoto.title isEqualToString: @""]) {
        cell.label.text = @"No Title";
    }else {
        cell.label.text = currentPhoto.title;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetWidth(collectionView.frame)));
}

#pragma mark - Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self getPhotoInfo: indexPath];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender {
    DetailedViewController * dvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        dvc.photo = self.photoCollection[sender.row];
    }
}

@end
