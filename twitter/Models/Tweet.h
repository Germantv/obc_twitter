//
//  Tweet.h
//  twitter
//
//  Created by German Flores on 6/15/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update favorite count label
@property (nonatomic) BOOL retweeted; // Configure retweet button
@property (nonatomic) int replyCount; // Update favorite count label
@property (nonatomic, strong) User *user; // Contains name, screenname, etc. of tweet author
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic) NSString *replyIDString;
@property (strong, nonatomic) NSArray *entities; // Display date
@property (strong, nonatomic) NSArray *media; // Display date

// For Retweets
@property (nonatomic, strong) User *retweetedByUser;  // user who retweeted if tweet is retweet

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// MARK: Methods
// Returns Tweets when initialized with an array of Tweet Dictionaries
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
