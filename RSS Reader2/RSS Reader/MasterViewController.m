//
//  MasterViewController.m
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"
#import "MasterCell.h"
#import "Article.h"

@interface MasterViewController ()
@property (strong,nonatomic) NSDictionary *links;
@property (strong,nonatomic) NSMutableArray *objects;
@property BOOL index;
@property float cellalpha;
@property NSString* username;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingsinitial];
    [self download];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.delegate = self.detailViewController;
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=140;
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor magentaColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBundle) name:NSUserDefaultsDidChangeNotification object:nil];
    
    
    
}

- (void) settingsinitial{
    //initial reading mode
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH.mm"];
    NSString *currenttime = [dateFormatter stringFromDate:[NSDate date]];
    if ([currenttime floatValue] >= 18.00 || [currenttime floatValue]  <= 6.00){
        [defaults setBool:TRUE forKey:@"readingmode"];
    }else{
        [defaults setBool:FALSE forKey:@"readingmode"];
    }
    //initial username and alpha
    //self.username = @"Guest";
    //self.cellalpha = 10;
    [self.tableView reloadData];
    
}

- (void) download{
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //self.delegate = self.detailViewController;
    [[SharedNetworking sharedSharedNetworking] getFeedForURL:nil
                                                     success:^(NSDictionary *dictionary, NSError *error){
                                                         self.links = dictionary[@"responseData"][@"feed"][@"entries"];
                                                         NSLog(@"Network Connected Successful!");
                                                         [self.objects removeAllObjects];
                                                         for (NSDictionary *link in self.links){
                                                             //NSLog(@"Title: %@",link[@"title"]);
                                                             Article * article = [[Article alloc] init];
                                                             article.url = [[NSURL alloc] initWithString:link[@"link"]];
                                                             article.title = link[@"title"];
                                                             article.content = link[@"contentSnippet"];
                                                             article.date = link[@"publishedDate"];
                                                             //[self.delegate  removeSplash:self sendObject:true];
                                                             [self insertNewObject:article];
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             [self.tableView reloadData];
                                                             [self.delegate  removeSplash:self sendsObject:true];
                                                             if(self.refreshControl.refreshing){
                                                                 [self.refreshControl endRefreshing];
                                                             }
                                                         });
                                                     } failure:^{
                                                         UIAlertView *failAlert=[[UIAlertView alloc] initWithTitle:@"Network Connection failed" message:@"Connection to Network failed" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                                                         [failAlert show];
                                                         if(self.refreshControl.refreshing){
                                                             [self.refreshControl endRefreshing];
                                                         }
                                                     }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateBundle{
    [self.tableView reloadData];
}
- (void) updateSize{
    [self.tableView reloadData];
}
- (void) viewWillAppear:(BOOL)animated {
    //self.tableView.rowHeight=UITableViewAutomaticDimension;
    //[self download];
}
- (void)refreshAction {
    [self download];
    
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects addObject:sender];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Article *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.delegate = controller;
        //[self.delegate  removeSplash:self sendsObject:true];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    self.index = [defaults boolForKey:@"readingmode"];
    self.cellalpha = [defaults integerForKey:@"levelState"];
    NSString *username = [defaults stringForKey:@"username"];
    self.HelloUser.title = username;
    
    //NSLog(@"122=%d",self.index);
    //NSLog(@"123=%ld",(long)self.cellalpha);
    //NSLog(@"124=%@",self.username);
    MasterCell * cell = (MasterCell*)[tableView dequeueReusableCellWithIdentifier:@"MasterCell" forIndexPath:indexPath];
    
    
    Article *article2 = self.objects[indexPath.row];
    cell.cellTitle.text = article2.title;
    cell.cellTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.cellContent.text = article2.content;
    cell.cellContent.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [dateFormat dateFromString:(NSString *)article2.date];
    [dateFormat setDateFormat:@"yyyy-mm-dd"];
    cell.cellDate.text = [dateFormat stringFromDate:date];
    cell.cellDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

    if (self.cellalpha>1&&self.cellalpha<10) {
        cell.cellTitle.alpha = self.cellalpha/10;
        cell.cellContent.alpha = self.cellalpha/10;
        cell.cellDate.alpha = self.cellalpha/10;
    }
    
    [cell layoutIfNeeded]; //Force Cell to redraw itself
    
    
    
    if (self.index) {
        
        self.view.backgroundColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor blackColor];
        cell.cellTitle.textColor = [UIColor whiteColor];
        cell.cellContent.textColor =[UIColor whiteColor];
        cell.cellDate.textColor = [UIColor whiteColor];
        
    }
    else{
        
        self.view.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.cellContent.textColor = [UIColor blackColor];
        cell.cellDate.textColor =[UIColor lightGrayColor];
        cell.cellTitle.textColor = [UIColor blackColor];
    }
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
