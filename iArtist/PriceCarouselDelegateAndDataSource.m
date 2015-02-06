//
//  PriceCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "PriceCarouselDelegateAndDataSource.h"





@implementation PriceCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 180.0f, 110.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor: [UIColor yellowColor]];
        button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0) {

        [button setTitle:@"<750" forState:UIControlStateNormal];
    } else if (index == 1){

        [button setTitle:@"750-1500" forState:UIControlStateNormal];
    } else if (index == 2){

        [button setTitle:@"1500-3000" forState:UIControlStateNormal];
    } else if (index == 3){

        [button setTitle:@"3000-5000" forState:UIControlStateNormal];
    } else if (index == 4){

        [button setTitle:@">5000" forState:UIControlStateNormal];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil userInfo:nil];
}




@end
