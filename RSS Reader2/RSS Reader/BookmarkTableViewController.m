//
//  BookmarkTableViewController.m
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import "BookmarkTableViewController.h"
@interface BookmarkTableViewController ()

@end
@implementation BookmarkTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 100, 100);
    NSError * err = nil;
    NSURL *docs =[[NSFileManager new] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    NSURL *file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:file];
    self.NumNews = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (self.NumNews) {
        for (int i = 0; i < self.NumNews.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.NumNews.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article *selected = [self.NumNews objectAtIndex:indexPath.row];
    
    [self.delegate bookmark:self.NumNews[indexPath.row] sendsObject:selected];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
        
    Article *object = self.NumNews[indexPath.row];
        
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.content;
        
    return cell;
}
- (IBAction)EditMode:(UIBarButtonItem *)sender {
    if ([self.tableView isEditing]) {
        self.tableView.editing = NO;
        sender.title = @"Edit";
        
    }else {
        self.tableView.editing = YES;
        sender.title = @"Done";
    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.NumNews removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //update disc
        NSError * err = nil;
        NSURL *docs =[[NSFileManager new] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
        NSURL *file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
        NSData * article = [NSKeyedArchiver archivedDataWithRootObject:self.NumNews];
        [article writeToURL:file atomically:NO];
        
    }
}
@end
