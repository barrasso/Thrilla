//
//  PlayerCell.h
//  datinggame
//
//  Created by Mark on 7/11/14.
//

#import "CCNode.h"

@interface PlayerCell : CCNode

// Name of the player
@property (strong) CCLabelTTF *nameLabel;

// Load player to get FB picture
@property (nonatomic, copy) NSDictionary *player;

@end
