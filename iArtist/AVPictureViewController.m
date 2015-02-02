//
//  AVPictureViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVPictureViewController.h"

@interface AVPictureViewController ()

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
    self.pictureView.scrollSpeed = 0.2f;
    [self.backgroundView addSubview:self.pictureView];
    
    [self.backgroundView bringSubviewToFront:self.upToolBar];
    [self.backgroundView bringSubviewToFront:self.titleOfSession];
    [self.backgroundView bringSubviewToFront:self.previewOnWallButton];
    
    [self.backgroundView bringSubviewToFront:self.bigPicture];
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
    
    view = [[UIImageView alloc] initWithFrame:(CGRect){ .origin.x = 0.0, .origin.y = 0.0, .size.width = 800, .size.height = 650}];
    
    
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
    
    UIImageView *priseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy1.png"]];
    priseImage.frame = (CGRect){ .origin.x = 740.0, .origin.y = imageView.frame.size.height, .size.width = 60.0, .size.height = 60.0 };
    [view addSubview:priseImage];
    
    self.price = [UILabel new];
    self.price.frame = (CGRect){.origin.x = 572.0, .origin.y = imageView.frame.size.height, .size.width = 168.0, .size.height = 28.0 };
    self.price.text = [NSString stringWithFormat:@"%ld",(long)self.currentPicture.prise];
    self.price.textColor = [UIColor whiteColor];
    self.price.shadowColor = [UIColor blackColor];
    self.price.textAlignment = NSTextAlignmentCenter;
    
    self.pictureSize = [UILabel new];
    self.pictureSize.frame = (CGRect){.origin.x = 572.0, .origin.y = imageView.frame.size.height + 32, .size.width = 168.0, .size.height = 28.0 };
    self.pictureSize.text = [NSString stringWithFormat:@"W: %ld H: %ld", (long)self.currentPicture.pictureSize.width,
                        (long)self.currentPicture.pictureSize.height];
    self.pictureSize.textColor = [UIColor grayColor];
    self.pictureSize.shadowColor = [UIColor blackColor];
    self.pictureSize.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:self.price];
    [view addSubview:self.pictureSize];
    
    self.authorsImage = [[UIImageView alloc] initWithImage:self.currentPicture.pictureAuthor.authorsPhoto];
    self.authorsImage.frame = (CGRect){ .origin.x = imageView.frame.origin.x, .origin.y = imageView.frame.size.height, .size.width = 60.0, .size.height = 60.0 };
    [view addSubview:self.authorsImage];
    self.authorsName = [UILabel new];
    self.authorsName.frame = (CGRect){.origin.x = 60.0 + self.authorsImage.frame.origin.x, .origin.y = imageView.frame.size.height, .size.width = 168.0, .size.height = 28.0 };
    
    if (self.session != nil) {
        self.authorsName.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsName];
    }
    
    self.authorsName.textColor = [UIColor whiteColor];
    self.authorsName.shadowColor = [UIColor blackColor];
    self.authorsName.textAlignment = NSTextAlignmentCenter;
    
    self.authorsType = [UILabel new];
    self.authorsType.frame = (CGRect){.origin.x = 60.0 + self.authorsImage.frame.origin.x, .origin.y = imageView.frame.size.height + 32, .size.width = 168.0, .size.height = 28.0 };
    
    if (self.session != nil) {
        self.authorsType.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsType];
    }
    
    self.authorsType.textColor = [UIColor grayColor];
    self.authorsType.shadowColor = [UIColor blackColor];
    self.authorsType.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:self.authorsName];
    [view addSubview:self.authorsType];
    
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

@end
