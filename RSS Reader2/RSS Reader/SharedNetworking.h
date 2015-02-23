//
//  SharedNetworking.h
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedNetworking : NSObject

+ (id)sharedSharedNetworking;

- (void)getFeedForURL:(NSString*)url
              success:(void (^)(NSDictionary *dictionary, NSError *error)) successCompletion
              failure:(void (^)(void))failureCompletion;

@end
