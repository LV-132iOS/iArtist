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
    
    arrayOfPrice = [[NSArray alloc] initWithObjects:@"Price1.jpg",@"Price2.jpg",@"Price3.jpg",@"Price4.jpg",@"Price5.jpg",@"Price6.jpg", nil];
    
    return [arrayOfPrice count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 140.0f, 110.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(145, 10, 5, 10)];
        [button setBackgroundImage: [UIImage imageNamed:arrayOfPrice[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0) {
        [button setTitle:@"<100" forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:@"100-150" forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:@"150-200" forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:@"200-300" forState:UIControlStateNormal];
    } else if (index == 4){
        [button setTitle:@"300-400" forState:UIControlStateNormal];
    } else if (index == 5){
        [button setTitle:@">500" forState:UIControlStateNormal];
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
    if ([sender.titleLabel.text isEqualToString:@"<100"]) {
        [DownloadManager GenerateQueryForPrice:0 :100];
        
    } else if ([sender.titleLabel.text isEqualToString:@"100-150"]){
        [DownloadManager GenerateQueryForPrice:100 :150];
        
    }else if ([sender.titleLabel.text isEqualToString:@"150-200"]){
        [DownloadManager GenerateQueryForPrice:150 :200];
        
    }else if ([sender.titleLabel.text isEqualToString:@"300-400"]){
        [DownloadManager GenerateQueryForPrice:300 :400];
    } else if ([sender.titleLabel.text isEqualToString:@">500"]){
        [DownloadManager GenerateQueryForPrice:500 :10000];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil];
}

@end
