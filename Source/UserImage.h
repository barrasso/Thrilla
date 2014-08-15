//
//  UserImage.h
//  datinggame
//
//  Created by Mark on 7/11/14.
//

#import "CCSprite.h"

@interface UserImage : CCSprite

// Setting this facebook username will trigger the download of the profile picture.
@property (nonatomic, copy) NSString *username;

@end
