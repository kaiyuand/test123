//
//  BookmarkTableViewController.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
@protocol bookmarkToWebViewDelegate <NSObject>
-(void)bookmark:(id)sender sendsObject:(Article *) artical;
@end

@interface BookmarkTableViewController : UITableViewController
@property (weak,nonatomic) id<bookmarkToWebViewDelegate> delegate;
- (IBAction)EditMode:(UIBarButtonItem *)sender;

@property (strong,nonatomic) NSMutableArray *NumNews;

@end
