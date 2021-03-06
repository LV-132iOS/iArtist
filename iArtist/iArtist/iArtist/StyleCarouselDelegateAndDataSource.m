//
//  StyleCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "StyleCarouselDelegateAndDataSource.h"
#import "ServerFetcher.h"


@interface StyleCarouselDelegateAndDataSource (){
    NSArray* arrayOfStyles;
    NSArray* arrayOfPictures;
}

@end

@implementation StyleCarouselDelegateAndDataSource


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfPictures = [[NSArray alloc] initWithObjects:@"Style1.jpg",@"Style2.jpg",@"Style3.jpg",@"Style4.jpg",@"Style5.jpg",@"Style6.jpg", nil];
    arrayOfStyles = [[NSArray alloc] initWithObjects:@"History",@"Nature",@"Military",@"Portrait",@"Still life",@"Vanitas", nil];
    return arrayOfStyles.count;
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 500.0f, 300.0f); //button.frame = CGRectMake(0.0f, 0.0f, 300.0f, 180.0f);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(160, 10, 5, 10)];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //set button label and images
    [button setTitle:arrayOfStyles[index] forState:UIControlStateNormal];
    [button setBackgroundImage: [UIImage imageNamed:arrayOfPictures[index]] forState:UIControlStateNormal];
    button.contentMode = UIViewContentModeScaleAspectFit;
    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return 1.0f;
    }
    if (option == iCarouselOptionSpacing) {
        return 1.4f;
    }
    if (option == iCarouselOptionVisibleItems) {
        return 5;
    }
    
    return value;
}

- (void)buttonTapped:(UIButton *)sender{
    ServerFetcher *DownloadManager;
      DownloadManager = [ServerFetcher sharedInstance];
    if ([sender.titleLabel.text isEqualToString:@"History"]) {
        [DownloadManager GenerateQueryForTag:@"History"];
        
    } else if ([sender.titleLabel.text isEqualToString:@"Nature"]){
        [DownloadManager GenerateQueryForTag:@"Nature"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"Military"]){
        [DownloadManager GenerateQueryForTag:@"Red"];
    }
    if ([sender.titleLabel.text isEqualToString:@"Portrait"]) {
        [DownloadManager GenerateQueryForTag:@"Portrait"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"Still life"]){
        [DownloadManager GenerateQueryForTag:@"Korkuna"];
    }  if ([sender.titleLabel.text isEqualToString:@"Vanitas"]) {
        [DownloadManager  GenerateQueryForTag:@"Blue"];
    
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil userInfo:nil];
}



@end
