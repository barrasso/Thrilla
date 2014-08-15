//
//  UserInfo.h
//  datinggame
//
//  Created by Mark on 7/10/14.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

#pragma mark - User Info Properties

// Full Name of current user
@property (nonatomic, copy, readonly) NSString *name;

// Facebook username of current user
@property (nonatomic, copy, readonly) NSString *username;

// Games where current user is waiting
@property (nonatomic, strong) NSMutableArray *gamesTheirTurn;

// Games where it is current user's turn
@property (nonatomic, strong) NSMutableArray *gamesYourTurn;

// Completed games and successful matches
@property (nonatomic, strong) NSMutableArray *successfulMatches;

// List of all games
@property (nonatomic, strong) NSMutableArray *allGames;

// List of Facebook friends
@property (nonatomic, strong) NSMutableArray *friends;

#pragma mark - User Info Methods

// Access to User Info Singleton
+ (instancetype)sharedUserInfo;

// Converts a name like "Mark Barrasso" to "Mark B"
+ (NSString *)shortNameFromName: (NSString *)name;

// Download latest information from server and update User Info with latest data.
// After successful download this method calls the provided callback on the provided target
- (void)refreshWithCallback:(SEL)callback onTarget:(id)target;

@end
