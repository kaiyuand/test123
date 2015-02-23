//
//  MasterCell.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;

@end
