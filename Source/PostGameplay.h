//
//  PostGameplay.h
//  datinggame
//
//  Created by Mark on 7/9/14.
//

#import "CCNode.h"
#import "Gameplay1.h"

@interface PostGameplay : CCNode

// Get previous Gameplay information
@property (nonatomic, strong) NSMutableDictionary *previousGame;

@end
