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
UILabel * title;

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
        button.frame = CGRectMake(0.0f, 0.0f, 290.0f, 175.0f);
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //set button label and images
        title = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = button.frame.origin.x,
            .origin.y = button.frame.size.height - 25,
            .size.width = button.frame.size.width,
            .size.height = 25}];
        
        title.text = arrayOfStyles[index];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        title.textAlignment = NSTextAlignmentCenter;
        
        [button addSubview:title];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
        [button setImage:[UIImage imageNamed:arrayOfPictures[index]] forState:UIControlStateNormal];
        
    }
    
    return button;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return 1.0f;
    }
    if (option == iCarouselOptionSpacing) {
        return 1.7f;
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
        [DownloadManager GenerateQueryForTag:@"Military"];
    }
    if ([sender.titleLabel.text isEqualToString:@"Portrait"]) {
        [DownloadManager GenerateQueryForTag:@"Portrait"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"Still life"]){
        [DownloadManager GenerateQueryForTag:@"Still life"];
    }  if ([sender.titleLabel.text isEqualToString:@"Vanitas"]) {
        [DownloadManager  GenerateQueryForTag:@"Vanitas"];
    
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil userInfo:nil];
}



@end
