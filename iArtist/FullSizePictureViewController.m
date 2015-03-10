//
//  AVDetailViewController.m
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FullSizePictureViewController.h"
#import "ServerFetcher.h"
#import "ActivityIndicator.h"

typedef NS_ENUM(NSInteger, AVLeftView) {
    AVLeftViewEnable,
    AVLeftViewDisable
};

@interface FullSizePictureViewController ()<UIScrollViewDelegate,  UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton    *closeButton;
@property (strong, nonatomic) IBOutlet UIView      *leftView;
@property (strong, nonatomic) IBOutlet UITableView *pictureInfo;
@property (strong, nonatomic) IBOutlet UITextView  *authorInfo;
@property (strong, nonatomic) IBOutlet UILabel     *authorsName;
@property (strong, nonatomic) IBOutlet UILabel     *authorsData;
@property (strong, nonatomic)          UIImageView *authorsImage;
@property (strong, nonatomic)          UITextView  *pictureDescription;
@property (strong, nonatomic) IBOutlet UIButton    *authorButton;
@property (nonatomic)                  AVLeftView  leftviewindex;
@property (strong, nonatomic) IBOutlet UILabel     *price;
@property (strong, nonatomic) IBOutlet UIButton    *like;
@property (strong, nonatomic) IBOutlet ActivityIndicator *indicator;

@end

@implementation FullSizePictureViewController

CGFloat neededScale;
CGPoint positionOfFirstTapOfPinchGestureGecognizer;


#pragma mark - data initialization
//getting data from input


- (void)mainInit
{
    
    self.mainView.contentSize = CGSizeMake(1024, 768);
    self.leftviewindex = AVLeftViewEnable;
    self.mainView.delegate = self;
    
    NSString *realsize = [self.paintingData valueForKey:@"realsize"];
    
    NSLog(@"%@",realsize);
    NSInteger indexOfX;
    NSInteger pictureRealWidth = 0;
    NSInteger pictureRealHeight = 0;
    for (indexOfX = 0; indexOfX < realsize.length; indexOfX ++) {
        if ([realsize characterAtIndex:indexOfX] == 'x') {
            pictureRealWidth = [realsize substringToIndex:indexOfX].intValue;
            pictureRealHeight = [realsize substringFromIndex:(indexOfX + 1)].intValue ;
        }
    }
    
    CGFloat scale = 0.;
    scale = MAX((CGFloat)pictureRealHeight/12., (CGFloat)pictureRealWidth/16.);
    
    
    
    self.mainView.maximumZoomScale = scale;
    self.mainView.minimumZoomScale = 1;
    [self.mainView bringSubviewToFront:self.closeButton];
    
}

- (void)inputDataInit{
    self.authorInfo.hidden = YES;
    self.pictureDescription.text = [self.paintingData valueForKey:@"description"];
     self.authorsName.text = [self.artistData valueForKey:@"name"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.artistData valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];


    [self.authorButton setBackgroundImage:img forState:UIControlStateNormal];
    
    [self.indicator megaInit];
    [self.indicator startAnimating];
    [self.view bringSubviewToFront:self.indicator];
    [[ServerFetcher sharedInstance]GetPictureWithID:[self.paintingData valueForKey:@"_id"] callback:^(UIImage *responde) {
        self.imageView.image = responde;
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        NSLog(@"Ok");
        
        
    }];
    
    

    
}

- (IBAction)switchData:(id)sender {
    NSInteger index = ((UISegmentedControl *)sender).selectedSegmentIndex;
    if (index == 0) {
        self.pictureInfo.hidden = NO;
        self.authorInfo.hidden = YES;
    } else {
        self.pictureInfo.hidden = YES;
        self.authorInfo.hidden = NO;
    }
}

- (void)viewDidLoad {
 
    
    [super viewDidLoad];
    [self mainInit];
    [self inputDataInit];
    self.imageView = [[UIImageView alloc]initWithImage:self.ImageThumb];
    self.imageView.frame = self.mainView.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainView addSubview:self.imageView];


    
    // Do any additional setup after loading the view.
}
//metod for scroll view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (self.leftviewindex == AVLeftViewEnable)[self showLeftView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if (scrollView.pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        positionOfFirstTapOfPinchGestureGecognizer = [scrollView.pinchGestureRecognizer locationInView:self.imageView];
    }
    if (self.leftviewindex == AVLeftViewEnable)[self hideLeftView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"neededScale %f",neededScale);
    NSLog(@"scrollView.zoomScale %f",scrollView.zoomScale);
    NSLog(@"scrollView.pinchGestureRecognizer.scale %f",scrollView.pinchGestureRecognizer.scale);
    if(scrollView.pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        neededScale  = scrollView.zoomScale;
    }
        /*        if (neededScale < 1) {
            CGPoint differenceInLocation = CGPointMake([scrollView.pinchGestureRecognizer locationInView:self.imageView].x -
                                                       positionOfFirstTapOfPinchGestureGecognizer.x,
                                                       [scrollView.pinchGestureRecognizer locationInView:self.imageView].y -positionOfFirstTapOfPinchGestureGecognizer.y);
            CGPoint newCenter = CGPointMake(self.imageView.center.x + differenceInLocation.x,
                                            self.imageView.center.y + differenceInLocation.y);
            self.imageView.center = newCenter;
        }
    }*/
    if (scrollView.pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (neededScale < 0.8) {
            [self closeController:nil];
            
            
        } /*else if (neededScale < 1) {
            self.imageView.center = CGPointMake(512, 384);
        }*/
        [self tapAction:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *newCell = [UITableViewCell new];
    switch (indexPath.row) {
        case 0:
            newCell = [tableView dequeueReusableCellWithIdentifier:@"Picture Name" forIndexPath:indexPath];
            newCell.textLabel.text = [self.paintingData valueForKey:@"title"];
            break;
        case 1:
            newCell = [tableView dequeueReusableCellWithIdentifier:@"Picture genre" forIndexPath:indexPath];
            newCell.textLabel.text = [self.paintingData valueForKey:@"genre"];

            break;
        case 2:
            newCell = [tableView dequeueReusableCellWithIdentifier:@"Picture size" forIndexPath:indexPath];
            newCell.textLabel.text = [self.paintingData valueForKey:@"size"];

            break;
        case 3:
            newCell = [tableView dequeueReusableCellWithIdentifier:@"Picture material" forIndexPath:indexPath];
            newCell.textLabel.text = [self.paintingData valueForKey:@"material"];
            break;
        case 4:
            newCell = [tableView dequeueReusableCellWithIdentifier:@"Picture Description" forIndexPath:indexPath];
            self.pictureDescription = [[UITextView alloc] initWithFrame:(CGRect){.origin.x = 0, .origin.y = 0,
                .size.width = 394, .size.height = 397}];
            self.pictureDescription.text = [self.paintingData valueForKey:@"description"];
            self.pictureDescription.textColor = [UIColor whiteColor];
            self.pictureDescription.backgroundColor = [UIColor clearColor];
            [newCell.contentView addSubview:self.pictureDescription];
            break;
        default:
            break;
    }
    newCell.textLabel.textColor = [UIColor whiteColor];
    [newCell setBackgroundColor:[UIColor clearColor]];
    [[newCell contentView] setBackgroundColor:[UIColor clearColor]];
    [[newCell backgroundView] setBackgroundColor:[UIColor clearColor]];
    return newCell;
}

//tap gesture recognizer
- (void) hideLeftView{
    CGFloat time = 0.3;
    [UIView animateWithDuration:time
                     animations:^{
                         self.leftView.frame = CGRectMake( - self.leftView.frame.size.width, 0,
                                                          self.leftView.frame.size.width, self.leftView.frame.size.height);
                     }
                     completion:NULL];
}

- (void) showLeftView{
    CGFloat time = 0.3;
    [UIView animateWithDuration:time
                     animations:^{
                         self.leftView.frame = CGRectMake(0, 0,
                                                          self.leftView.frame.size.width, self.leftView.frame.size.height);
                     }
                     completion:NULL];
}

- (IBAction)tapAction:(id)sender {
    if (self.leftviewindex == AVLeftViewEnable) {
        self.leftviewindex = AVLeftViewDisable;
        [self hideLeftView];
    } else {
        self.leftviewindex = AVLeftViewEnable;
        [self showLeftView];
    }
}

//

//dismissing current view controller
- (IBAction)closeController:(id)sender {
    CGFloat timeForAnimation = 0.3;
    [[ServerFetcher sharedInstance]CancelDownloads];
    if (self.mainView.zoomScale > 1) {
        [UIView animateWithDuration:timeForAnimation
                         animations:^{
                             
                             [self.mainView setZoomScale:0.9];
                             
                         } completion:^(BOOL finished) {
                         }];
    } //else {
    [UIView animateWithDuration:timeForAnimation
                     animations:^{
                         self.imageView.layer.frame = CGRectMake(112, 44, 800, 656);
                         self.imageView.center = CGPointMake(512, 372);
                     } completion:^(BOOL finished) {
                     }];
    //  }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeForAnimation ) * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [self dismissViewControllerAnimated:NO completion:nil];
                       
                       
                       
                   });
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

@end
