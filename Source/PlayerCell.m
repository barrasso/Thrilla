//
//  PlayerCell.m
//  datinggame
//
//  Created by Mark on 7/11/14.
//

#import "PlayerCell.h"
#import "UserImage.h"

@implementation PlayerCell
{
    UserImage *_playerImage;
}

- (void)setPlayer:(NSDictionary *)player
{
    _player = [player copy];
    
    [_playerImage setUsername:_player[@"username"]];
}

@end
