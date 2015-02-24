//
//  PriceCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "PriceCarouselDelegateAndDataSource.h"
#import "ServerFetcher.h"


@interface PriceCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfPrice;
    
}
@end

@implementation PriceCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfPrice = [[NSArray alloc] initWithObjects:
                    @"priceTwo.jpg",
                    @"priceThree.jpg",
                    @"priceFour.jpg",
                    @"priceTwo.jpg",
                    @"priceThree.jpg",
                    @"priceFour.jpg",
                    @"priceThree.jpg",
                    nil];
    
    return [arrayOfPrice count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 180.0f, 110.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(15, 10, 5, 10)];
        [button setBackgroundImage: [UIImage imageNamed:arrayOfPrice[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0) {
        
        [button setTitle:IApriceVeryLow forState:UIControlStateNormal];
    } else if (index == 1){
        
        [button setTitle:IApriceLow forState:UIControlStateNormal];
    } else if (index == 2){
        
        [button setTitle:IApriceMiddleLow forState:UIControlStateNormal];
    } else if (index == 3){
        
        [button setTitle:IApriceMiddleLevel forState:UIControlStateNormal];
    } else if (index == 4){
        
        [button setTitle:IApriceMiddleHigh forState:UIControlStateNormal];
    } else if (index == 5){
        
        [button setTitle:IApriceHigh forState:UIControlStateNormal];
    } else if (index == 6){
        
        [button setTitle:IApriceVeryHigh forState:UIControlStateNormal];
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
    if ([sender.titleLabel.text isEqualToString:IApriceVeryLow]) {
        [DownloadManager GenerateQueryForPrice:0 :750];
        
    } else if ([sender.titleLabel.text isEqualToString:IApriceLow]){
        [DownloadManager GenerateQueryForPrice:750 :1500];
        
    }else if ([sender.titleLabel.text isEqualToString:IApriceMiddleLow]){
        [DownloadManager GenerateQueryForPrice:1500 :3000];
        
    }else if ([sender.titleLabel.text isEqualToString:IApriceMiddleLevel]){
        [DownloadManager GenerateQueryForPrice:3000 :4000];
    } else if ([sender.titleLabel.text isEqualToString:IApriceMiddleHigh]){
        [DownloadManager GenerateQueryForPrice:4000 :5000];
    }
    else if ([sender.titleLabel.text isEqualToString:IApriceHigh]){
        [DownloadManager GenerateQueryForPrice:5000 :6000];
    }
    else if ([sender.titleLabel.text isEqualToString:IApriceVeryHigh]){
        [DownloadManager GenerateQueryForPrice:6000 :10000];
    }


    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAgoToPictures object:nil];
}

@end
