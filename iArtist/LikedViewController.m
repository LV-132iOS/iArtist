//
//  AVLikedViewController.m
//  iArtist
//
//  Created by Andrii V. on 03.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LikedViewController.h"
#import "AVPicture.h"
#import "iCaruselViewController.h"
#import "ServerFetcher.h"
#import "SDImageCache.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Picture+Create.h"
#import "SessionControl.h"
#import "SDWebImageManager.h"

@interface LikedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) NSDictionary *AllPaintingData;
@property (nonatomic,strong) NSMutableArray *urls;
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSArray *CachedPaintings;
@property (nonatomic, strong) NSMutableArray *ImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *LikedCollectionView;

@end

@implementation LikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urls = [[NSMutableArray alloc]init];
    self.ImageArray = [[NSMutableArray alloc]init];
    [self CDRequest];
}

- (void)CDRequest{
    AVManager *manager = [AVManager sharedInstance];
    self.session = manager.session;
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:manager.wallImage.wallPicture];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImage];
    [self blurImage];
    [self.view sendSubviewToBack:backgroundImage];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picture"];
    request.predicate = nil;
    self.CachedPaintings = [context executeFetchRequest:request error:NULL];
    if ([[SessionControl sharedManager]checkInternetConnectionWithHandler:nil]) {
        [[ServerFetcher sharedInstance]GetLikesForUser:@"" callback:^(NSMutableArray *responde) {
            self.urls = responde;
            NSDictionary *dic= [[ServerFetcher sharedInstance]Paintingdic];
            if (self.CachedPaintings.count < responde.count) {
                      __block NSInteger count = responde.count-1;
                for(int i = 0;i<responde.count;i++){
                            [[SDWebImageManager sharedManager]downloadImageWithURL:self.urls[i] options: SDWebImageHighPriority progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [[SDImageCache sharedImageCache]storeImage:image forKey:[dic valueForKeyPath:[NSString stringWithFormat:@"%d._id",i]]];
                                [Picture CreatePictureWithData:[dic valueForKey:[NSString stringWithFormat:@"%d",i]] inManagedobjectcontext:context];
                                if (i == count) {
                                    [self CDRequest];
                                    [self.LikedCollectionView reloadData];
                                }

                }];
              }
          }
       }];
    };
}


-(void)blurImage
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.frame;
    [self.view addSubview:visualEffectView];
    [self.view sendSubviewToBack:visualEffectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
        return self.CachedPaintings.count;

}




// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColectionCell" forIndexPath:indexPath];
//{
    cell.tag = indexPath.item;
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:((Picture*)[self.CachedPaintings objectAtIndex:indexPath.item]).id_];
        [self.ImageArray addObject:image.image];
        image.frame = (CGRect){.origin.x = 0., .origin.y = 0., .size.width = 200, .size.height = 200};
        image.contentMode = UIViewContentModeScaleAspectFit;
        cell.contentMode = UIViewContentModeScaleAspectFit;
        if (cell.subviews != nil){
            [[cell.subviews firstObject] removeFromSuperview];
        }
        [cell addSubview:image];
        cell.layer.borderWidth = 4.0f;
        cell.layer.borderColor = ([UIColor whiteColor]).CGColor;
        cell.layer.cornerRadius = 40;

   // }
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    Sesion *session = [Sesion sessionInit];
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;

    
    if ([segue.identifier isEqualToString:@"LikedToPictures"]) {
        NSInteger index =  [((UICollectionView *)(((UICollectionViewCell *)sender).superview))
                            indexPathForCell:(UICollectionViewCell *)sender].row;
        dataManager.index = index;
        ((iCaruselViewController *)segue.destinationViewController).urls = self.urls;
    ((iCaruselViewController *)segue.destinationViewController).index = ((UICollectionViewCell *)sender).tag;
        
        ((iCaruselViewController *)segue.destinationViewController).ImageArray = self.ImageArray;
    }
 
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self CDRequest];
    [self.LikedCollectionView reloadData];
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
