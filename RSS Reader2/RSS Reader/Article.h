//
//  Article.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject <NSCoding>
@property (strong,nonatomic) NSURL* url;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* content;
@property (strong,nonatomic) NSDate* date;
- (BOOL) isFavoriated;
@end
