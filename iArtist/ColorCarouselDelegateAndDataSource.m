//
//  ColorCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Barninets on 10.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ColorCarouselDelegateAndDataSource.h"

@interface ColorCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfColor;
    
}

@end

@implementation ColorCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfColor = [[NSArray alloc] initWithObjects:@"red.jpg",@"blue.jpg",@"orange.jpg",@"green.jpeg",@"yellow.jpg",@"grey.jpg",@"brown.jpg", nil];
    
    return [arrayOfColor count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
         button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.frame = CGRectMake(0.0f, 0.0f, 180.0f, 110.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(145, 10, 5, 10)];
        [button setBackgroundImage:[UIImage imageNamed:arrayOfColor[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //set button label
    if (index == 0){
        [button setTitle:IAcolorRed forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:IAcolorBlue forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:IAcolorOrange forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:IAcolorGreen forState:UIControlStateNormal];
    } else if (index == 4){
        [button setTitle:IAcolorYellow forState:UIControlStateNormal];
    } else if (index == 5){
        [button setTitle:IAcolorGrey forState:UIControlStateNormal];
    } else if (index == 6){
        [button setTitle:IAcolorBrown forState:UIControlStateNormal];
    }

    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionSpacing) {
        return 1.1f;
    }
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    
    return value;
}

- (void)buttonTapped:(UIButton *)sender{
    ServerFetcher *DownloadManager;
    DownloadManager = [ServerFetcher sharedInstance];
    if ([sender.titleLabel.text isEqualToString:IAcolorRed]) {
        [DownloadManager GenerateQueryForTag:IAcolorRed];
        
    } if ([sender.titleLabel.text isEqualToString:IAcolorBlue]) {
        [DownloadManager GenerateQueryForTag:IAcolorBlue];
        
    }else if ([sender.titleLabel.text isEqualToString:IAcolorOrange]) {
        [DownloadManager GenerateQueryForTag:IAcolorOrange];
        
    }else if ([sender.titleLabel.text isEqualToString:IAcolorGreen]) {
        [DownloadManager GenerateQueryForTag:IAcolorGreen];
    } else  if ([sender.titleLabel.text isEqualToString:IAcolorYellow]) {
        [DownloadManager GenerateQueryForTag:IAcolorYellow];
    }
    else  if ([sender.titleLabel.text isEqualToString:IAcolorGrey]) {
        [DownloadManager GenerateQueryForTag:IAcolorGrey];
    }
    else  if ([sender.titleLabel.text isEqualToString:IAcolorBrown]) {
        [DownloadManager GenerateQueryForTag:IAcolorBrown];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAgoToPictures object:nil userInfo:nil];
}

@end

