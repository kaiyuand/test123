//
//  SharedNetworking.m
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

#pragma mark - Initialization

+ (id)sharedSharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared= nil;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark - Requests

- (void)getFeedForURL:(NSString*)url
            success:(void (^)(NSDictionary *dictionary, NSError *error)) successCompletion
            failure:(void (^)(void))failureCompletion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //Googlel api URL
    NSString *gURL=@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=20&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss";
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:gURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error){
                
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                if(httpResp.statusCode==200){
                    NSError *jsonError;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    //NSLog(@"DownloadeDate:%@",dictionary);
                    
                    // Call the block
                    successCompletion(dictionary,nil);
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }else{
                    NSLog(@"Fail Not 200:");
                    dispatch_async(dispatch_get_main_queue(), ^{
                    //Call the failure (if exists)
                        if(failureCompletion) failureCompletion();
                    });
                }
                
            }] resume];
}


@end
