//
//  ContentRandomizer.h
//  datinggame
//
//  Created by Mark on 7/10/14.
//

#import <Foundation/Foundation.h>

@interface ContentRandomizer : NSObject

// Holds all content strings on separate lines
@property (strong, nonatomic) NSArray *lines1;
@property (strong, nonatomic) NSArray *lines2;
@property (strong, nonatomic) NSArray *lines3;

// Placeholder array to prevent duplicates
@property (strong, nonatomic) NSMutableArray *placeholderContent1;
@property (strong, nonatomic) NSMutableArray *placeholderContent2;
@property (strong, nonatomic) NSMutableArray *placeholderContent3;

// Content array that is used in the game
@property (strong, nonatomic) NSMutableArray *usedContent1;
@property (strong, nonatomic) NSMutableArray *usedContent2;
@property (strong, nonatomic) NSMutableArray *usedContent3;

// Holds path to gameplay content file
@property (strong, nonatomic) NSString *path1;
@property (strong, nonatomic) NSString *path2;
@property (strong, nonatomic) NSString *path3;

// Holds all the gameplay content
@property (strong, nonatomic) NSString *allContent1;
@property (strong, nonatomic) NSString *allContent2;
@property (strong, nonatomic) NSString *allContent3;

// Index into placeholder array to get random strings
@property (assign) int randomIndex1;
@property (assign) int randomIndex2;
@property (assign) int randomIndex3;

// Creates game content array
- (NSMutableArray *)createQuestions;
- (NSMutableArray *)createContent1;
- (NSMutableArray *)createContent2;

@end
