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

@interface LikedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) NSDictionary *AllPaintingData;
@property (nonatomic,strong) NSMutableArray *urls;
@property (nonatomic) NSUInteger index;

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.urls = [[NSMutableArray alloc]init];
    self.AllPaintingData = [[NSDictionary alloc]init];
    self.urls = [[ServerFetcher sharedInstance]GetLikesForUser:[defaults valueForKey:@"id"]];
    self.AllPaintingData = Paintingdic;


    
    
    
    
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
    return [self.urls count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.AllPaintingData = [[ServerFetcher sharedInstance] Paintingdic];
    NSDictionary *CurrentPainting = [self.AllPaintingData valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColectionCell" forIndexPath:indexPath];
   // UIImageView *image =  [[UIImageView alloc]initWithImage: [[ServerFetcher sharedInstance]GetPictureThumbWithID:[CurrentPainting  valueForKey:@"_id" ]]];
    //image.frame = (CGRect){.origin.x = 0., .origin.y = 0., .size.width = 200, .size.height = 200};
    //image.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.contentMode = UIViewContentModeScaleAspectFit;
    //[cell addSubview:image];
    cell.layer.borderWidth = 4.0f;
    cell.layer.borderColor = ([UIColor whiteColor]).CGColor;
    cell.layer.cornerRadius = 40;
    self.index = indexPath.row;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    Sesion *session = [Sesion sessionInit];
    


    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;

    
    if ([segue.identifier isEqualToString:@"LikedToPicture"]) {
        NSInteger index =  [((UICollectionView *)(((UICollectionViewCell *)sender).superview))
                            indexPathForCell:(UICollectionViewCell *)sender].row;
        dataManager.index = index;
        ((iCaruselViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;
        ((iCaruselViewController *)segue.destinationViewController).urls = self.urls;
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
