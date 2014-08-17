//
//  UserInfo.m
//  datinggame
//
//  Created by Mark on 7/10/14.
//

#import "UserInfo.h"

@interface UserInfo ()

@property (nonatomic, assign) SEL refreshCallback;
@property (nonatomic, weak) id refreshTarget;

@end

@implementation UserInfo

static id _sharedInstance = nil;

#pragma mark - Initializer

+ (UserInfo *)sharedUserInfo
{
    // If singleton instance has not been created (if first time accessed)
    if (_sharedInstance == nil)
        // Create the singleton instance
        _sharedInstance = [[UserInfo alloc] init];
    
    return _sharedInstance;
}

+ (NSString *)shortNameFromName:(NSString *)name
{
    if ([name isEqualToString:@"Random Player"])
        return @"Rando";
    
    // Split full name into first name + last initial
    NSArray *names = [name componentsSeparatedByString:@" "];
    int count = (int)[names count];
    if (count == 1)
        return name;
    else
        return [NSString stringWithFormat:@"%@ %@", names[0], [names[count-1] substringToIndex:0]];
}

#pragma mark - Refreshing

- (void)refreshWithCallback:(SEL)callback onTarget:(id)target
{
    self.refreshCallback = callback;
    self.refreshTarget = target;
    
    [MGWU getMyInfoWithCallback:@selector(refreshCompleted:) onTarget:self];
}

- (void)refreshCompleted:(NSDictionary *)userInfo
{
    [self extractUserInformation:userInfo];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
	[self.refreshTarget performSelector:self.refreshCallback withObject:userInfo];
    
    #pragma clang diagnostic pop
}

#pragma mark - Extract User Information

- (void)extractUserInformation:(NSDictionary *)userInfo
{
    // Extract Name and Username
    _name = userInfo[@"info"][@"name"];
    _username = userInfo[@"info"][@"username"];
    
    [self splitGames:userInfo];
    
    _friends = [NSMutableArray arrayWithArray:userInfo[@"friends"]];
}

- (void)splitGames:(NSDictionary *)userInfo
{
    // Divide games into: Your Turn, Their Turn and Matches
    self.gamesYourTurn = [[NSMutableArray alloc] init];
    self.gamesTheirTurn = [[NSMutableArray alloc] init];
    self.successfulMatches = [[NSMutableArray alloc] init];
    
    self.allGames = userInfo[@"games"];
    
    for(NSMutableDictionary *game in self.allGames)
    {
        NSString *gameState = game[@"gamestate"];
        NSString *turn = game[@"turn"];
        
        NSString *opponent;
        NSArray *gamers = game[@"players"];
        if ([gamers[0] isEqualToString:self.username])
            opponent = gamers[1];
        else
            opponent = gamers[0];
        
        NSString *oppName = game[opponent];
        game[@"opponent"] = opponent;
        game[@"opponentName"] = oppName;
        
        if ([gameState isEqualToString:@"ended"])
            [self.successfulMatches addObject:game];
        else if ([turn isEqualToString:self.username])
            [self.gamesYourTurn addObject:game];
        else
            [self.gamesTheirTurn addObject:game];
    }
}

#pragma mark - User Property Methods

- (void)giveUserDailyCredits
{
    
}

- (void)spentCredits
{
    
}

- (void)boughtCredits
{
    
}

@end
