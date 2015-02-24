//
//  ArtistsCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Barninets on 10.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ArtistsCarouselDelegateAndDataSource.h"

@interface ArtistsCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfArtists;
    
}

@end

@implementation ArtistsCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfArtists = [[NSArray alloc] initWithObjects:@"artist1.jpg",@"artist2.jpg",@"artist3.jpg",@"artist4.jpg",@"artist5.jpg", nil];
    
    return [arrayOfArtists count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 140.0f, 140.0f);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(85, 10, 5, 10)];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button setImage:[UIImage imageNamed:arrayOfArtists[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //create round image
        button.layer.backgroundColor = [[UIColor clearColor] CGColor];
        button.layer.cornerRadius = 70;
        button.layer.borderWidth = 2.0;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [[UIColor whiteColor]CGColor];
        
        
    }
    
    //set button label
    if (index == 0){
        [button setTitle:@"Artist 1" forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:@"Artist 2" forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:@"Artist 3" forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:@"Artist 4" forState:UIControlStateNormal];
    } else if (index == 4){
        [button setTitle:@"Artist 5" forState:UIControlStateNormal];
    }
    
    
    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionSpacing) {
        return 1.4f;     }
    
    return value;
}

- (void)buttonTapped:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAgoToPictures object:nil userInfo:nil];
}

@end
