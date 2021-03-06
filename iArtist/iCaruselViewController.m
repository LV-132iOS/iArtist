//
//  AVPictureViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "iCaruselViewController.h"
#import "ServerFetcher.h"
#import <CoreData/CoreData.h>
#import "AsyncImageView.h"
#import <TwitterKit/TwitterKit.h>
#import "ShareViewController.h"
#import "CartViewController.h"
#import "ArtistViewController.h"
#import "Wall.h"

@interface iCaruselViewController (){
    NSString* kindOfSharing;
    UIImage* locImageToShare;
    NSURL* locImageUrl;
    NSString* locHeadString;
    NSURL* locUrlToPass;
}


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
@property (nonatomic, strong) NSDictionary *CurrentPainting;
@property (nonatomic, strong) NSDictionary *CurrentArtist;
@property (nonatomic,strong) NSMutableArray *ImageArray;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation iCaruselViewController

UIVisualEffectView *visualEffectView;

#pragma mark - initialization in view didload
//main init
- (void) mainInit{
 
    self.pictureView.dataSource = self;
    self.pictureView.contentOffset = (CGSize) {.width = 0, .height = 0};
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

    self.likeCounterLabel = [[UILabel alloc] initWithFrame:
                             (CGRect){.origin.x = 5, .origin.y = 10, .size.width = 50, .size.height = 30 }];
    
    self.likeCounterLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSArray*)[self.CurrentPainting valueForKeyPath:@"liked_by"] count]];
    
    self.likeCounterLabel.textAlignment = NSTextAlignmentCenter;
    self.likeCounterLabel.textColor = [UIColor whiteColor];
    [self.likeButton addSubview:self.likeCounterLabel];
    self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.dataManager.index];
    self.authorsImage.frame = (CGRect){ .origin.x = 0, .origin.y = 0, .size.width = 60.0, .size.height = 60.0 };
    [self.authorButton addSubview:self.authorsImage];
    //self.authorsName = [UILabel new];
    self.authorsName.frame = (CGRect){.origin.x = 60.0, .origin.y = 0, .size.width = 180.0, .size.height = 30.0 };
    //if (self.session != nil) {
        //self.authorsName.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsName];
    //}
    self.authorsName.textColor = [UIColor whiteColor];
    self.authorsName.shadowColor = [UIColor blackColor];
    self.authorsName.textAlignment = NSTextAlignmentCenter;
    [self.authorButton addSubview:self.authorsName];
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
  //  [self.backgroundView sendSubviewToBack:visualEffectView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.urls == nil) {
        self.urls = [[NSMutableArray alloc]initWithArray:[[ServerFetcher sharedInstance] RunQuery]];
    }
    self.pictureView.currentItemIndex = self.index;
    self.authorsImage = [[UIImageView alloc]init];
    self.authorsName = [UILabel new];
    self.ImageArray = [[NSMutableArray alloc]init];
    for (int i=0;i<self.urls.count;i++) {
        [self.ImageArray addObject:[NSNull null]];
    }
    
    
    //NSLog(@"%@",_urls);
    self.pictureView.delegate = self;
    self.pictureView.dataSource =self;
    [self mainInit];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareWithTwitter:)
                                                 name:@"ShareWithTwitter"
                                               object:nil];
}
//view will appear. we need this when we dismiss presented view controller and return here

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.pictureView.hidden = NO;
    [self.backgroundView sendSubviewToBack:visualEffectView];
    //self.intputPictureIndex = self.dataManager.index;
    
}

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
    self.AllPaintingData = [[ServerFetcher sharedInstance] Paintingdic];
    self.CurrentPainting = [self.AllPaintingData valueForKey:[NSString stringWithFormat:@"%ld",(long)self.pictureView.currentItemIndex]];
    self.CurrentArtist = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld.artistId",(long)self.pictureView.currentItemIndex]];
    
    
    if (view == nil)
    {
        view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 800.0f, 700.0f)];//?
        view.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:view];
    NSURL *url = [[NSURL alloc]initWithString:[self.urls objectAtIndex:index]];
    ((AsyncImageView *)view).imageURL = url;
    view = ((UIImageView*)view);
    [self.ImageArray replaceObjectAtIndex:index withObject:view];
    __block NSString* str = [[NSString alloc] init];
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t my_queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, my_queue, ^{
         str = [[ServerFetcher sharedInstance]GetLikesCount:[self.CurrentPainting valueForKey:@"_id"]];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       self.likeCounterLabel.text = str;    });
    
    self.price.text = [self.CurrentPainting valueForKey:@"price"];
    self.pictureSize.text = [self.CurrentPainting valueForKey:@"realsize"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtist valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    
    self.authorsImage.image = img;
    self.authorsName.text = [self.CurrentArtist valueForKey:@"name"];

    
    
    
    return view;
}
#pragma mark - seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"ModalToPreviewOnWall"]) {
        
        ((PreviewOnWallViewController *)segue.destinationViewController).session = self.session;
        ((PreviewOnWallViewController *)segue.destinationViewController).pictureIndex = self.pictureView.currentItemIndex;
        
        
        self.dataManager = [AVManager sharedInstance];
        self.dataManager.index = self.pictureView.currentItemIndex;
        ((PreviewOnWallViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;
        
        ((PreviewOnWallViewController *)segue.destinationViewController).ImageArray = self.ImageArray;
        
    
    
    }

    if ([segue.identifier isEqualToString: @"ModalToDetail"]) {
        
        AVManager *manager = [AVManager sharedInstance];
        manager.index = self.pictureView.currentItemIndex;
        ((FullSizePictureViewController *)segue.destinationViewController).paintingData = self.CurrentPainting;
          ((FullSizePictureViewController *)segue.destinationViewController).artistData = self.CurrentArtist;
        
        ((FullSizePictureViewController *)segue.destinationViewController).ImageThumb =
        ((UIImageView*)[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]).image;
        
    }
    
    if ([segue.identifier isEqualToString:@"SimpleShare"]) {
        //get only picture
        locImageToShare = ((UIImageView*)[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]).image;
        //set text
        locHeadString = [NSString stringWithFormat:@"What a great art ""%@"" by %@!",
                         [self.CurrentPainting valueForKey:@"title"],
                         [self.CurrentArtist valueForKey:@"name"]];
        //
        
        //pass picture to server and get its url (for PictureOnWall only)
        //if  OnlyPicture - then pass picture url
        locImageUrl =[NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/files/" stringByAppendingString: [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld._id",(long)self.pictureView.currentItemIndex]]]];
        // also need to pass a link to original picture - its the same link as a imageUrl in OnlyPicture case
        locUrlToPass = [NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/files/" stringByAppendingString:[self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld._id",(long)self.pictureView.currentItemIndex]]]];
        ((ShareViewController*)segue.destinationViewController).imageToShare = locImageToShare;
        ((ShareViewController*)segue.destinationViewController).imageUrl =locImageUrl;
        ((ShareViewController*)segue.destinationViewController).headString = locHeadString;
        ((ShareViewController*)segue.destinationViewController).urlToPass =locUrlToPass;
        
    }
    if ([segue.identifier isEqualToString:@"ArtistInfo"]) {
        ((ArtistViewController*)segue.destinationViewController).CurrentArtist = self.CurrentArtist;
        ((ArtistViewController*)segue.destinationViewController).img = self.authorsImage.image;
    }



}
//dismiss current view
- (IBAction)didBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//select view in carusel
- (IBAction)didViewInCaruselSelected:(id)sender {
    CGRect currentViewRect = { .origin.x = 0., .origin.y = 0., .size.width = 800, .size.height = 656 };
    UIImage * currentImage = ((AVPicture *)[self.session.arrayOfPictures objectAtIndex:self.pictureView.currentItemIndex]).pictureImage;
    CGRect newPictureRect;
    newPictureRect.origin.x = 0.;
    newPictureRect.origin.y = 0.;
    if (currentImage.size.width * currentViewRect.size.height > currentImage.size.height * currentViewRect.size.width){
        newPictureRect.size.width = currentViewRect.size.width;
        newPictureRect.size.height = currentImage.size.height / currentImage.size.width * currentViewRect.size.width;
    }
    else {
        newPictureRect.size.height = currentViewRect.size.height;
        newPictureRect.size.width = currentImage.size.width / currentImage.size.height * currentViewRect.size.height;
    }
    newPictureRect.origin.x = 400 - newPictureRect.size.width / 2;
    newPictureRect.origin.y = 316 - newPictureRect.size.height / 2;
    CGPoint locationInView = [sender locationInView:self.pictureView.currentItemView];
    if ((locationInView.x > newPictureRect.origin.x)&&
        (locationInView.x < newPictureRect.size.width + newPictureRect.origin.x)&&
        (locationInView.y > newPictureRect.origin.y)&&
        (locationInView.y < newPictureRect.size.height + newPictureRect.origin.y)){
        
        CGFloat timeForAnimation = 0.3;
        
        [self animate:timeForAnimation whithSeque:@"ModalToDetail"];
    }
}

- (IBAction)animationToSegue:(id)sender {
    
    if (((UIPinchGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan) {
        
        CGFloat timeForAnimation = 0.3;
        
        if (((UIPinchGestureRecognizer *)sender).scale < 1) {
            
            [self animate:timeForAnimation whithSeque:@"ModalToPreviewOnWall"];
            
        } else if (((UIPinchGestureRecognizer *)sender).scale > 1) {
            [self animate:timeForAnimation whithSeque:@"ModalToDetail"];
            
        }
    }
}

-(void)animate:(CGFloat)time whithSeque:(NSString *)identifier{
    __block UIImageView *imageView = [[UIImageView alloc] initWithImage:((UIImageView *)[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]).image];
                                   
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = (CGRect){ .origin.x = 109, .origin.y = 46, .size.width = 800 , .size.height = 656};
    [self.view addSubview:imageView];
    [self.backgroundView bringSubviewToFront:self.authorButton];
    [self.backgroundView bringSubviewToFront:self.price];
    [self.backgroundView bringSubviewToFront:self.pictureSize];
    [self.backgroundView bringSubviewToFront:self.addToCart];
    [self.backgroundView bringSubviewToFront:self.upToolBar];
    [self.backgroundView bringSubviewToFront:self.titleOfSession];
    [self.backgroundView bringSubviewToFront:self.previewOnWallButton];
    [self.backgroundView bringSubviewToFront:self.likeButton];
    self.pictureView.hidden = YES;
    CGRect rect;
    if ([identifier isEqualToString: @"ModalToPreviewOnWall"]) {
        
        
        NSNumber *number = [NSNumber numberWithDouble:(3 * [AVManager sharedInstance].wallImage.distanceToWall.doubleValue)];
        CGPoint sizeOfNewPicture = CGPointMake(
                                               (((UIImageView *)[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]).image.size.width)
                                               / number.doubleValue,
                                                (((UIImageView *)[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]).image.size.height)
                                                 /number.doubleValue);
        
        rect = (CGRect){.origin.x = 512 - sizeOfNewPicture.x / 2, .origin.y = 384 - sizeOfNewPicture.y / 2,
            .size.width = sizeOfNewPicture.x, .size.height = sizeOfNewPicture.y};
    } else if ([identifier isEqualToString:@"ModalToDetail"]){
        rect = CGRectMake(0, 0, 1024, 768);
    }
    [UIView animateWithDuration:time
                     animations:^{
                         imageView.frame = rect;
                         imageView.contentMode = UIViewContentModeScaleAspectFit;
                         if ([identifier isEqualToString: @"ModalToPreviewOnWall"]) {
                             visualEffectView.alpha = 0;
                         } else if ([identifier isEqualToString:@"ModalToDetail"]){
                             visualEffectView.backgroundColor = [UIColor blackColor];
                         }
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:time
                                          animations:^{
                                              [self performSegueWithIdentifier:identifier sender:nil];
                                          }
                                          completion:^(BOOL finished) {
                                              [imageView removeFromSuperview];
                                              visualEffectView.alpha = 0.35;

                                          }];
                     }];
}

- (IBAction)goToPreviewOnWall:(id)sender {
    CGFloat timeForAnimation = 0.3;
    
    [self animate:timeForAnimation whithSeque:@"ModalToPreviewOnWall"];
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
    if (PurchuasedImageArray == nil || PurchuasedPaintingData == nil) {
        PurchuasedImageArray = [[NSMutableArray alloc]init];
        PurchuasedPaintingData = [[NSMutableArray alloc]init];

    }
    [PurchuasedImageArray addObject:[self.ImageArray objectAtIndex:self.pictureView.currentItemIndex]];
    [PurchuasedPaintingData addObject:self.CurrentPainting];

    
}

//like button clicked
- (IBAction)likeClicked:(id)sender {
    
    NSString *likescount = [[ServerFetcher sharedInstance] PutLikes:[self.CurrentPainting valueForKey:@"_id"]];
    self.likeCounterLabel.text = likescount;
}



@end
