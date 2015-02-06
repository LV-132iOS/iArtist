//
//  TagCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "TagCarouselDelegateAndDataSource.h"

@interface TagCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfTag;
    
}

@end

@implementation TagCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfTag = [[NSArray alloc] initWithObjects:@"Tags1.jpg",@"Tags2.jpg",@"Tags3.jpg",@"Tags4.jpg",@"Tags5.jpg", nil];
    
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
        [button setTitleEdgeInsets:UIEdgeInsetsMake(145, 10, 5, 10)];
        [button setBackgroundImage:[UIImage imageNamed:arrayOfTag[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    if (index == 0){
        [button setTitle:@"#GreatView" forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:@"#Excellent" forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:@"#Girls" forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:@"#1DayWork" forState:UIControlStateNormal];
    } else if (index == 4){
        [button setTitle:@"#Halloween" forState:UIControlStateNormal];
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
