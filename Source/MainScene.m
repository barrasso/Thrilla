//
//  MainScene.m
//  Thrilla
//
//  Created by Mark on 07/02/14.
//

#import "MainScene.h"
#import "UserInfo.h"
#import "UserImage.h"
#import "PlayerCell.h"
#import "Gameplay1.h"

@implementation MainScene
{
    // Global Booleans
    BOOL isViewingMenu;
    
    // Table View
    CCNode *_tableViewContentNode;
    CCTableView *_tableView;
    
    // Tutorial Node
    CCNode *_tutorialNode;
    
    // Touch Location
    CGPoint touchLocation;
    
    // Cells
    NSMutableArray *_allCells;
}

#pragma mark - Lifecycle

- (void)dealloc
{
    // Remove table view delegate when this class is deallocated
    [_tableView setTarget:nil selector:nil];
}

- (void)didLoadFromCCB
{
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Set isVewingMenu
    isViewingMenu = NO;
    
    // Sets up the main table view
    [self setupTableView];
    
    // Create array that will hold all cells
    _allCells = [[NSMutableArray alloc] init];
    
    // Allow for swipes right if user is viewing the menu
    UISwipeGestureRecognizer *swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewSliderMenu)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
    // Listen for Swipes Left
    UISwipeGestureRecognizer *swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewMainScene)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    
    // Listen for Swipes Down
    UISwipeGestureRecognizer *swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    // Whenever MainScene becomes visible, reload data from server
    [[UserInfo sharedUserInfo] refreshWithCallback:@selector(loadedUserInfo:) onTarget:self];
}

- (void)update:(CCTime)delta
{
    // If there are no matches, toggle tutorial
    if ([_allCells count] == 0)
        _tutorialNode.visible = YES;
    else
        _tutorialNode.visible = NO;
}

#pragma mark - Helper Methods

- (void)setupTableView
{
    // Init table view
    _tableView = [[CCTableView alloc] init];
    
    // Add tableview to table view content node
	[_tableViewContentNode addChild:_tableView];
    
    // Set Content Size and type
	_tableView.contentSizeType = CCSizeTypeNormalized;
	_tableView.contentSize = CGSizeMake(1.f, 1.f);
    
    // Call table view cell selected
	[_tableView setTarget:self selector:@selector(tableViewCellSelected:)];
    
    // Set table view as the data source
    _tableView.dataSource = self;
}

- (void)loadedUserInfo:(NSDictionary *)userInfo
{
	_allCells = [NSMutableArray array];
	
	// Setup match section in the table view
    //[_allCells addObject:@"Matches"];
	[_allCells addObjectsFromArray:[UserInfo sharedUserInfo].successfulMatches];
	
	// After "_allCells" is set up entirely, call "reloadData" to update the table view with the latest information
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)receivedRandomGame:(NSMutableDictionary *)game
{
	// When given a random game, present Gameplay1 with this game
	CCScene *scene = [CCBReader loadAsScene:@"Gameplay1"];
	Gameplay1 *gameScene = scene.children[0];
	gameScene.game = game;
	[[CCDirector sharedDirector] pushScene:scene];
}

#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    touchLocation = [touch locationInNode:self];
}

- (void)swipeDown
{
    // Reload data from server
    [self reload];    
}

#pragma mark - Selector Methods

- (void)playNow
{
	if ([[[UserInfo sharedUserInfo] gamesYourTurn] count] > 0)
	{
        // Play games that are open first
		NSMutableDictionary *game = [[UserInfo sharedUserInfo] gamesYourTurn][0];
		
		CCScene *scene = [CCBReader loadAsScene:@"Gameplay1"];
		Gameplay1 *gameScene = scene.children[0];
		gameScene.game = game;
		[[CCDirector sharedDirector] pushScene:scene];
	}
    
    else
	{
		// Start a random match
		[MGWU getRandomGameWithCallback:@selector(receivedRandomGame:) onTarget:self];
	}
}

- (void)reload
{
	// Update data with newest from MGWU server
	[[UserInfo sharedUserInfo] refreshWithCallback:@selector(loadedUserInfo:) onTarget:self];
}

- (void)toggleSlider
{
    // If the user is not viewing the menu
    if (!isViewingMenu)
    {
        // View menu layer animation
        [self.animationManager runAnimationsForSequenceNamed:@"SlideInMenu"];
        isViewingMenu = YES;
    }
    
    // If the user is viewing the menu
    else if (isViewingMenu)
    {
        // View main scene animation
        [self.animationManager runAnimationsForSequenceNamed:@"SlideOutMenu"];
        isViewingMenu = NO;
    }
}

- (void)viewSliderMenu
{
    // If the user is not viewing the menu
    if (!isViewingMenu)
    {
        // View menu layer animation
        [self.animationManager runAnimationsForSequenceNamed:@"SlideInMenu"];
        isViewingMenu = YES;
    }
}

- (void)viewMainScene
{
    // If the user is viewing the menu
    if (isViewingMenu)
    {
        // View main scene animation
        [self.animationManager runAnimationsForSequenceNamed:@"SlideOutMenu"];
        isViewingMenu = NO;
    }
}

#pragma mark - CCTableViewDataSource Protocol

// This method is called automatically by the CCTableView to create cells
- (CCTableViewCell*)tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger)index
{
    CCTableViewCell *cell = [[CCTableViewCell alloc] init];
	
	id currentCell = _allCells[index];
	
	if ([currentCell isKindOfClass:[NSString class]])
    {
//		// Current cell is a section, create a "SectionCell" for it
//		SectionCell *cellContent = (SectionCell *)[CCBReader load:@"SectionCell"];
//		cellContent.sectionTitleLabel.string = currentCell;
//		[cell addChild:cellContent];
//		cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
//		cell.contentSize = CGSizeMake(1.f, 50.f);
	}
    
    else
    {
		// Current cell represents a match. Create a "PlayerCell"
		NSDictionary *currentGame = _allCells[index];
		PlayerCell *cellContent = (PlayerCell *)[CCBReader load:@"PlayerCell"];
		cellContent.nameLabel.string = [UserInfo shortNameFromName:currentGame[@"opponentName"]];
		cellContent.player = @{@"username":currentGame[@"opponent"]};
		[cell addChild:cellContent];
		cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
		cell.contentSize = CGSizeMake(1.f, 50.f);
	 }
	
	return cell;
}

// This method is called automatically by the CCTableView to create cells
- (float) tableView:(CCTableView*)tableView heightForRowAtIndex:(NSUInteger) index
{
	return 50;
}

// This method is called automatically by the CCTableView to create cells
- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView
{
	return [_allCells count];
}

// This method is called automatically by the CCTableView when cells are tapped
- (void)tableViewCellSelected:(CCTableViewCell*)sender
{
	NSInteger index = _tableView.selectedRow;
	
	id currentCell = _allCells[index];
    
	if ([currentCell isKindOfClass:[NSString class]])
    {
		// This is a section and we don't need user interaction
		return;
	}
    
    else
    {
		// If a game cell was tapped, pick the selected game from the '_allCells' array
//		NSMutableDictionary *selectedGame = _allCells[index];
//        
//		CCScene *scene = [CCBReader loadAsScene:@"Gameplay1"];
//		Gameplay1 *gameScene = scene.children[0];
//		gameScene.game = selectedGame;
//		[[CCDirector sharedDirector] pushScene:scene];
    }
}

@end
