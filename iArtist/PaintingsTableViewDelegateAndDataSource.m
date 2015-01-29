//
//  PaintingsTableViewDelegateAndDataSource.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "PaintingsTableViewDelegateAndDataSource.h"

@implementation PaintingsTableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* locCell = [tableView dequeueReusableCellWithIdentifier:@"Buy Cell" forIndexPath:indexPath];
    return locCell;
}


@end
