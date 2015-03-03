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

@interface LikedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) NSDictionary *AllPaintingData;
@property (nonatomic,strong) NSMutableArray *urls;
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSArray *CachedPaintings;
@property (nonatomic, strong) NSMutableArray *ImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *LikedView;

@end

@implementation LikedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AVManager *manager = [AVManager sharedInstance];
    self.session = manager.session;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:manager.wallImage.wallPicture];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImage];
    [self blurImage];
    [self.view sendSubviewToBack:backgroundImage];
    [self CDcheck];
    if (self.CachedPaintings .count == 0) {
        self.urls = [[NSMutableArray alloc]init];
        self.AllPaintingData = [[NSDictionary alloc]init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.urls = [[ServerFetcher sharedInstance]GetLikesForUser:[defaults valueForKey:@"id"]];
        self.AllPaintingData = Paintingdic;
    }

}

- (void)CDcheck{
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picture"];
    request.predicate = nil;
    NSArray *results = [context executeFetchRequest:request error:NULL];
    self.ImageArray = [[NSMutableArray alloc]init];
    self.CachedPaintings = [NSArray arrayWithArray:results];

}

-(void)viewWillAppear:(BOOL)animated{
    [self CDcheck];
    [self.LikedView reloadData];

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
    if (self.CachedPaintings == nil) {
        //return [self.urls count];

    }
    return [self.CachedPaintings count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColectionCell" forIndexPath:indexPath];
    if([[SDImageCache sharedImageCache]imageFromDiskCacheForKey:((Picture*)[self.CachedPaintings objectAtIndex:indexPath.row]).id_] == nil)
    {__block UIImageView *image = [[UIImageView alloc]init];
        self.AllPaintingData = [[ServerFetcher sharedInstance] Paintingdic];
        NSDictionary *CurrentPainting = [self.AllPaintingData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
  
        [[ServerFetcher sharedInstance]GetPictureThumbWithID:[CurrentPainting  valueForKey:@"_id" ]callback:^(UIImage *responde) {
            image.image = responde;
            NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
            [[SDImageCache sharedImageCache]storeImage:image.image forKey:[CurrentPainting valueForKey:@"_id"]];
            [Picture CreatePictureWithData:CurrentPainting inManagedobjectcontext:context];        
        }];
        
    image.frame = (CGRect){.origin.x = 0., .origin.y = 0., .size.width = 200, .size.height = 200};
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:image];
    cell.layer.borderWidth = 4.0f;
    cell.layer.borderColor = ([UIColor whiteColor]).CGColor;
    cell.layer.cornerRadius = 40;
    self.index = indexPath.row;
    } else {
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:((Picture*)[self.CachedPaintings objectAtIndex:indexPath.row]).id_];
        [self.ImageArray addObject:image.image];
        image.frame = (CGRect){.origin.x = 0., .origin.y = 0., .size.width = 200, .size.height = 200};
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:image];
        cell.layer.borderWidth = 4.0f;
        cell.layer.borderColor = ([UIColor whiteColor]).CGColor;
        cell.layer.cornerRadius = 40;
        self.index = indexPath.row;
    }

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
        if (self.ImageArray != nil) {
            ((iCaruselViewController *)segue.destinationViewController).ImageArray = self.ImageArray;
        };
        ((iCaruselViewController *)segue.destinationViewController).index = index;


    }
    if ([segue.identifier isEqualToString:@"Liked Cart"]) {
        
        
        
    }
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
