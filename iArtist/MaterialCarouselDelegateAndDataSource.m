//
//  MaterialCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Barninets on 10.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "MaterialCarouselDelegateAndDataSource.h"

@interface MaterialCarouselDelegateAndDataSource () {
    
    NSArray* arrayOfMaterial;
    
}

@end

@implementation MaterialCarouselDelegateAndDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    arrayOfMaterial = [[NSArray alloc] initWithObjects:@"Pastel.jpg",@"Oil on canvas.jpg",@"Enamel.jpg",@"Acrylic on canvas.jpg",@"Colored pencil.jpg",@"Acrylic & Enamel.jpg",@"Pastel on canvas.jpg", nil];
    
    return [arrayOfMaterial count];
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
        [button setBackgroundImage:[UIImage imageNamed:arrayOfMaterial[index]] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //set button label
    if (index == 0){
        [button setTitle:@"Pastel" forState:UIControlStateNormal];
    } else if (index == 1){
        [button setTitle:@"Oil on canvas" forState:UIControlStateNormal];
    } else if (index == 2){
        [button setTitle:@"Enamel" forState:UIControlStateNormal];
    } else if (index == 3){
        [button setTitle:@"Acrylic on canvas" forState:UIControlStateNormal];
    } else if (index == 4){
        [button setTitle:@"Colored pencil" forState:UIControlStateNormal];
    } else if (index == 5){
        [button setTitle:@"Acrylic & Enamel" forState:UIControlStateNormal];
    } else if (index == 6){
        [button setTitle:@"Pastel on canvas" forState:UIControlStateNormal];
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
    if ([sender.titleLabel.text isEqualToString:@"Pastel"]) {
        [DownloadManager GenerateQueryForMaterial:@"Pastel"];
        
    } else if ([sender.titleLabel.text isEqualToString:@"Oil on canvas"]){
        [DownloadManager GenerateQueryForMaterial:@"Oil on canvas"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"Enamel"]){
        [DownloadManager GenerateQueryForMaterial:@"Enamel"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"Acrylic on canvas"]){
        [DownloadManager GenerateQueryForMaterial:@"Acrylic on canvas"];
    } else if ([sender.titleLabel.text isEqualToString:@"Acrylic & Enamel"]){
        [DownloadManager GenerateQueryForMaterial:@"Acrylic & Enamel"];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Pastel on canvas"]){
        [DownloadManager GenerateQueryForMaterial:@"Pastel on canvas"];
    }
    

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPictures" object:nil userInfo:nil];
}

@end
