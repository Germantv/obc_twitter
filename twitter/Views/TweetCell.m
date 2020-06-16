//
//  TweetCell.m
//  twitter
//
//  Created by German Flores on 6/16/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
}

@end
