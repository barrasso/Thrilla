//
//  Gameplay1.m
//  Thrilla
//
//  Created by Mark on 7/3/14.
//

//....................../´¯/)
//....................,/¯../
//.................../..../
//............./´¯/'...'/´¯¯`·¸
//........../'/.../..../......./¨¯\
//........('(...´...´.... ¯~/'...')    fu
//.........\.................'...../
//..........''...\.......... _.·´
//............\..............(
//..............\.............\.

#import "Gameplay1.h"
#import "PostGameplay.h"
#import "WaitingScene.h"
#import "ContentRandomizer.h"
#import "UserInfo.h"

// Maximum number of answers
static const int maxTilesSelected = 21;

@implementation Gameplay1
{
    // Integer trackers
    int tilesSelected;
    int roundNumber;
    
    // Global Booleans
    BOOL isGameStarted;
    BOOL isGameEnded;
    
    // Gameplay nodes
    CCNode *_tile1;
    CCNode *_tile2;
    
    // Gameplay labels
    CCLabelTTF *_tileLabel1;
    CCLabelTTF *_tileLabel2;
    CCLabelTTF *_questionLabel;
    CCLabelTTF *_questionCounter;
    
    // Randomizers
    ContentRandomizer *questionRandomizer;
    ContentRandomizer *contentRandomizer1;
    ContentRandomizer *contentRandomizer2;
    
    // Gameplay Arrays
    NSMutableArray *questionContent;
    NSMutableArray *contentArray1;
    NSMutableArray *contentArray2;
    NSMutableArray *firstPlayerResponses;
    NSMutableArray *secondPlayerResponses;
    NSMutableArray *previousResponses;
    
    // Strings
    NSString *playerName1;
    NSString *playerName2;
    NSString *_opponent;
    NSString *_gameState;
    NSString *message;
    
    // Gameplay data dictionary
    NSMutableDictionary *_gameData;
}

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
        
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Initialize Arrays
    [self initializeArrays];

    // Prep Gameplay
    [self preStart];
    
    // Call reload on Gameplay
    [self reload];
    
    // Start game
    [self startGame];
}

- (void)onExit
{
    // Deallocate memory
    [super onExit];
}

- (void)reload
{
    // Load current gamestate and gamedata
    _gameState = _game[@"gamestate"];
    _gameData = _game[@"gamedata"];
    
    // If movecount is 1, then use already created arrays
    if (roundNumber == 1)
    {
        playerName2 = [UserInfo shortNameFromName:[[UserInfo sharedUserInfo] name]];
        
        // Use previous;y initialized content
        _gameData[@"playerName2"] = playerName2;
        questionContent = _gameData[@"questions"];
        contentArray1 = _gameData[@"content1"];
        contentArray2 = _gameData[@"content2"];
        previousResponses = _gameData[@"playerResponses"];
    }
    
    // If this is the first game, intitialize everything
	if (!_gameState)
	{
		// No game exists, create starting game state and game data
		_gameState = @"started";
        
        playerName1 = [UserInfo shortNameFromName:[[UserInfo sharedUserInfo] name]];
        playerName2 = @"placerholder";
        _gameData[@"playerName1"] = playerName1;

        
        // Initialize content arrays from randomizer
        questionContent = [[questionRandomizer createQuestions] mutableCopy];
        contentArray1 = [[contentRandomizer1 createContent1] mutableCopy];
        contentArray2 = [[contentRandomizer2 createContent2] mutableCopy];
        
        // Init game data
		_gameData = [@{@"questions":questionContent, @"content1":contentArray1, @"content2":contentArray2, @"playerResponses":firstPlayerResponses, @"playerName1":playerName1, @"playerName2":playerName2} mutableCopy];
    }
	
    // If the game is ended, display Post Gameplay scene
	if ([_gameState isEqualToString:@"ended"])
	{
        // Display finished recap scene
        PostGameplay *recapEnd = (PostGameplay*)[CCBReader load:@"PostGameplay"];
        CCScene *endHolder = [CCScene node];
        [endHolder addChild:recapEnd];
        recapEnd.positionType = CCPositionTypeNormalized;
        recapEnd.position = ccp(0,0);
        recapEnd.previousGame = self.game;
        [[CCDirector sharedDirector] replaceScene:endHolder];
	}
    
    // If you are waiting on the other player, display Waiting Scene
	else if ([_game[@"turn"] isEqualToString:_opponent])
	{
        // Display waiting recap scene
        WaitingScene *recapWait = (WaitingScene*)[CCBReader load:@"WaitingScene"];
        CCScene *waitHolder = [CCScene node];
        [waitHolder addChild:recapWait];
        recapWait.positionType = CCPositionTypeNormalized;
        recapWait.position = ccp(0,0);
        recapWait.previousGame = self.game;
        [[CCDirector sharedDirector] replaceScene:waitHolder];
	}
}

- (void)preStart
{
    // Set tile tracker to initial value
    tilesSelected = 0;
    roundNumber = [_game[@"movecount"] intValue];
    
    // *** Player and Opponent Information *** //
	NSAssert(_game != nil, @"Game object needs to be assigned before game scene is displayed");
	
    // Get opponent from current game
	_opponent = _game[@"opponent"];
    
    // If the opponent is nil, set it to the current game's opponent
    if (_opponent ==  nil) {
        // in gameplay opponent is always player that is not having the current turn
        NSString *fbUserID;
        NSArray *gamers = _game[@"players"];
        
        // Set the facebook ID to the correct people
        if ([gamers[0] isEqualToString:[[UserInfo sharedUserInfo] username]])
            fbUserID = gamers[1];
        else
            fbUserID = gamers[0];
        
        // Set opponent's name label
        NSString *opponentName = _game[fbUserID];
        
        // Set opponent facebook picture
        _game[@"opponent"] = fbUserID;
        
        // Set opponent actual name
        _game[@"opponentName"] = opponentName;
        
        // Take opponent of the current game
        _opponent = _game[@"opponent"];
    }
}

- (void)startGame
{
    // Set questionlabel to first question
    _questionLabel.string = questionContent[tilesSelected];
    
    // Set tileLabels to first random string
    _tileLabel1.string = contentArray1[tilesSelected];
    _tileLabel2.string = contentArray2[tilesSelected];
    
    // Check if game is started
    isGameStarted = YES;
    
    // Log game started
    [MGWU logEvent:@"game_started"];
}

- (void)endGame
{
    // Pause Game
    self.paused = YES;
    
    // Hide game elements
    _tileLabel1.visible = NO;
    _tileLabel2.visible = NO;
    
    // * Submit Game information to MGWU Server * //
    if (roundNumber == 0)
        [self submitContent:questionContent withContent1:contentArray1 withContent2:contentArray2 withPlayerResponses:firstPlayerResponses withPlayerName1:playerName1 withPlayerName2:playerName2];
    else
        [self submitContent:questionContent withContent1:contentArray1 withContent2:contentArray2 withPlayerResponses:secondPlayerResponses withPlayerName1:playerName1 withPlayerName2:playerName2];
    
    // Log finished game
    [MGWU logEvent:@"finished_game"];
}


#pragma mark - Update Method

- (void)update:(CCTime)delta
{
    // If the game is started
    if (isGameStarted)
    {
        // Update the tileTimer
        NSString *questionCounterString = [NSString stringWithFormat:@"%i / 21",tilesSelected];
        _questionCounter.string = questionCounterString;
        
        // If maximumTiles were selected, end the game
        if (tilesSelected >= maxTilesSelected)
        {
            isGameEnded = YES;
            self.userInteractionEnabled = NO;
            
            // If the game is over
            if (isGameEnded)
                [self endGame];
        }
    }
}

#pragma mark - Game Handling

-(void)submitContent:(NSMutableArray *)questionContent withContent1:(NSMutableArray *)content1 withContent2:(NSMutableArray *)content2 withPlayerResponses:(NSMutableArray *)playerResponseArray withPlayerName1:(NSString *)playerName1 withPlayerName2:(NSString *)playerName2
{
    // Set gameid and movenumber, both start at 0
    int gameId = [_game[@"gameid"] intValue];
    int moveNumber = [_game[@"movecount"] intValue] + 1;
    
    // Create response counter
    int responseCounter = 0;
    
    // If this is the first turn of the game
    if (moveNumber == 1)
    {
        // Set game state to started
        _gameState = @"started";
        
        // Set push message for first turn
        message = [NSString stringWithFormat:@"%@ played you in 21 Questions, play them back!", [UserInfo shortNameFromName:[UserInfo sharedUserInfo].name]];
    }
    
    // If this is the second turn of the game
    else if (moveNumber == 2)
    {
        // Iterate through both response arrays and compare similar answers
        // If answers are similar, responseCounter++
        for (int index = 0; index < [playerResponseArray count]; index++)
        {
            if ([[previousResponses objectAtIndex:index] isEqualToString:[playerResponseArray objectAtIndex:index]])
                responseCounter++;
        }
        
        // If the responseCounter is 15 or higher, it's a match
        if (responseCounter >= 15)
        {
            // Set the game state to ended
            _gameState = @"ended";
            
            // Log got a match
            [MGWU logEvent:@"got_a_match"];
        }
        
        // Else, it's not a match
        else
        {
            // Set to LOST, meaning no match
            _gameData[@"winner"] = _opponent;
            _gameState = @"ended";
            
            // Log not getting a match
            [MGWU logEvent:@"did_not_match"];
            
            // Set push message for second turn, and if matched
        }
        
        // Determine compatibility score
        
        // If opponent is the winner (no match), then remove it from all lists and sections
    }
    
    // Create move dictionary
    NSMutableDictionary *moveDict = _gameData;
    
    // Push message
    message = [NSString stringWithFormat:@"You've been matched with %@!", [UserInfo shortNameFromName:[UserInfo sharedUserInfo].name]];

    // Send move to server
    [MGWU move:moveDict withMoveNumber:moveNumber forGame:gameId withGameState:_gameState withGameData:_gameData againstPlayer:_opponent withPushNotificationMessage:message withCallback:@selector(gotGame:) onTarget:self];
}

- (void)gotGame:(NSMutableDictionary*)game
{
    // Get game
	_game = game;
    
	// Reload view based on received game
    [self reload];
}

#pragma mark - Helper Methods

- (void)initializeArrays
{
    // Intit content randomizers
    questionRandomizer = [[ContentRandomizer alloc] init];
    contentRandomizer1 = [[ContentRandomizer alloc] init];
    contentRandomizer2 = [[ContentRandomizer alloc] init];
    
    // Init questions and content arrays
    questionContent = [[NSMutableArray alloc] init];
    contentArray1 = [[NSMutableArray alloc] init];
    contentArray2 = [[NSMutableArray alloc] init];
    
    // Init response arrays
    firstPlayerResponses = [[NSMutableArray alloc] init];
    secondPlayerResponses = [[NSMutableArray alloc] init];
    previousResponses = [[NSMutableArray alloc] init];
}

- (void)goBack
{
    // Go back to main scene
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
    
    // Stopped Gameplay and went back
    [MGWU logEvent:@"stopped_gameplay"];
}

#pragma mark - Answer Handling

- (void)firstTile
{
    // Put "1" in responses array
    if (roundNumber == 0)
        [firstPlayerResponses addObject:@"1"];
    
    else
        [secondPlayerResponses addObject:@"1"];
        
    // Increment tilesSelected
    tilesSelected++;
    
    // Call Next Tile Method
    if (tilesSelected != maxTilesSelected)
        [self nextTileLabel];
    
    // Log first tile chosen
    [MGWU logEvent:@"first_answer_chosen"];
}

- (void)secondTile
{
    // Put "2" is responses array
    if (roundNumber == 0)
        [firstPlayerResponses addObject:@"2"];
    
    else
        [secondPlayerResponses addObject:@"2"];
    
    // Increment tilesSelected
    tilesSelected++;
    
    // Call Next Tile Method
    if (tilesSelected != maxTilesSelected)
        [self nextTileLabel];
    
    // Log second tile chosen
    [MGWU logEvent:@"second_answer_chosen"];
}

- (void)nextTileLabel
{
    // Go to next questiom strings
    _questionLabel.string = questionContent[tilesSelected];
    
    // Go to next content strings
    _tileLabel1.string = contentArray1[tilesSelected];
    _tileLabel2.string = contentArray2[tilesSelected];
}

@end
