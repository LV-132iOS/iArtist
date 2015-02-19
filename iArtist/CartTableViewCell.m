//
//  AVCartCell.m
//  iArtist
//
//  Created by Andrii V. on 04.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "CartTableViewCell.h"
#import <MessageUI/MessageUI.h>

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendAMailClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"send mail" object:nil userInfo:nil];
    
}

@end
