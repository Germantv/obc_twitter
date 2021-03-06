//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"dAcPLfIiaMe9VK1QYTCtGmZBr";
static NSString * const consumerSecret = @"v2FiGLyuuVVnjuQ3iPiojtuueIoTjn6j05o60F82hYJjADKfom";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

// MARK: getHomeTL
// Returns a collection of the most recent Tweets posted by the authenticating user and the users they follow.
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
     [self GET:@"1.1/statuses/home_timeline.json"
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSArray *tweetDictionaries = nil;
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
            completion(tweets, error);
        } else {
            completion(nil, error);
        }
    }];
}

// MARK: getIndicatedUserTL
// Returns a collection of the most recent Tweets posted by the indicated by the screen_name or user_id parameters.
- (void)getIndicatedUserTimelineWithCompletion:(void(^)(User *user, NSArray *tweets, NSError *error))completion {
    
     [self GET:@"1.1/statuses/user_timeline.json"
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"user_tweets"];
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(nil, tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSArray *tweetDictionaries = nil;
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
            completion(nil, tweets, error);
        } else {
            completion(nil, error, nil);
        }
    }];
}

// MARK: getMentionsTL
// Returns the 20 most recent mentions (Tweets containing a users’s @handle) for the authenticating user.
- (void)getMentionsTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
     [self GET:@"1.1/statuses/mentions_timeline.json"
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"mention_tweets"];
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSArray *tweetDictionaries = nil;
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"mention_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
            completion(tweets, error);
        } else {
            completion(nil, error);
        }
    }];
}

// MARK: postTweet
// Updates the authenticating user's current status, also known as Tweeting.
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


// MARK: Fav Tweet
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// MARK: unFav Tweet
- (void)unFavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr };
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// MARK: Retweet
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/retweet/";
    urlString = [urlString stringByAppendingString: tweet.idStr];
    urlString = [urlString stringByAppendingString:@".json"];
    
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// MARK: unRetweet
- (void)unRetweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/unretweet/";
    urlString = [urlString stringByAppendingString: tweet.idStr];
    urlString = [urlString stringByAppendingString:@".json"];
    
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
