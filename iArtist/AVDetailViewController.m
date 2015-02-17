//
//  AVDetailViewController.m
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "AVDetailViewController.h"
#import "ServerFetcher.h"


typedef NS_ENUM(NSInteger, AVLeftView) {
    AVLeftViewEnable,
    AVLeftViewDisable
};

@interface AVDetailViewController ()<UIScrollViewDelegate,  UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UILabel *pictureName;
@property (strong, nonatomic) IBOutlet UILabel *pictureTag;
@property (strong, nonatomic) IBOutlet UILabel *pictureSize;
@property (strong, nonatomic) IBOutlet UILabel *picturePrize;
@property (strong, nonatomic) IBOutlet UILabel *authorsName;
@property (strong, nonatomic) IBOutlet UILabel *authorsType;
@property (strong, nonatomic) IBOutlet UIImageView *authorsImage;
@property (strong, nonatomic) IBOutlet UITextView *pictureDescription;
@property (strong, nonatomic) IBOutlet UITextView *authorDescription;



@property (nonatomic) AVLeftView leftviewindex;

@end

@implementation AVDetailViewController

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
    
}

- (void)inputDataInit{
    
    self.pictureName.text = [self.paintingData valueForKey:@"title"];
    self.picturePrize.text = [self.paintingData valueForKey:@"price"];
    self.pictureDescription.text = [self.paintingData valueForKey:@"description"];
    self.pictureSize.text = [self.paintingData valueForKey:@"realsize"];
    self.pictureTag.text = [(NSArray*)[self.paintingData valueForKey:@"tags"] componentsJoinedByString:@","];
     self.authorsName.text = [self.artistData valueForKey:@"name"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.artistData valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    self.authorsImage.image = img;
    self.authorsImage.contentMode = UIViewContentModeScaleAspectFit;
    
}


- (void)viewDidLoad {
 
    
    [super viewDidLoad];
    [self mainInit];
    [self inputDataInit];
 
    self.imageView = [[UIImageView alloc]initWithImage:[[ServerFetcher sharedInstance] GetPictureWithID:[self.paintingData valueForKey:@"_id"] ]];
    self.imageView.frame = self.mainView.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainView addSubview:self.imageView];


    
    // Do any additional setup after loading the view.
}
//metod for scroll view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
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
    
    if (self.leftviewindex == AVLeftViewEnable) {
        self.leftviewindex = AVLeftViewDisable;
        self.leftView.hidden = YES;
    } else {
        self.leftviewindex = AVLeftViewEnable;
        self.leftView.hidden = NO;
    }
}
//dismissing current view controller
- (IBAction)closeController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
