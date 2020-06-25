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
    
    // configure default and selected states if favorited or retweeted
    if(self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self.favoriteButton setSelected:YES];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self.favoriteButton setSelected:NO];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        //[self.retweetButton setSelected:YES];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self.retweetButton setSelected:NO];
    }
    
}

// MARK: IBActions
- (IBAction)didTapFavorite:(id)sender {
    // if tweet was NOT favorited
    if(!self.tweet.favorited) {
        // set favorited from false to true
        self.tweet.favorited = YES;
        // increase favorite count and update label to new count
        self.tweet.favoriteCount += 1;
        self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        // update image to indicate tweet was favorited
        [sender setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        
        // update api with updated tweet data
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet = tweet;
            }
        }];
    } else {
        // unfavoriting the tweet
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        
        [sender setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet = tweet;
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // unretweet
    if(self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        
        [sender setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unretweeted tweet: %@", self.tweet.text);
            }
        }];
    } else {
        // retweet
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        
        [sender setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else {
                 NSLog(@"Successfully retweeted tweet: %@", self.tweet.text);
            }
        }];
    }
}


@end
