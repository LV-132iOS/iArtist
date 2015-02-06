//
//  SizeCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SizeCarouselDelegateAndDataSource.h"


@implementation SizeCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
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
        [button setBackgroundColor: [UIColor greenColor]];
        button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0) {
        button.titleLabel.font = [button.titleLabel.font fontWithSize:20];
        [button setTitle:@"Small" forState:UIControlStateNormal];
    } else if (index == 1){
        button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
                [button setTitle:@"Medium" forState:UIControlStateNormal];
    } else if (index == 2){
        button.titleLabel.font = [button.titleLabel.font fontWithSize:30];
                [button setTitle:@"Big" forState:UIControlStateNormal];
    } else if (index == 3){
        button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
                [button setTitle:@"Several pictures" forState:UIControlStateNormal];
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
