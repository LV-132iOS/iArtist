//
//  ViewController.h
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "AVManager.h"
#import "AVSession.h"

@interface ViewController : UIViewController<UISearchBarDelegate>

@property (strong) GPPSignIn* signIn;
@property (weak, nonatomic) IBOutlet iCarousel          *priceCarousel;
@property (weak, nonatomic) IBOutlet iCarousel          *sizeCarousel;
@property (weak, nonatomic) IBOutlet iCarousel          *styleCarousel;
@property (weak, nonatomic) IBOutlet iCarousel          *tagCarousel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *loginButton;
@property (weak, nonatomic) IBOutlet UISearchBar        *searchBar;



@end

