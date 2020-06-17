//
//  User.m
//  twitter
//
//  Created by German Flores on 6/15/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageURLString = dictionary[@"profile_image_url_https"];
        self.bannerImageURLString = dictionary[@"profile_banner_url"];
        self.tweetsCount = dictionary[@"statuses_count"];
        self.followersCount = dictionary[@"friends_count"];
        self.followingCount = dictionary[@"followers_count"];
        
    }
    return self;
}


- (NSURL *)getProfileImageURLString {
    NSString *imageString = self.profileImageURLString;
    imageString = [imageString stringByReplacingOccurrencesOfString:@"normal.jpg" withString:@"bigger.jpg"];
    
    NSURL *imageURL = [NSURL URLWithString:imageString];
    return imageURL;
}

- (NSURL *)getBannerImageURLString {
    NSURL *bannerURL = [NSURL URLWithString: self.bannerImageURLString];
    return bannerURL;
}

@end
