//
//  WaitingScene.m
//  datinggame
//
//  Created by Mark on 7/14/14.
//

#import "WaitingScene.h"
#import "UserImage.h"
#import "UserInfo.h"
#import "Gameplay1.h"

@implementation WaitingScene
{
    // String
    NSString *_opponent;
    
    // Labels
    CCLabelTTF *_opponentNameLabel;
    CCLabelTTF *_waitingOnLabel;
    
    // Image
    UserImage *_opponentSprite;
}

- (void)onEnter
{
    [super onEnter];
    
    // Set opponent
    _opponent = self.previousGame[@"players"][1];
	
    // Set oppponent name and picture
	NSString *opponentName = _opponent;
	_opponentNameLabel.string = [UserInfo shortNameFromName:opponentName];
	_opponentSprite.username = _opponent;
    
    // Set waiting on label with opponent's name
    _waitingOnLabel.string = [NSString stringWithFormat: @"Let %@ finish",opponentName];
}

- (void)onExit
{
    // Deallocate memory
    [super onExit];
}

#pragma mark - Selectors

- (void)done
{
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
}

@end
