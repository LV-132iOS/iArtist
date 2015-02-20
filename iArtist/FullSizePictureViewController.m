//
//  AVDetailViewController.m
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FullSizePictureViewController.h"
#import "ServerFetcher.h"


typedef NS_ENUM(NSInteger, AVLeftView) {
    AVLeftViewEnable,
    AVLeftViewDisable
};

@interface FullSizePictureViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton                 *closeButton;
@property (strong, nonatomic) IBOutlet UIView                   *leftView;
@property (strong, nonatomic) IBOutlet UITableView              *pictureInfo;
@property (strong, nonatomic) IBOutlet UITextView               *authorInfo;
@property (strong, nonatomic) IBOutlet UILabel                  *authorsName;
@property (strong, nonatomic) IBOutlet UILabel                  *authorsData;
@property (strong, nonatomic)          UIImageView              *authorsImage;
@property (strong, nonatomic)          UITextView               *pictureDescription;
@property (strong, nonatomic) IBOutlet UIButton                 *authorButton;
@property (nonatomic)                  AVLeftView               leftviewindex;
@property (strong, nonatomic) IBOutlet UILabel                  *price;
@property (strong, nonatomic) IBOutlet UIButton                 *like;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView  *indicator;





@end

@implementation FullSizePictureViewController

CGFloat neededScale;

#pragma mark - data initialization
//getting data from input


- (void)mainInit
{
    self.mainView.contentSize = CGSizeMake(1024, 768);
    self.leftviewindex = AVLeftViewEnable;
    self.mainView.delegate = self;
    
    self.mainView.maximumZoomScale = 2.5;
    
    self.mainView.minimumZoomScale = 1;
    [self.mainView bringSubviewToFront:self.closeButton];
    self.authorInfo.hidden = YES;
    
}

- (void)inputDataInit{
    
    //self.pictureName.text = [self.paintingData valueForKey:@"title"];
    //self.picturePrize.text = [self.paintingData valueForKey:@"price"];
    self.pictureDescription.text = [self.paintingData valueForKey:@"description"];
    //self.pictureSize.text = [self.paintingData valueForKey:@"realsize"];
   // self.pictureTag.text = [(NSArray*)[self.paintingData valueForKey:@"tags"] componentsJoinedByString:@","];
     self.authorsName.text = [self.artistData valueForKey:@"name"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.artistData valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    self.authorsImage.image = img;
    self.authorsImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.indicator startAnimating];
    self.indicator.hidesWhenStopped = YES;
    [self.view bringSubviewToFront:self.indicator];
    
    self.indicator.transform = CGAffineTransformMakeScale(4, 4);
    
    
    [[ServerFetcher sharedInstance]GetPictureWithID:[self.paintingData valueForKey:@"_id"] callback:^(UIImage *responde) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = responde;
            [self.indicator stopAnimating];
            
            NSLog(@"Ok");
        });
        
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView.pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        neededScale  = scrollView.zoomScale;
    }
    if((scrollView.pinchGestureRecognizer.state == UIGestureRecognizerStateEnded)&&(neededScale < 0.8)){
        [self closeController:nil];
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
- (IBAction)tapAction:(id)sender {
    
    CGFloat time = 0.3;
    if (self.leftviewindex == AVLeftViewEnable) {
        self.leftviewindex = AVLeftViewDisable;
        [UIView animateWithDuration:time
                         animations:^{
                             self.leftView.frame = CGRectMake( - self.leftView.frame.size.width, 0,
                                                              self.leftView.frame.size.width, self.leftView.frame.size.height);
                         }
                         completion:NULL];
    } else {
        self.leftviewindex = AVLeftViewEnable;
        [UIView animateWithDuration:time
                         animations:^{
                             self.leftView.frame = CGRectMake(0, 0,
                                                              self.leftView.frame.size.width, self.leftView.frame.size.height);
                         }
                         completion:NULL];
    }
}
//dismissing current view controller
- (IBAction)closeController:(id)sender {
    CGFloat timeForAnimation = 0.3;
    [UIView animateWithDuration:timeForAnimation animations:^{
        self.imageView.frame = CGRectMake(112, 44, 800, 656);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } completion:^(BOOL finished) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeForAnimation) * NSEC_PER_SEC)),
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
