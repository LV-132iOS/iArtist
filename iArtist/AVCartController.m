//
//  AVCartController.m
//  iArtist
//
//  Created by Andrii V. on 04.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "AVCartController.h"
#import "AVCartCell.h"
#import "AVPicture.h"
#import "AVPictureViewController.h"

@interface AVCartController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate >

@property (strong, nonatomic) IBOutlet UILabel *totalAmount;

@property (strong, nonatomic) IBOutlet UILabel *totalPrise;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@property (nonatomic) NSInteger indexDelete;

@end

@implementation AVCartController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    AVManager *manager = [AVManager sharedInstance];
    self.pictureArray = [[NSMutableArray alloc] initWithArray:manager.session.arrayOfPictures];
    self.totalAmount.text = [@"Total Amount: " stringByAppendingString:
                             [NSString stringWithFormat:@"%d", [self.pictureArray count]]];
    NSInteger totalNumber = 0;

    for (int i = 0; i < [self.pictureArray count]; i++) {
        
        AVPicture *picture = (AVPicture *)[self.pictureArray objectAtIndex:i];
        totalNumber += picture.prise;
    }

    self.totalPrise.text = [@"Total Prise: " stringByAppendingString:[NSString stringWithFormat:@"%d", totalNumber]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.pictureArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AVCartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Buy Cell" forIndexPath:indexPath];

    AVPicture *currentPicture = [self.pictureArray objectAtIndex:indexPath.row];
    cell.artistName.text = currentPicture.pictureAuthor.authorsName;
    cell.pictureName.text = currentPicture.pictureName;
    cell.picturePrise.text = [NSString stringWithFormat: @"%d", currentPicture.prise];
    cell.pictureImage.image = currentPicture.pictureImage;
    cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.tag = indexPath.row;
    return cell;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session.arrayOfPictures = [[NSMutableArray alloc] initWithArray:self.pictureArray];
    dataManager.index = ((AVCartCell *)sender).tag;
    if ([segue.identifier isEqualToString:@"Cart to Picture View"]) {
        
    }
}*/

- (void)reload{
    NSString *str1 = [self.totalAmount.text substringFromIndex:14];
    NSInteger totalAmount = str1.intValue;
    totalAmount --;
    self.totalAmount.text = [@"Total Amount: " stringByAppendingString:[NSString stringWithFormat:@"%d", totalAmount]];
    NSString *str2 = [self.totalPrise.text substringFromIndex:13];
    NSInteger totalPrise = str2.intValue;
    totalPrise -= ((AVPicture *)[self.pictureArray objectAtIndex:self.indexDelete]).prise;
    self.totalPrise.text = [@"Total Prise: " stringByAppendingString:[NSString stringWithFormat:@"%d", totalPrise]];
    
    [self.pictureArray removeObjectAtIndex:self.indexDelete];
    
    [self.cartTableView reloadData];
}

- (IBAction)deleteFromCart:(id)sender {
    AVCartCell *currentCell =  (AVCartCell *)((((UIButton *)sender).superview).superview);
    self.indexDelete = currentCell.tag;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You clicked on delete"
                                                    message:@"Do you want to remove picture from cart?"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cansel"
                                          otherButtonTitles:@"Ok",nil];
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)[self reload];
    
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
