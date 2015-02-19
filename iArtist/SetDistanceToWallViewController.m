//
//  AVViewControllerBetweenPopoverAndPikerView.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 20.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "SetDistanceToWallViewController.h"

NSString *const AVDidSelectDistanceToWall = @"AVDidSelectDistanceToWall";

@interface SetDistanceToWallViewController ()

@end

@implementation SetDistanceToWallViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.showInputNumber.text = [[NSString stringWithFormat:@"%.1f",self.inputNumber.value]
                                 stringByAppendingString:@" meters"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//if we change slider value
- (IBAction)valueChanged:(id)sender {
    self.showInputNumber.text = [[NSString stringWithFormat:@"%.1f",self.inputNumber.value]
                                 stringByAppendingString:@" meters"];
    self.distanceToWall = @(self.inputNumber.value);
}
//put distance into notification if ok click
- (IBAction)okClick:(id)sender {
    
    self.distanceToWall = @(self.inputNumber.value);
    NSNumber *distanse = self.distanceToWall;
    
    NSDictionary *newDictionary = @{@"distance":distanse};
    [[NSNotificationCenter defaultCenter]postNotificationName:AVDidSelectDistanceToWall object:nil userInfo:newDictionary];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//return back if cansel
- (IBAction)CanselClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
