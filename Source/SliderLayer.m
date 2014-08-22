//
//  SliderLayer.m
//  Thrilla
//
//  Created by Mark on 8/11/14.
//  Copyright (c) 2014 MEB Productions. All rights reserved.
//

#import "SliderLayer.h"
#import "UserInfo.h"
#import "UserImage.h"

@implementation SliderLayer
{
    // User Image
    UserImage *_playerSprite;
    
    // Labels
    CCLabelTTF *_creditsLabel;
}

#pragma mark - Life Cycle

- (void)onEnter
{
    [super onEnter];
    
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Set user picture
    _playerSprite.username = [[UserInfo sharedUserInfo] username];
    
    // Set user credits
    _creditsLabel.string = [NSString stringWithFormat:@"%i CREDITS", [[UserInfo sharedUserInfo] numberOfCredits]];
}

- (void)onExit
{
    // Deallocate memory
    [super onExit];
}

#pragma mark - Selectors

- (void)viewProfile
{
    // View Profile
}

- (void)viewSettings
{
    // View settings
}

- (void)share
{
    // Prompts user to share app
}

- (void)rate
{
    // Prompts the user to rate app
}

- (void)logout
{
    // Logs the user out of facebook
}

@end
