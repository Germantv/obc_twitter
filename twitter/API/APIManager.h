//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)getIndicatedUserTimelineWithCompletion:(void(^)(User *user, NSArray *tweets, NSError *error))completion;
- (void)getMentionsTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

@end
