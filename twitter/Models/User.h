//
//  User.h
//  twitter
//
//  Created by German Flores on 6/15/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageURLString;
@property (nonatomic, strong) NSString *bannerImageURLString;
@property (nonatomic, strong) NSString *tweetsCount;
@property (nonatomic, strong) NSString *followingCount;
@property (nonatomic, strong) NSString *followersCount;

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// MARK: Methods
- (NSURL *)getProfileImageURLString;
- (NSURL *)getBannerImageURLString;

@end

NS_ASSUME_NONNULL_END
