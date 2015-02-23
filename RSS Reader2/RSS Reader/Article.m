//
//  Article.m
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import "Article.h"

@implementation Article
- (void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"detail"];
    [encoder encodeObject:self.url forKey:@"articleURL"];
    [encoder encodeObject:self.date forKey:@"dateCreated"];
}
- (id) initWithCoder:(NSCoder *) decoder{
    self=[super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.content = [decoder decodeObjectForKey:@"detail"];
    self.url = [decoder decodeObjectForKey:@"articleURL"];
    self.date = [decoder decodeObjectForKey:@"dateCreated"];
    return self;
}

- (BOOL) isFavoriated{
    return true;
}


@end
