//
//  SizeCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SizeCarouselDelegateAndDataSource.h"
#import "ServerFetcher.h"

@interface SizeCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfSize;
    
}
@end

@implementation SizeCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfSize = [[NSArray alloc] initWithObjects:@"Size1.jpg",@"Size2.jpg",@"Size3.jpg",@"Size4.jpg", nil];
    
    return 4;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 220.0f, 110.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(145, 10, 5, 10)];
        [button setBackgroundImage:[UIImage imageNamed:arrayOfSize[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0) {
        [button setTitle:@"Small" forState:UIControlStateNormal];
        //button.titleLabel.font = [button.titleLabel.font fontWithSize:20];
    } else if (index == 1){
        //button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
        [button setTitle:@"Medium" forState:UIControlStateNormal];
    } else if (index == 2){
        //button.titleLabel.font = [button.titleLabel.font fontWithSize:30];
        [button setTitle:@"Big" forState:UIControlStateNormal];
    } else if (index == 3){
        //button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
        [button setTitle:@"Very Big" forState:UIControlStateNormal];
    }
    
    
    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionSpacing) {
        return 1.1f;
    }
    
    return value;
}

- (void)buttonTapped:(UIButton *)sender{
    ServerFetcher *DownloadManager;
      DownloadManager = [ServerFetcher sharedInstance];
    if ([sender.titleLabel.text isEqualToString:@"Small"]) {
        [DownloadManager GenerateQueryForSize:@"Small"];

    } else if ([sender.titleLabel.text isEqualToString:@"Medium"]){
        [DownloadManager GenerateQueryForSize:@"Medium"];

    }else if ([sender.titleLabel.text isEqualToString:@"Big"]){
        [DownloadManager GenerateQueryForSize:@"Big"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil userInfo:nil];
}

@end
