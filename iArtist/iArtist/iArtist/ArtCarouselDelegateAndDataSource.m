//
//  ArtCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ArtCarouselDelegateAndDataSource.h"

@interface ArtCarouselDelegateAndDataSource (){
    NSArray* arrayOfStyles;
    NSArray* arrayOfPictures; //for now disabled
}

@end

@implementation ArtCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfStyles = [[NSArray alloc] initWithObjects:@"Picture1",@"Picture2",@"Picture3",@"Picture4",@"Picture5", nil];
    return arrayOfStyles.count;
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 850.0f, 630.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //instead of setting color it is needed to set picture from database
        [button setBackgroundColor: [UIColor redColor]];
        button.titleLabel.font = [button.titleLabel.font fontWithSize:25];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label
    [button setTitle:arrayOfStyles[index] forState:UIControlStateNormal];
    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return 1.0f;
    }
    if (option == iCarouselOptionSpacing) {
        return 1.2f;
    }
    
    return value;
}

- (void)buttonTapped:(UIButton *)sender{
    UIAlertView* locAlertView = [[UIAlertView alloc] initWithTitle:@"ButtonPressed"
                                                           message: [NSString stringWithFormat:@"Your category: %@", sender.titleLabel.text]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
    [locAlertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToDetails" object:nil userInfo:nil];
}


@end
