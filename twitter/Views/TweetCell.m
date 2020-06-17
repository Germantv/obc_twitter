//
//  TweetCell.m
//  twitter
//
//  Created by German Flores on 6/16/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if(self.tweet.replyCount == 0) {
        self.replyCount.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK: Methods
// setter method
- (void)setData:(Tweet *)tweet {
    self.tweet = tweet;
    
    // Set properties for tweet
    self.username.text = tweet.user.name;
    self.handle.text = tweet.user.screenName;
    self.createdAt.text = tweet.createdAtString;
    self.tweetText.text = tweet.text;
    
    // setup favs, rt's, & replies counts
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    self.replyCount.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    
    // configure image with AFNetworking method and custom User getter method
    [self.profileImage setImageWithURL: [tweet.user getProfileImageURLString]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.userInteractionEnabled = YES;
    
}

@end
