//
//  AVPictureViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVPictureViewController.h"
#import "ServerFetcher.h"
#import <CoreData/CoreData.h>
#import "AsyncImageView.h"

@interface AVPictureViewController ()

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSDictionary *PaintingData;
@property (nonatomic, strong) ServerFetcher *DownloadManager;
@property (nonatomic) NSInteger likeCounter;
@property (strong, nonatomic) UILabel *likeCounterLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToCart;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet iCarousel *pictureView;
@property (strong, nonatomic) IBOutlet UIToolbar *upToolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarBatton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarBautton;
@property (strong, nonatomic) IBOutlet UILabel *titleOfSession;
@property (strong, nonatomic) IBOutlet UIButton *authorButton;
@property (strong, nonatomic) IBOutlet UIButton *previewOnWallButton;
@property (strong, nonatomic)  UILabel *authorsName;
@property (strong, nonatomic)  UILabel *authorsType;
@property (strong, nonatomic)  UIImageView *authorsImage;
@property (strong, nonatomic)  IBOutlet UILabel *price;
@property (strong, nonatomic)  IBOutlet UILabel *pictureSize;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) NSDictionary *CurrentPaintingData;
@property (nonatomic, strong) NSDictionary *CurrentArtistData;

@end

@implementation AVPictureViewController
#pragma mark - initialization in view didload
//main init
- (void) mainInit{
    self.dataManager = [AVManager sharedInstance];
    self.pictureView.delegate = self;
    self.pictureView.dataSource = self;
    self.pictureView.contentOffset = (CGSize) {.width = -45, .height = 0};
    self.backgroundView.image = [UIImage imageNamed:@"room1.jpg"];
    [self blurImage];
    self.pictureView.type = iCarouselTypeInvertedRotary;
    self.pictureView.scrollSpeed = 0.7f;
    self.pictureView.pagingEnabled = YES;
    [self.backgroundView addSubview:self.pictureView];
    [self.backgroundView bringSubviewToFront:self.upToolBar];
    [self.backgroundView bringSubviewToFront:self.titleOfSession];
    [self.backgroundView bringSubviewToFront:self.previewOnWallButton];
    [self.backgroundView bringSubviewToFront:self.likeButton];
    self.likeCounter = self.currentPicture.numberOfLiked;
    self.likeCounterLabel = [[UILabel alloc] initWithFrame:
                             (CGRect){.origin.x = 5, .origin.y = 10, .size.width = 50, .size.height = 30 }];
    self.likeCounterLabel.text = [NSString stringWithFormat:@"%ld", self.likeCounter];
    self.likeCounterLabel.textAlignment = NSTextAlignmentCenter;
    self.likeCounterLabel.textColor = [UIColor whiteColor];
    [self.likeButton addSubview:self.likeCounterLabel];
    self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.dataManager.index];
    self.authorsImage = [[UIImageView alloc] initWithImage:self.currentPicture.pictureAuthor.authorsPhoto];
    self.authorsImage.frame = (CGRect){ .origin.x = 0, .origin.y = 0, .size.width = 60.0, .size.height = 60.0 };
    [self.authorButton addSubview:self.authorsImage];
    self.authorsName = [UILabel new];
    self.authorsName.frame = (CGRect){.origin.x = 60.0, .origin.y = 0, .size.width = 180.0, .size.height = 30.0 };
    if (self.session != nil) {
        self.authorsName.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsName];
    }
    self.authorsName.textColor = [UIColor whiteColor];
    self.authorsName.shadowColor = [UIColor blackColor];
    self.authorsName.textAlignment = NSTextAlignmentCenter;
    self.authorsType = [UILabel new];
    self.authorsType.frame = (CGRect){.origin.x = 60.0, .origin.y = 30, .size.width = 180.0, .size.height = 30.0 };
    if (self.session != nil) {
        self.authorsType.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsType];
    }
    self.authorsType.textColor = [UIColor grayColor];
    self.authorsType.shadowColor = [UIColor blackColor];
    self.authorsType.textAlignment = NSTextAlignmentCenter;
    [self.authorButton addSubview:self.authorsName];
    [self.authorButton addSubview:self.authorsType];
    [self.backgroundView bringSubviewToFront:self.authorButton];
    [self.backgroundView bringSubviewToFront:self.price];
    [self.backgroundView bringSubviewToFront:self.pictureSize];
    [self.backgroundView bringSubviewToFront:self.addToCart];
}
//to add blure efect
-(void)blurImage
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.backgroundView.frame;
    [self.backgroundView addSubview:visualEffectView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DownloadManager = [ServerFetcher sharedInstance];
    self.urls = [[NSMutableArray alloc]initWithArray:[self.DownloadManager RunQuery]];
    //NSLog(@"%@",_urls);
    self.pictureView.delegate = self;
    self.pictureView.dataSource =self;
    [self mainInit];
    // Do any additional setup after loading the view.
}
//view will appear. we need this when we dismiss presented view controller and return here
- (void)viewWillAppear:(BOOL)animated{
    
    self.dataManager = [AVManager sharedInstance];
    
    if (self.dataManager.wallImage != nil) {
        self.backgroundView.image = self.dataManager.wallImage;
    }
    self.pictureView.currentItemIndex = self.dataManager.index;
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
#pragma mark - icarusel data source
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    //return the total number of items in the carousel
    return self.urls.count;

}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return 800.0f;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            return value * 1.4f;
        }
        default:
        {
            return value;
        }
    }
}
//load view in icarusel
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    self.PaintingData = [self.DownloadManager Paintingdic];
    self.CurrentPaintingData = [self.PaintingData valueForKey:[NSString stringWithFormat:@"%ld",self.pictureView.currentItemIndex]];
    self.CurrentArtistData = [self.PaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld.artistid",self.pictureView.currentItemIndex]];

    if (view == nil)
    {
        view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 800.0f, 700.0f)];
        view.contentMode = UIViewContentModeScaleAspectFit;

}
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:view];
    NSURL *url = [[NSURL alloc]initWithString:[self.urls objectAtIndex:index]];
    ((AsyncImageView *)view).imageURL = url;

    
     //self.likeCounter = picture.numberOfLiked;
     //self.likeCounterLabel.text = [NSString stringWithFormat:@"%d", self.likeCounter];
    self.price.text = [self.CurrentPaintingData valueForKey:@"price"];
     self.pictureSize.text = [self.CurrentPaintingData valueForKey:@"realsize"];
    //NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtistData valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //UIImage *img = [UIImage imageWithData:imageData];
    //NSLog(@"%@",img);
    //self.authorsImage.image = img;
     //self.authorsName.text = [self.CurrentArtistData valueForKey:@"name"];
    
  
    return view;
}
#pragma mark - seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"ModalToPreviewOnWall"]) {
        
        ((AVPainterViewController *)segue.destinationViewController).session = self.session;
        ((AVPainterViewController *)segue.destinationViewController).pictureIndex = self.pictureView.currentItemIndex;
        
        self.dataManager = [AVManager sharedInstance];
        self.dataManager.index = self.pictureView.currentItemIndex;
        ((AVPainterViewController *)segue.destinationViewController).dataManager = self.dataManager;
    }
    

    if ([segue.identifier isEqualToString: @"ModalToDetail"]) {
        
        AVManager *manager = [AVManager sharedInstance];
        manager.index = self.pictureView.currentItemIndex;
        ((AVDetailViewController *)segue.destinationViewController).paintingData = self.CurrentPaintingData;
        NSLog(@"%@  %ld", ((AVDetailViewController *)segue.destinationViewController).paintingData, self.pictureView.currentItemIndex );
        //((AVDetailViewController *)segue.destinationViewController).pictureAuthor =
        //((AVPicture *)[self.session.arrayOfPictures objectAtIndex:self.pictureView.currentItemIndex]).pictureAuthor;
    }

}
//dismiss current view
- (IBAction)didBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//select view in carusel
- (IBAction)didViewInCaruselSelected:(id)sender {
           [self performSegueWithIdentifier:@"ModalToDetail" sender:nil];
}
//add to cart button clicked
- (IBAction)addPictureToCart:(id)sender {
    AVPicture *inputPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureView.currentItemIndex];
    BOOL isCart = NO;
    for (int i = 0; i < inputPicture.pictureTags.count; i++) {
        if ([@"Cart" isEqualToString:(NSString *)[inputPicture.pictureTags objectAtIndex:i]]) {
            isCart = YES;
        }
    }
    if (isCart == NO) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You clicked on Add to cart"
                                                        message:@"Do you want to add picture from cart?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok",nil];
        alert.delegate = self;
        [alert show];
    }
}
//if you want to add picture to cart
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    AVPicture *inputPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureView.currentItemIndex];
    if (buttonIndex == 1)[inputPicture.pictureTags addObject:@"Cart"];
}

//like button clicked
- (IBAction)likeClicked:(id)sender {
    
    AVPicture *inputPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureView.currentItemIndex];
    BOOL isLike = NO;
    for (int i = 0; i < inputPicture.pictureTags.count; i++) {
        if ([@"Like" isEqualToString:(NSString *)[inputPicture.pictureTags objectAtIndex:i]]) {
            isLike = YES;
        }
    }
    if (isLike == NO) {
        [inputPicture.pictureTags addObject:@"Like"];
    }
}

@end
