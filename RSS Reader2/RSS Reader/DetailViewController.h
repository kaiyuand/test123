//
//  DetailViewController.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "BookmarkTableViewController.h"
#import "Article.h"
//#import "FLAnimatedImage.h"
//#import "FLAnimatedImageView.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController<bookmarkToWebViewDelegate,UIWebViewDelegate,UIPopoverPresentationControllerDelegate,loaddataDelegate>

@property (strong, nonatomic) Article * detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

//loading screen
@property (weak, nonatomic) IBOutlet UILabel *loadinglabel;
@property (weak, nonatomic) IBOutlet UIView *loadingview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingindicator;

//splashing screen
//@property (weak, nonatomic) IBOutlet FLAnimatedImageView *splashingView;

- (IBAction)AddToFavorite:(UIButton *)sender;
- (IBAction)tweetNews:(id)sender;

@property UIViewController *vc;
@end

