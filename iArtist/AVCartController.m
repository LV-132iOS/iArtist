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
#import "AVCartCell.h"


@interface AVCartController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate >

@property (strong, nonatomic) IBOutlet UILabel *totalAmount;

@property (strong, nonatomic) IBOutlet UILabel *totalPrise;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@property (nonatomic) NSInteger indexDelete;

@end


@implementation AVCartController


-(NSMutableArray *)AllPaintingData{
     @synchronized(self){return PurchuasedPaintingData;}
}

-(NSMutableArray *)ImageArray{
    NSLog(@"%@",PurchuasedImageArray);
    @synchronized(self){return PurchuasedImageArray;}
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.totalAmount.text = [@"Total Amount: " stringByAppendingString:
                             [NSString stringWithFormat:@"%lu", (unsigned long)[self.ImageArray count]]];
    NSInteger Overal = 0;

    for (int i = 0; i < [PurchuasedPaintingData count]; i++) {
        
      Overal += [[PurchuasedPaintingData[i] valueForKey:@"price"]  integerValue];
        
           }

    self.totalPrise.text = [@"Overal: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)Overal]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SendAMail:)
                                                 name:@"send mail"
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [PurchuasedImageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AVCartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Buy Cell" forIndexPath:indexPath];

    cell.artistName.text = [[self.AllPaintingData objectAtIndex:indexPath.row] valueForKeyPath:@"artistid.name"];
    cell.pictureName.text = [[self.AllPaintingData objectAtIndex:indexPath.row] valueForKeyPath:@"title"];
    cell.picturePrise.text = [[self.AllPaintingData objectAtIndex:indexPath.row] valueForKeyPath:@"price"];
    cell.pictureImage.image = [self.ImageArray objectAtIndex:indexPath.row];
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
    self.totalAmount.text = [@"Total Amount: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)totalAmount]];
    NSString *str2 = [self.totalPrise.text substringFromIndex:13];
    NSInteger totalPrise = str2.intValue;
    totalPrise -= [[self.AllPaintingData[self.indexDelete] valueForKey:@"price"]  integerValue];;
    self.totalPrise.text = [@"Overal: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)totalPrise]];
    
    [self.ImageArray removeObjectAtIndex:self.indexDelete];
    
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


- (void) SendAMail:(NSNotification *)notification{
    
    if ([MFMailComposeViewController canSendMail] == YES)
        
    {
        // Set up
        self.myMail = [[MFMailComposeViewController alloc] init];
        
        self.myMail.mailComposeDelegate = self;
        
        
        // Set the subject
        
        [self.myMail setSubject:@"My app feedback"];
        
        // To recipients
        
        NSArray *toResipients = [[NSArray alloc] initWithObjects:@"iArtistGreatTeam@gmail.com", nil];
        
        [self.myMail setToRecipients:toResipients];
        
        // Add some text to message body
        
        NSString *sentFrom = @"Email sent from my app";
        
        [self.myMail setMessageBody:sentFrom
                             isHTML:YES];
        
        // Include an attachment
        
        UIImage *tagImage = [UIImage imageNamed:@"background.jpg"];
        
        NSData *imageData = UIImageJPEGRepresentation(tagImage, 1.0);
        
        [self.myMail addAttachmentData:imageData
                              mimeType:@"image/jpeg"
                              fileName:@"tag"];
        
        // Display the view controller
        
        [self presentViewController:self.myMail
                      animated:YES
                    completion:nil];
        
    }
    
    else
        
    {
        
        UIAlertView *errorAlter = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Your device can not send email"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        
        [errorAlter show];
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
            
        case MFMailComposeResultCancelled:
            // Do something
            break;
            
        case MFMailComposeResultFailed:
            // Do something
            break;
            
        case MFMailComposeResultSaved:
            // Do something
            break;
            
        case MFMailComposeResultSent:
        {
            
            UIAlertView *thankYouAlter = [[UIAlertView alloc] initWithTitle:@"Thank You"
                                                                    message:@"Thank you for your email"
                                                                   delegate:self cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
            
            [thankYouAlter show];
            
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES
                          completion:nil];
    
}


// we remove our notification as soon as we don't need it

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
