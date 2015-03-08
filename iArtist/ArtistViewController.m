//
//  ArtistViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ArtistViewController.h"
#import "ServerFetcher.h"

@interface ArtistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *FollowButton;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set imageOfArtist
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults ];
    [[ServerFetcher sharedInstance]CheckIsFollowing:[self.CurrentArtist valueForKey:@"_id"]callback:^(BOOL responde) {
        responde?[self.FollowButton setTitle:@"Unfollow-" forState:UIControlStateNormal]:nil;

    } ];
    self.imageOfArtist.image = self.img;
    self.nameOfArtist.text = [self.CurrentArtist valueForKey:@"name"];
    self.descriptionOfArtist.text = [self.CurrentArtist valueForKey:@"biography"];
    self.Folowers.text = [[NSString stringWithFormat:@"%lu",(unsigned long)[(NSArray*)[self.CurrentArtist valueForKey:@"followers"] count]] stringByAppendingString:@" Followers"];
    self.tosale.text = [[NSString stringWithFormat:@"%lu",(unsigned long)[(NSArray*)[self.CurrentArtist valueForKey:@"paintings"] count]] stringByAppendingString:@" Paintings"];

    self.locationOfArtist.text = [self.CurrentArtist valueForKey:@"location"];
    self.imageOfArtist.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.imageOfArtist.layer.cornerRadius = 100;
    self.imageOfArtist.layer.borderWidth = 2.0;
    self.imageOfArtist.layer.masksToBounds = YES;
    self.imageOfArtist.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //set description

  

}
- (IBAction)FollowArtist:(UIButton*)sender {
    [sender setTitle:@"Unfollow-" forState:UIControlStateNormal];
     [[ServerFetcher sharedInstance]BecomeAFollower:[self.CurrentArtist valueForKey:@"_id"]callback:^(BOOL responde) {
         int n = self.Folowers.text.intValue;
         if(responde){
             n++;
             [sender setTitle:@"Unfollow-" forState:UIControlStateNormal];
         }
         else{
             n--;
             [sender setTitle:@"Follow+" forState:UIControlStateNormal];
         }
         self.Folowers.text = [[[NSNumber numberWithInt:n]stringValue] stringByAppendingString:@" Folowers"];
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end
