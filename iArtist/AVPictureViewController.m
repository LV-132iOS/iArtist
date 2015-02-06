//
//  AVPictureViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVPictureViewController.h"

@interface AVPictureViewController ()

@property (nonatomic) NSInteger likeCounter;
@property (strong, nonatomic) UILabel *likeCounterLabel;

@end

@implementation AVPictureViewController

- (void) mainInit{
    
    if (self.session == nil) {
        self.session = [AVSession sessionInit];
        self.intputPictureIndex = 0;
    }

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
    
    [self.backgroundView bringSubviewToFront:self.bigPicture];

    
    self.likeCounter = self.currentPicture.numberOfLiked;
    
    self.likeCounterLabel = [[UILabel alloc] initWithFrame:
                                 (CGRect){.origin.x = 5, .origin.y = 10, .size.width = 50, .size.height = 30 }];
    self.likeCounterLabel.text = [NSString stringWithFormat:@"%d", self.likeCounter];
    self.likeCounterLabel.textAlignment = NSTextAlignmentCenter;
    self.likeCounterLabel.textColor = [UIColor whiteColor];
    
    [self.likeButton addSubview:self.likeCounterLabel];
    
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
    
}

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
    
    // Do any additional setup after loading the view.
    
    [self mainInit];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.dataManager = [AVManager sharedInstance];
    
    if (self.dataManager.wallImage != nil) {
        self.backgroundView.image = self.dataManager.wallImage;
    }
        
    self.intputPictureIndex = self.dataManager.index;
    
    self.session = self.dataManager.session;
        
    self.pictureView.currentItemIndex = 0;
        
    [self.pictureView reloadData];

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

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    //return the total number of items in the carousel
    return [self.session.arrayOfPictures count];
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

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    view = [[UIImageView alloc] initWithFrame:(CGRect){ .origin.x = 0.0, .origin.y = 0.0, .size.width = 800, .size.height = 700}];
    
    if (self.session != nil) {
        self.pictureIndex = index + self.intputPictureIndex;
        if (self.pictureIndex >= [self.session.arrayOfPictures count]) {
            self.pictureIndex -= [self.session.arrayOfPictures count];            
        } 
        self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureIndex];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.currentPicture.pictureImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = (CGRect){ .origin.x = 0.0, .origin.y = 0.0, .size.width = 800, .size.height = 632};
    imageView.tag = 1;
    [view addSubview:imageView];

    view.contentMode = UIViewContentModeCenter;
    

    self.likeCounter = self.currentPicture.numberOfLiked;
    self.likeCounterLabel.text = [NSString stringWithFormat:@"%d", self.likeCounter];
    
    self.price.text = [NSString stringWithFormat:@"%ld",(long)self.currentPicture.prise];
    
    self.pictureSize.text = [NSString stringWithFormat:@"W: %ld H: %ld", (long)self.currentPicture.pictureSize.width,
                             (long)self.currentPicture.pictureSize.height];
    
    self.authorsImage.image = self.currentPicture.pictureAuthor.authorsPhoto;
    
    if (self.session != nil) {
        self.authorsName.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsName];
        self.authorsType.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsType];
    }
 
    return view;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSInteger indexOutput = self.pictureView.currentItemIndex + self.intputPictureIndex;
    
    if (indexOutput > [self.session.arrayOfPictures count]) {
        indexOutput -= [self.session.arrayOfPictures count];
    }
    
    if ([segue.identifier isEqualToString: @"ModalToPreviewOnWall"]) {
       
        ((AVPainterViewController *)segue.destinationViewController).session = self.session;
        ((AVPainterViewController *)segue.destinationViewController).pictureIndex = indexOutput;
        
        self.dataManager = [AVManager sharedInstance];
        self.dataManager.session = self.session;
        self.dataManager.index = indexOutput;
        ((AVPainterViewController *)segue.destinationViewController).dataManager = self.dataManager;
    }
    
    if ([segue.identifier isEqualToString: @"ModalToDetail"]) {
        
        ((AVDetailViewController *)segue.destinationViewController).inputPicture =
                                [self.session.arrayOfPictures objectAtIndex:indexOutput];
        
        ((AVDetailViewController *)segue.destinationViewController).pictureAuthor =
        ((AVPicture *)[self.session.arrayOfPictures objectAtIndex:indexOutput]).pictureAuthor;
    }
    if ([segue.identifier isEqualToString:@"Picture Carusel to Cart"]) {
        
        
        
    }
}

- (IBAction)didBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    NSInteger indexOutput = self.pictureView.currentItemIndex + self.intputPictureIndex;
    
    if (indexOutput > [self.session.arrayOfPictures count]) {
        indexOutput -= [self.session.arrayOfPictures count];
    }
    
    self.dataManager = [AVManager sharedInstance];
    self.dataManager.index = indexOutput;

    
}
- (IBAction)didViewInCaruselSelected:(id)sender {
    
    NSLog(@"x:%f y:%f",[sender locationInView:self.likeButton].x,[sender locationInView:self.likeButton].y);
    
    CGRect currentViewRect = { .origin.x = 0., .origin.y = 0., .size.width = 800, .size.height = 632 };
    
    NSInteger indexOutput = self.pictureView.currentItemIndex + self.intputPictureIndex;
    
    if (indexOutput > [self.session.arrayOfPictures count]) {
        indexOutput -= [self.session.arrayOfPictures count];
    }
    
    UIImage * currentImage = ((AVPicture *)[self.session.arrayOfPictures objectAtIndex:indexOutput]).pictureImage;
    
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
        [self performSegueWithIdentifier:@"ModalToDetail" sender:nil];
    }
}


- (IBAction)likeClicked:(id)sender {
    
    
    
    NSLog(@"AAA ");
    
}

@end
