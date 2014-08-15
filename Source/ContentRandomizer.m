//
//  ContentRandomizer.m
//  datinggame
//
//  Created by Mark on 7/10/14.
//

#import "ContentRandomizer.h"

@implementation ContentRandomizer

- (NSMutableArray *)createContent1
{
    // Initialize Arrays
    self.lines1 = [[NSArray alloc] init];
    self.usedContent1 = [[NSMutableArray alloc] init];
    self.placeholderContent1 = [[NSMutableArray alloc] init];
    
    // Read in content.txt and separate strings by new line
    self.path1 = [[NSBundle mainBundle] pathForResource:@"firstStringContent" ofType:@"txt"];
    self.allContent1 = [NSString stringWithContentsOfFile:self.path1 encoding:NSUTF8StringEncoding error:NULL];
    self.lines1 = [self.allContent1 componentsSeparatedByString:@"\n"];
    
    // Create a copy of all the content
    self.placeholderContent1 = [self.lines1 mutableCopy];
    
    // Create usedContent array from random indexing (21 strings max)
    for (int i = 0; i < 21; i++)
    {
        // Set randomIndex value
        self.randomIndex1 = arc4random() % [self.placeholderContent1 count];
        
        // Add that current string to usedContent
        [self.usedContent1 addObject:self.placeholderContent1[self.randomIndex1]];
        
        // Then remove that string from placeholder content to prevent repeats
        [self.placeholderContent1 removeObjectAtIndex:self.randomIndex1];
    }
    
    return self.usedContent1;
}

- (NSMutableArray *)createContent2
{
    // Initialize Arrays
    self.lines2 = [[NSArray alloc] init];
    self.usedContent2 = [[NSMutableArray alloc] init];
    self.placeholderContent2 = [[NSMutableArray alloc] init];
    
    // Read in content.txt and separate strings by new line
    self.path2 = [[NSBundle mainBundle] pathForResource:@"secondStringContent" ofType:@"txt"];
    self.allContent2 = [NSString stringWithContentsOfFile:self.path2 encoding:NSUTF8StringEncoding error:NULL];
    self.lines2 = [self.allContent2 componentsSeparatedByString:@"\n"];
    
    // Create a copy of all the content
    self.placeholderContent2 = [self.lines2 mutableCopy];
    
    // Create usedContent array from random indexing (21 strings max)
    for (int i = 0; i < 21; i++)
    {
        // Set randomIndex value
        self.randomIndex2 = arc4random() % [self.placeholderContent2 count];
        
        // Add that current string to usedContent
        [self.usedContent2 addObject:self.placeholderContent2[self.randomIndex2]];
        
        // Then remove that string from placeholder content to prevent repeats
        [self.placeholderContent2 removeObjectAtIndex:self.randomIndex2];
    }
    
    return self.usedContent2;
}

- (NSMutableArray *)createQuestions
{
    // Initialize Arrays
    self.lines3 = [[NSArray alloc] init];
    self.usedContent3 = [[NSMutableArray alloc] init];
    self.placeholderContent3 = [[NSMutableArray alloc] init];
    
    // Read in content.txt and separate strings by new line
    self.path3 = [[NSBundle mainBundle] pathForResource:@"neverContent" ofType:@"txt"];
    self.allContent3 = [NSString stringWithContentsOfFile:self.path3 encoding:NSUTF8StringEncoding error:NULL];
    self.lines3 = [self.allContent3 componentsSeparatedByString:@"\n"];
    
    // Create a copy of all the content
    self.placeholderContent3 = [self.lines3 mutableCopy];
    
    // Create usedContent array from random indexing (21 strings max)
    for (int i = 0; i < 21; i++)
    {
        // Set randomIndex value
        self.randomIndex3 = arc4random() % [self.placeholderContent3 count];
        
        // Add that current string to usedContent
        [self.usedContent3 addObject:self.placeholderContent3[self.randomIndex3]];
        
        // Then remove that string from placeholder content to prevent repeats
        [self.placeholderContent3 removeObjectAtIndex:self.randomIndex3];
    }
    
    return self.usedContent3;
}

@end
