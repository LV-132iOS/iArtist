//
//  AVTestViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 28.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVTestViewController.h"
#import "AVManager.h"

@interface AVTestViewController ()

@end

@implementation AVTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVSession *session = [AVSession sessionInit];
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;
    dataManager.index = 0;
    dataManager.wallImage = [UIImage imageNamed:@"room1.jpg"];
    
    if ([segue.identifier isEqualToString:@"PictureView"]) {
        ((AVPictureViewController *)segue.destinationViewController).session = session;
        ((AVPictureViewController *)segue.destinationViewController).intputPictureIndex = 0;
    }
    if ([segue.identifier isEqualToString:@"News"]) {
        ((AVNews *)segue.destinationViewController).session = session;

    }
    
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)pushController:(id)sender {
    
    /*AVPainterViewController *painterController = [AVPainterViewController new];
    AVPictureViewController *pictureController = [AVPictureViewController new];
    AVSession *session = [AVSession sessionInit];
    painterController.session = session;
    pictureController.session = session;
    
    NSDictionary *newDictionary = @{@"session" :session, @"index":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:AVSessionInput object:nil userInfo:newDictionary];
    
    painterController.pictureController = pictureController;
    pictureController.painterController = painterController;
    
    [self showViewController:pictureController sender:sender];
    */
}

@end
