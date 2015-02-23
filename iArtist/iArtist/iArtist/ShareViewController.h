//
//  ShareViewController.h
//  iArtist
//
//  Created by Vitalii Zamirko on 2/6/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <TwitterKit/TwitterKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface ShareViewController : UIViewController

@property (nonatomic, strong) UIImage* imageToShare; 
@property (nonatomic, strong) NSURL* imageUrl;
@property (nonatomic, strong) NSString* headString;
@property (nonatomic, strong) NSURL* urlToPass;

@end
