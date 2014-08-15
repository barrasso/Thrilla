//
//  WaitingScene.h
//  datinggame
//
//  Created by Mark on 7/14/14.
//

#import "CCNode.h"
#import "Gameplay1.h"

@interface WaitingScene : CCNode

// Get previous Gameplay information
@property (nonatomic, strong) NSMutableDictionary *previousGame;

@end
