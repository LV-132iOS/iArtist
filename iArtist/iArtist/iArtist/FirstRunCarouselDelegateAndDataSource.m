//
//  FirstRunCarouselDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FirstRunCarouselDelegateAndDataSource.h"
#import "FXImageView.h"

@interface FirstRunCarouselDelegateAndDataSource ()

@property (nonatomic, strong) NSMutableArray *images;

@end



@implementation FirstRunCarouselDelegateAndDataSource

@synthesize images = _images;

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //get image paths
        NSArray *imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"Lake"];
        
        //preload images (although FXImageView can actually do this for us on the fly)
        _images = [[NSMutableArray alloc] init];
        for (NSString *path in imagePaths)
        {
            [_images addObject:[UIImage imageWithContentsOfFile:path]];
        }
        
        FXImageView *imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 1200.0f, 900.0f)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 10.0f;
        view = imageView;
    }
    
//    //show placeholder
//    ((FXImageView *)view).processedImage = [UIImage imageNamed:@"placeholder.png"];
//    
//    //set image
//    ((FXImageView *)view).image = [UIImage imageNamed:@"placeholder.png"];
    
    return view;
}



@end
