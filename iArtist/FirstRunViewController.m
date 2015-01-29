//
//  FirstRunViewController.m
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FirstRunViewController.h"

@interface FirstRunViewController (){
    FirstRunCarouselDelegateAndDataSource* delegateAndDataSource;
}

@end

@implementation FirstRunViewController

@synthesize guideCarousel = _guideCarousel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.guideCarousel.type = iCarouselTypeRotary;
    delegateAndDataSource = [[FirstRunCarouselDelegateAndDataSource alloc] init];
    self.guideCarousel.dataSource = delegateAndDataSource;
    self.guideCarousel.delegate = delegateAndDataSource;
    self.guideCarousel.decelerationRate = 1.0f;
    self.guideCarousel.pagingEnabled = YES;
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
- (IBAction)closeGuideButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
