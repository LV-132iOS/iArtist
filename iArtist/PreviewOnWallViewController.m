//
//  AVPainterViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 26.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "PreviewOnWallViewController.h"
#import "ServerFetcher.h"
#import "ShareViewController.h"
#import "ArtistViewController.h"
#import "CartViewController.h"
#import "AVManager.h"

@interface PreviewOnWallViewController (){
    NSString* kindOfSharing;
    UIImage* locImageToShare;
    NSURL* locImageUrl;
    NSString* locHeadString;
    NSURL* locUrlToPass;
}

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipe;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIToolbar *upToolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarBatton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraBurButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarBautton;
@property (strong, nonatomic) IBOutlet UILabel *titleOfPicture;
@property (strong, nonatomic) IBOutlet UIView *authorsView;
@property (strong, nonatomic) IBOutlet UILabel *authorsName;
@property (strong, nonatomic) IBOutlet UILabel *authorsType;
@property (strong, nonatomic) IBOutlet UIImageView *authorsImage;
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *pictureSize;
@property (nonatomic, strong) UIImage *img;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation PreviewOnWallViewController

NSArray *arrayOfWals;
CGPoint positionOfFirstTapPanGestureGecognizer;
CGFloat lenght;
CGPoint centre;

typedef NS_ENUM(NSInteger, AVDirrectionMove){
    AVDirrectionMoveUp,
    AVDirrectionMoveDown,
    AVDirrectionMoveLeft,
    AVDirrectionMoveRigth
};

typedef NS_ENUM(NSInteger, AVTypeOfPictureChange){
    AVSwipeRightTypeOfPictureChange,
    AVSwipeLeftTypeOfPictureChange,
    AVInitTypeOfPictureChange,
    AVDoubleTapOfPictureChange
};

#pragma mark - Initialisation for work
//initialization of walls
- (void) initWals{
    
    Wall *wall1 = [Wall new];
    wall1.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    wall1.distanceToWall = @1.5;
    self.currentWall = wall1;
}


- (void) setImageWithWall :(UIImage *)image :(CGPoint)pictureCenter :(AVTypeOfPictureChange)typeOfPictureChange{
    
    self.CurrentArtist = [[NSDictionary alloc]init];
    self.CurrentPainting = [[NSDictionary alloc]init];
    NSLog(@"%@",self.AllPaintingData);
    self.CurrentPainting = [self.AllPaintingData valueForKey:[NSString stringWithFormat:@"%ld",(long)self.pictureIndex]];
    self.CurrentArtist = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld.artistId",(long)self.pictureIndex]];
    
    CGPoint sizeOfNewPicture = CGPointMake(
                                           image.size.width ,
                                           image.size.height );
    
    CGRect frame = {.origin.x = 0.0, .origin.y = 0.0, .size.width = sizeOfNewPicture.x, .size.height = sizeOfNewPicture.y};
    
    self.price.text = [self.CurrentPainting valueForKey:@"price"];
    self.pictureSize.text = [self.CurrentPainting valueForKey:@"size"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtist valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    self.authorsImage.image = img;
    self.authorsImage.contentMode = UIViewContentModeScaleAspectFit;
    self.authorsImage.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.authorsImage.layer.cornerRadius = self.authorsImage.frame.size.height / 2;
    self.authorsImage.layer.borderWidth = 2.0;
    self.authorsImage.layer.masksToBounds = YES;
    self.authorsImage.layer.borderColor = [[UIColor blackColor] CGColor];
    self.authorsName.text = [self.CurrentArtist valueForKey:@"name"];
    self.img = img;
    
    NSString *realsize = [NSString stringWithString:
                          [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld.realsize",(long)self.pictureIndex]]];
    NSLog(@"%@",realsize);
    NSInteger indexOfX;
    for (indexOfX = 0; indexOfX < realsize.length; indexOfX ++) {
        if ([realsize characterAtIndex:indexOfX] == 'x') {
            
            frame.size.height = [realsize substringToIndex:indexOfX].doubleValue * 7.6 /
            (self.currentWall.distanceToWall.doubleValue);
            frame.size.width = [realsize substringFromIndex:(indexOfX + 1)].doubleValue * 7.6 /
            (self.currentWall.distanceToWall.doubleValue);
        }
    }
    
    if (typeOfPictureChange == AVInitTypeOfPictureChange) {
        
        [self.pictureImage removeFromSuperview];
        self.pictureImage = [[UIImageView alloc] initWithFrame:frame];
        
        self.pictureImage.image = image;
        
        self.pictureImage.center = self.view.center;
        [self.roomImage addSubview:self.pictureImage];
        [self.roomImage bringSubviewToFront:self.titleOfPicture];
        [self.roomImage bringSubviewToFront:self.upToolBar];
        [self.roomImage bringSubviewToFront:self.authorsView];
        [self.roomImage bringSubviewToFront:self.price];
        [self.roomImage bringSubviewToFront:self.pictureSize];
    }
    
    if (typeOfPictureChange == AVDoubleTapOfPictureChange) {
        
        self.pictureImage.hidden = YES;
        
        ///should fix bug
        if (pictureCenter.x - self.pictureImage.frame.size.width / 2 < self.roomImage.frame.origin.x)
            pictureCenter.x = self.pictureImage.frame.size.width / 2;
        if (pictureCenter.x + self.pictureImage.frame.size.width / 2 > self.roomImage.frame.origin.x + self.roomImage.frame.size.width)
            pictureCenter.x = 1024 - self.pictureImage.frame.size.width / 2;
        if (pictureCenter.y - self.pictureImage.frame.size.height / 2 < self.roomImage.frame.origin.y)
            pictureCenter.y = self.pictureImage.frame.size.height / 2;
        if (pictureCenter.y + self.pictureImage.frame.size.height / 2 > self.roomImage.frame.origin.y + self.roomImage.frame.size.height)
            pictureCenter.y = 768 - self.pictureImage.frame.size.height / 2;
        self.pictureImage.center = pictureCenter;
        self.pictureImage.hidden = NO;
        
    }
if ((typeOfPictureChange == AVSwipeRightTypeOfPictureChange)||(typeOfPictureChange == AVSwipeLeftTypeOfPictureChange)) {
        CGFloat left = 0;
        CGFloat right = 1024;
        CGFloat up = 0;
        CGFloat down = 768;
        BOOL biggerHeigthOrWidth;
        if (self.roomImage.image.size.width * self.view.frame.size.height >
            self.roomImage.image.size.height * self.view.frame.size.width)biggerHeigthOrWidth = YES;
        else biggerHeigthOrWidth = NO;
        if (biggerHeigthOrWidth) {
            up = self.view.frame.size.height / 2 - self.roomImage.image.size.height /
            self.roomImage.image.size.width * self.view.frame.size.width / 2 ;
            down = self.view.frame.size.height / 2 + self.roomImage.image.size.height /
            self.roomImage.image.size.width * self.view.frame.size.width / 2 ;
            right = self.view.frame.size.width ;
        } else {
            down = self.view.frame.size.height ;
            left = self.view.frame.size.width / 2 - self.roomImage.image.size.width /
            self.roomImage.image.size.height * self.view.frame.size.height / 2 ;
            right = self.view.frame.size.width / 2 + self.roomImage.image.size.width /
            self.roomImage.image.size.height * self.view.frame.size.height / 2 ;
        }
        if (pictureCenter.x - frame.size.width / 2 < left)pictureCenter.x = left + frame.size.width / 2;
        if (pictureCenter.x + frame.size.width / 2 > right)pictureCenter.x = right - frame.size.width / 2;
        if (pictureCenter.y - frame.size.height / 2 < up)pictureCenter.y = up + frame.size.height / 2;
        if (pictureCenter.y + frame.size.height / 2 > down)pictureCenter.y = down - frame.size.height / 2;
        CABasicAnimation *pictureMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        [pictureMoveAnimation setFromValue:[NSValue valueWithCGPoint:[[self.pictureImage layer]position]]];
        CGFloat timeForAnimation = 0.35;
        CGFloat xLocation = 0.0;
        if (typeOfPictureChange == AVSwipeRightTypeOfPictureChange) {
            [pictureMoveAnimation setToValue:[NSValue valueWithCGPoint:(CGPoint){.
                x = 1024 + self.pictureImage.frame.size.width / 2, .y = self.pictureImage.center.y}]];
            xLocation = - frame.size.width / 2;
        }
        if (typeOfPictureChange == AVSwipeLeftTypeOfPictureChange) {
            [pictureMoveAnimation setToValue:[NSValue valueWithCGPoint:(CGPoint){.
                x = - self.pictureImage.frame.size.width / 2, .y = self.pictureImage.center.y}]];
            xLocation = 1024 + frame.size.width / 2;
        }
        [pictureMoveAnimation setDuration:timeForAnimation];
        [self.pictureImage.layer addAnimation:pictureMoveAnimation forKey:@"pictureAnimation"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeForAnimation - 0.05) * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.pictureImage.hidden = YES;
                           self.pictureImage.frame = frame;
                           self.pictureImage.center = pictureCenter;
                           
                           self.pictureImage.image = image;
                           
                           [self.pictureImage.layer removeAnimationForKey:@"pictureAnimation"];
                       });
        [pictureMoveAnimation setFromValue:[NSValue valueWithCGPoint:(CGPoint){.x = xLocation, .y = self.pictureImage.center.y}]];
        [pictureMoveAnimation setToValue:[NSValue valueWithCGPoint:pictureCenter]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForAnimation * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.pictureImage.hidden = NO;
                           [self.pictureImage.layer addAnimation:pictureMoveAnimation forKey:@"pictureAnimation"];
                       });
    }
    
}
- (void) mainInit{
    //AVManager *manager = [AVManager sharedInstance];
    //self.pictureIndex = manager.index;
    
    [self initWals];
    self.roomImage.image = self.currentWall.wallPicture;
    UIImage *picture = [self.ImageArray objectAtIndex:self.pictureIndex];
    //self.roomImage.backgroundColor = [UIColor colorWithPatternImage:picture];
    
    AVManager *manager = [AVManager sharedInstance];
     self.pictureIndex = manager.index;
     self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureIndex];
     
     self.currentWall = manager.wallImage;
     
     self.roomImage.image = self.currentWall.wallPicture;
    
     [self setImageWithWall:picture
                           :self.roomImage.center
                           :AVInitTypeOfPictureChange];
     self.rightSwipe = [UISwipeGestureRecognizer new];
     self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
     self.rightSwipe.delegate = self;
     self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
     self.leftSwipe.delegate = self;
     self.panGestureRecognizer.delegate = self;
     self.pinchGestureRecognizer = [UIPinchGestureRecognizer new];
     self.pinchGestureRecognizer.delegate = self;
     [self.pinchGestureRecognizer addTarget:self action:@selector(pinchAction:)];
     [self.roomImage addGestureRecognizer:self.pinchGestureRecognizer];
    
    kindOfSharing = [[NSMutableString alloc] init];
    locImageToShare = [[UIImage alloc] init];
    locImageUrl = [[NSURL alloc] init];
    locUrlToPass = [[NSURL alloc] init];
    locHeadString = [[NSString alloc] init];
    

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self mainInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) hideViews{
    self.upToolBar.hidden = YES;
    self.price.hidden = YES;
    self.pictureSize.hidden = YES;
    self.authorsView.hidden = YES;
    self.titleOfPicture.hidden = YES;
}

- (void) pushVies{
    self.upToolBar.hidden = NO;
    self.price.hidden = NO;
    self.pictureSize.hidden = NO;
    self.authorsView.hidden = NO;
    self.titleOfPicture.hidden = NO;
    [self.roomImage bringSubviewToFront:self.titleOfPicture];
    [self.roomImage bringSubviewToFront:self.upToolBar];
    [self.roomImage bringSubviewToFront:self.authorsView];
    [self.roomImage bringSubviewToFront:self.price];
    [self.roomImage bringSubviewToFront:self.pictureSize];
}



#pragma mark - gesture recognizers
// swipe gesture recognizers left and right and changing picture
- (IBAction) swipePressAction:(UISwipeGestureRecognizer *)sender {
    CGPoint currentPoint = [sender locationInView:self.roomImage];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self hideViews];
    }
    if (![self ifPointInsidePicture: currentPoint]){
        AVTypeOfPictureChange pictureChange = AVSwipeLeftTypeOfPictureChange;
        if (sender.direction == UISwipeGestureRecognizerDirectionRight){
            pictureChange = AVSwipeRightTypeOfPictureChange;
            if (self.pictureIndex == 0){
                self.pictureIndex = [self.ImageArray count] - 1;
            } else
                self.pictureIndex--;
            
        }
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
            pictureChange = AVSwipeLeftTypeOfPictureChange;
            if (self.pictureIndex == [self.ImageArray count]-1 ){
                self.pictureIndex = 0;
            } else
                self.pictureIndex++;
        }
        
        //
        ///[self setImageWithWall:self.pictureImage.center
        //                     :pictureChange];
        //
        
        NSNumber *size = [NSNumber new];
        NSString *realsize = [NSString stringWithString:
                              [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld.realsize",(long)self.pictureIndex]]];
        NSInteger indexOfX;
        for (indexOfX = 0; indexOfX < realsize.length; indexOfX ++) {
            if ([realsize characterAtIndex:indexOfX] == 'x') {
                
                size = @(MAX([realsize substringToIndex:indexOfX].doubleValue, [realsize substringFromIndex:(indexOfX + 1)].doubleValue));
            }
        }
        
        size = @(size.intValue / (3 * self.currentWall.distanceToWall.doubleValue ));
        
        if ([self.ImageArray objectAtIndex:self.pictureIndex] == [NSNull null]) {
            
            [[ServerFetcher sharedInstance] getPictureThumbWithSizeAndID:[self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld._id",(long)self.pictureIndex]]size:size callback:^(UIImage *responde) {
                [self.ImageArray replaceObjectAtIndex:self.pictureIndex withObject:responde];
                
                [self setImageWithWall:responde
                                      :self.pictureImage.center
                                      :AVSwipeRightTypeOfPictureChange];
            }];
            
        } else {
            UIImage *img = [self.ImageArray objectAtIndex:self.pictureIndex];
            
            
            //img.size.height = [realsize substringToIndex:indexOfX].doubleValue / (3 * self.currentWall.distanceToWall.doubleValue);
            
            [self setImageWithWall:img
                                  :self.pictureImage.center
                                  :pictureChange];
        }
        
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pushVies];
    }
}//we check is point into our picture or not
- (BOOL) ifPointInsidePicture:(CGPoint)point{
    
    if ((point.x > self.pictureImage.frame.origin.x)&&
        (point.y > self.pictureImage.frame.origin.y )&&
        (point.x < self.pictureImage.frame.origin.x + self.pictureImage.frame.size.width)&&
        (point.y < self.pictureImage.frame.origin.y + self.pictureImage.frame.size.height ))return YES;
    else return NO;
}

//we checking can we move pictur or not
- (BOOL) canMovePicture:(CGPoint)pickedPoint dirrectionToMove:(AVDirrectionMove)dirrection{
    
    if ([self ifPointInsidePicture: pickedPoint]){
        BOOL biggerHeigthOrWidth;
        if (self.roomImage.image.size.width * self.view.frame.size.height >
            self.roomImage.image.size.height * self.view.frame.size.width)biggerHeigthOrWidth = YES;
        else biggerHeigthOrWidth = NO;
        float intToCompare;
        switch (dirrection) {
            case AVDirrectionMoveUp:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.height / 2 - self.roomImage.image.size.height /
                    self.roomImage.image.size.width * self.view.frame.size.width / 2 + self.pictureImage.frame.size.height / 2 ;
                } else intToCompare = self.pictureImage.frame.size.height / 2 ;
                if (pickedPoint.y > intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveDown:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.height / 2 + self.roomImage.image.size.height /
                    self.roomImage.image.size.width * self.view.frame.size.width / 2 - self.pictureImage.frame.size.height / 2;
                } else intToCompare = self.view.frame.size.height - self.pictureImage.frame.size.height / 2 ;
                if (pickedPoint.y < intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveLeft:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.pictureImage.frame.size.width / 2;
                } else intToCompare = self.view.frame.size.width / 2 - self.roomImage.image.size.width /
                    self.roomImage.image.size.height * self.view.frame.size.height / 2 + self.pictureImage.frame.size.width / 2;
                if (pickedPoint.x > intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveRigth:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.width - self.pictureImage.frame.size.width / 2;
                } else intToCompare = self.view.frame.size.width / 2 + self.roomImage.image.size.width / self.roomImage.image.size.height *
                    self.view.frame.size.height / 2 - self.pictureImage.frame.size.width / 2;
                if (pickedPoint.x < intToCompare) return YES;
                else return NO;
                break;
            default:
                break;
        }
    }
    return NO;
}

//pan picture recognizer for moving picture on the screen
- (IBAction)pictureGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        positionOfFirstTapPanGestureGecognizer = [sender locationInView:self.pictureImage];
        [self hideViews];
    }
    CGPoint differenceInLocation = CGPointMake([sender locationInView:self.pictureImage].x - positionOfFirstTapPanGestureGecognizer.x,
                                               [sender locationInView:self.pictureImage].y - positionOfFirstTapPanGestureGecognizer.y);
    CGPoint newCenter = CGPointMake(self.pictureImage.center.x + differenceInLocation.x,
                                    self.pictureImage.center.y + differenceInLocation.y);
    if ([self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveUp]&&
        [self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveDown])
        self.pictureImage.center = CGPointMake(self.pictureImage.center.x, newCenter.y);
    if ([self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveLeft]&&
        [self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveRigth])
        self.pictureImage.center = CGPointMake(newCenter.x, self.pictureImage.center.y);
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pushVies];
    }
}
// twaice tap gesture recognizer
- (IBAction)logAction:(id)sender {
    if ([self ifPointInsidePicture: [(UIGestureRecognizer *)sender locationInView:self.roomImage]]) {
        [self backReturn:sender];
    } else {
        [self setImageWithWall:[self.ImageArray objectAtIndex:self.pictureIndex]
                              :[(UIGestureRecognizer *)sender locationInView: self.roomImage]
                              :AVDoubleTapOfPictureChange];
    }
}

- (IBAction)pinchAction:(id)sender {
    if (((UIPinchGestureRecognizer *)sender).scale > 1) {
        [self pinchAnimation];
    }
}

- (void)pinchAnimation{
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.roomImage.frame;
    visualEffectView.alpha = 0;
    
    [self.roomImage addSubview:visualEffectView];
    [self.roomImage sendSubviewToBack:visualEffectView];
    
    CGFloat timeForAnimation = 0.3;
    [UIView animateWithDuration:timeForAnimation animations:^{
        self.pictureImage.frame = CGRectMake(112, 44, 800, 656);
        self.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
        visualEffectView.alpha = 0.31;
    } completion:NULL];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeForAnimation) * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self dismissViewControllerAnimated:NO completion:nil];
                   });
}


//this method is for avoiding any conflicts by different gesture recognizers
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.roomImage];
    if ([gestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]){
        if ([self ifPointInsidePicture: currentPoint])return YES;
        else return NO;
    }
    if ([gestureRecognizer isKindOfClass: [UISwipeGestureRecognizer class]]){
        if ([self ifPointInsidePicture: currentPoint])return NO;
        else return YES;
    }
    return YES;
}

#pragma mark - popover
//here we push popower om thr screen
- (IBAction) pushPopover:(UIBarButtonItem *)sender {
    SetWallPopoverTableViewController *tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"popover"];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeWall:)
                                                 name:AVDidSelectWall
                                               object:nil];
    [popoverController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionDown
                                              animated:YES];
    popoverController.delegate = self;
    self.popover = popoverController;
    double delayInSeconds = 300.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    });
    
}
//get a notification from popower controler whith chosen wall
//we also put wall on the screen
- (void) changeWall:(NSNotification *)notification{
    self.currentWall = [notification.userInfo valueForKey:@"wall"];
    self.roomImage.image = self.currentWall.wallPicture;
    [self setImageWithWall:[self.ImageArray objectAtIndex:self.pictureIndex]
                          :self.pictureImage.center
                          :AVInitTypeOfPictureChange];
    [self.popover dismissPopoverAnimated:YES];
}

// we remove our notification as soon as we don't need it
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popover = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - desappearing controller

//dismiss viewconroller on click back button
- (IBAction)backReturn:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
//input data into manager when we disappear view controller
- (void)viewWillDisappear:(BOOL)animated{
    self.dataManager = [AVManager sharedInstance];
    self.dataManager.index = self.pictureIndex;
    //self.dataManager.wallImage = self.currentWall.wallPicture;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"Share"]) {
        if ([kindOfSharing isEqualToString:@"PictureOnWall"]) {
            //get screenshot of view
            [self hideViews];
            UIGraphicsBeginImageContext(self.view.window.bounds.size);
            [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
            locImageToShare = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self pushVies];
            //set text
            locHeadString = [NSString stringWithFormat:@"What a great art ""%@"" by %@ on the wall!",
                             [self.CurrentPainting valueForKey:@"title"],
                             [self.CurrentArtist valueForKey:@"name"]];
            //
        } else if ([kindOfSharing isEqualToString:@"OnlyPicture"]){
            //get only picture
            locImageToShare = [self.ImageArray objectAtIndex:self.pictureIndex];
            //set text
            locHeadString = [NSString stringWithFormat:@"What a great art ""%@"" by %@!",
                             [self.CurrentPainting valueForKey:@"title"],
                             [self.CurrentArtist valueForKey:@"name"]];
            //
        }
        //pass picture to server and get its url (for PictureOnWall only)
        //if  OnlyPicture - then pass picture url
        
        locImageUrl = [NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/files/"
                                            stringByAppendingString:[self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld._id",(long)self.pictureIndex]]]];
        
        // also need to pass a link to original picture - its the same link as a imageUrl in OnlyPicture case
        locUrlToPass = [NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/files/"
                                             stringByAppendingString:[self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld._id",(long)self.pictureIndex]]]];
        
        ((ShareViewController*)segue.destinationViewController).imageToShare = locImageToShare;
        ((ShareViewController*)segue.destinationViewController).imageUrl = locImageUrl;
        ((ShareViewController*)segue.destinationViewController).headString = locHeadString;
        ((ShareViewController*)segue.destinationViewController).urlToPass = locUrlToPass;
    }
    if ([segue.identifier isEqualToString:@"ArtistInfo"]) {
        ((ArtistViewController*)segue.destinationViewController).CurrentArtist = self.CurrentArtist;

        ((ArtistViewController*)segue.destinationViewController).img = self.img;
        
    }
    
}

- (IBAction)SharePressed:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Would you like to share..."
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Only picture", @"Picture on wall", nil];
    alertView.alertViewStyle = UIAlertControllerStyleActionSheet;
    [alertView show];
    
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        //only picture
        kindOfSharing = @"OnlyPicture";
        [self performSegueWithIdentifier:@"Share" sender:nil];
        
    } else if (buttonIndex == 2) {
        //picture with wall
        kindOfSharing = @"PictureOnWall";
        [self performSegueWithIdentifier:@"Share" sender:nil];
    } else if (buttonIndex == 0) {
        //do nothing
    }
}




@end
