//
//  MainScene.h
//  The Dating Game
//
//  Created by Mark on 07/02/14.
//

#import "CCNode.h"
#import "UserImage.h"

@interface MainScene : CCNode <CCTableViewDataSource>

// Load user info
- (void)loadedUserInfo:(NSDictionary *)userInfo;

@end
