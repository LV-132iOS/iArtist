//
//  MessageDelegate.h
//  iArtist
//
//  Created by Vitalii Zamirko on 3/10/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MessageDelegate : NSObject <MFMessageComposeViewControllerDelegate>

typedef void (^SucBlock)();
@property(nonatomic,strong) SucBlock block;

@end
