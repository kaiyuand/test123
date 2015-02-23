//
//  MasterViewController.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loaddataDelegate <NSObject>

-(void)removeSplash: (id)sender sendsObject: (BOOL)isfinish;

@end

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UINavigationItem *HelloUser;


@property (weak,nonatomic) id<loaddataDelegate> delegate;

@end

