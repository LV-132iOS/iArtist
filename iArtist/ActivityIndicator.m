//
//  ActivityIndicator.m
//  iArtist
//
//  Created by Andrii V. on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

- (void) megaInit{
    self.image = [UIImage imageNamed:@"IndicatorPart1.png"];
    self.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"Indicator1.png"],
                            [UIImage imageNamed:@"Indicator10.png"],
                            [UIImage imageNamed:@"Indicator9.png"],
                            [UIImage imageNamed:@"Indicator8.png"],
                            [UIImage imageNamed:@"Indicator7.png"],
                            [UIImage imageNamed:@"Indicator6.png"],
                            [UIImage imageNamed:@"Indicator5.png"],
                            [UIImage imageNamed:@"Indicator4.png"],
                            [UIImage imageNamed:@"Indicator3.png"],
                            [UIImage imageNamed:@"Indicator2.png"],nil];
    self.animationDuration = 1.0;
}

- (void) start{
        [self startAnimating];
}

- (void) stop{
        [self stopAnimating];
}

@end
