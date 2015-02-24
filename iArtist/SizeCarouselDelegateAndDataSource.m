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
        [button setTitle:IAsizeSmall forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:IAsizeMedium forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:IAsizeBig forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:IAsizeVeryBig  forState:UIControlStateNormal];
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
    if ([sender.titleLabel.text isEqualToString:IAsizeSmall]) {
        [DownloadManager GenerateQueryForSize:IAsizeSmall];

    } else if ([sender.titleLabel.text isEqualToString:IAsizeMedium]){
        [DownloadManager GenerateQueryForSize:IAsizeMedium];

    } else if ([sender.titleLabel.text isEqualToString:IAsizeBig]){
        [DownloadManager GenerateQueryForSize:IAsizeBig];
    } else if ([sender.titleLabel.text isEqualToString:IAsizeVeryBig]){
        [DownloadManager GenerateQueryForSize:IAsizeVeryBig];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAgoToPictures object:nil userInfo:nil];
}

@end
