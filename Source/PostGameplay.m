//
//  PostGameplay.m
//  datinggame
//
//  Created by Mark on 7/9/14.
//

#import "PostGameplay.h"
#import "Gameplay1.h"
#import "UserImage.h"
#import "UserInfo.h"

@implementation PostGameplay
{
    // Labels
    CCLabelTTF *_opponentNameLabel;
    
    // Sprites
    UserImage *_opponentSprite;
    
    // Strings
    NSString *_opponent;
}

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Initialize opponent from previous game
    _opponent = self.previousGame[@"players"][0];

    // Set oppponent name and picture
	NSString *opponentName = [self.previousGame valueForKey:self.previousGame[@"players"][0]];
	_opponentNameLabel.string = [UserInfo shortNameFromName:opponentName];
	_opponentSprite.username = _opponent;
}

- (void)onExit
{
    // Deallocate memory
    [super onExit];
}

#pragma mark - Selectors

- (void)goToChat
{
    // Go to chat with user
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
}

- (void)done
{
    // When user clicks Play Now
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
}

@end
