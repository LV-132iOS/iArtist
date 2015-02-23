//
//  AVViewControllerBetweenPopoverAndPikerView.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 20.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetDistanceToWallViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *background;

@property (strong, nonatomic) NSNumber *distanceToWall;

@property (strong, nonatomic) IBOutlet UILabel *showInputNumber;

@property (strong, nonatomic) IBOutlet UISlider *inputNumber;

- (IBAction)valueChanged:(id)sender;

- (IBAction)okClick:(id)sender;

- (IBAction)CanselClick:(id)sender;

extern NSString *const AVDidSelectDistanceToWall;

@end
