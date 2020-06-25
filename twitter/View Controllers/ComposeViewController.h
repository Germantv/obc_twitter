//
//  ComposeViewController.h
//  twitter
//
//  Created by German Flores on 6/17/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: Protocol
@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

// MARK: Interface
@interface ComposeViewController : UIViewController
// MARK: Properties
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
