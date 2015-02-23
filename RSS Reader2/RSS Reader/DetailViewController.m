//
//  DetailViewController.m
//  RSS Reader
//
//  Created by kaiyuan duan on 15/2/21.
//  Copyright (c) 2015年 UChicago. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}
/*
func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
    // Return no adaptive presentation style, use default presentation behaviour
    return .None
}
*/
- (void)configureView {
    // Update the user interface
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [self.loadingview setHidden:YES];
    NSError * err = nil;
    NSURL *docs =[[NSFileManager new] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    NSURL *file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:file];
    NSArray * tempArray = (NSArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [[self.view viewWithTag:11] setHidden:YES];
    if (self.detailItem) {
        NSURL *url = self.detailItem.url;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.detailWebView loadRequest:request];
        for (Article * art in tempArray) {
            if ([self.detailItem.title isEqualToString:art.title]) {
                //NSLog(@"Flag converted!");
                [[self.view viewWithTag:11] setHidden:NO];
            }
        }

        NSData *lastViewedData = [NSKeyedArchiver archivedDataWithRootObject:self.detailItem];
        [defaults setObject:lastViewedData forKey:@"lastViewedArticle"];
        
    }
    else{
        NSData *data = [defaults objectForKey:@"lastViewedArticle"];
        Article * lastArticle=(Article *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSURL *url = lastArticle.url;
        NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url];
        [self.detailWebView loadRequest:request];
        for (Article * art in tempArray) {
            if ([lastArticle.title isEqualToString:art.title]) {
                //NSLog(@"Flag converted!");
                [[self.view viewWithTag:11] setHidden:NO];
            }
        }
    }
}

//splash screen

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view sendSubviewToBack:self.detailWebView];
    self.loadingindicator.color = [UIColor grayColor];
    self.loadinglabel.textColor = [UIColor grayColor];
    //[self.view bringSubviewToFront:self.loadingview];
    //[self.loadingindicator setHidden:NO];
    /*
    FLAnimatedImage *loadImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]]];
    self.splashingView.animatedImage = loadImage;
    self.splashingView.center = self.detailWebView.center;
    [self.view addSubview:self.splashingView];
    
    */
    _vc = [[UIViewController alloc] init];
    _vc.view.backgroundColor = [UIColor blackColor];
    [self presentViewController:_vc animated:NO completion:^{
        NSLog(@"Splash screen is showing");
    }];

    
    [self configureView];
    [self.detailWebView setDelegate:self];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
   // self.splashingView.hidden = YES;
    self.loadingview.center=webView.center;
    [self.loadingview setHidden:NO];
    [self.loadingindicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingindicator stopAnimating];
    [self.loadingview setHidden:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"Failed to load with error :%@",[error debugDescription]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bookmark:(id)sender sendsObject:(Article *)artical{
    self.detailItem =artical;
    [self configureView];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
        UINavigationController *controller = (UINavigationController*)segue.destinationViewController;
        //BookmarkTableViewController *bookMarkController = (BookmarkTableViewController*)controller.topViewController;
        BookmarkTableViewController *bookMarkController = controller.viewControllers.firstObject;

        UIPopoverPresentationController *popPC = controller.popoverPresentationController;
        
        bookMarkController.delegate = self;
        popPC.delegate = self;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)removeSplash: (id)sender sendsObject: (BOOL)isfinish{
    if (isfinish) {
        [self.vc dismissViewControllerAnimated:NO completion:Nil];
        [self.vc removeFromParentViewController];
        //self.splashingView.hidden = YES;
        //[self.splashingView removeFromSuperview];
        NSLog(@"remove splash");
    }
}

- (IBAction)AddToFavorite:(id)sender{
    NSError * err = nil;
    NSURL *docs =[[NSFileManager new] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    NSURL *file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:file];
    NSArray * articleArray = (NSArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray * tempArray = nil;
    if (articleArray) {
        tempArray = [[NSMutableArray alloc] initWithArray:articleArray];
    } else {
        tempArray = [[NSMutableArray alloc] init];
    }
    
    BOOL favorited = false;
    //NSLog(@"detail: %@",self.detailItem.title);
    for (Article * art in tempArray) {
        //NSLog(@"%@",art.title);
        
        if ([self.detailItem.title isEqualToString:art.title]) {
            //NSLog(@"Flag converted!");
            favorited=true;
        }
    }
    //NSLog(@"Flag not converted!");
    
    //NSLog(@"file is saved: %@",file);
    if (self.detailItem && (favorited==false)) {
        [tempArray addObject:self.detailItem];
        NSData * article = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
        [article writeToURL:file atomically:NO];
        [[self.view viewWithTag:11] setHidden:NO];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error to Add"
                              message:@"You have already added this site!"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)tweetNews:(id)sender {
    if (self.detailItem) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[[NSString alloc] initWithFormat:@"%@, Detail, %@",self.detailItem.title,self.detailItem.url]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else{
            UIAlertView *tweetAlert= [[UIAlertView alloc] initWithTitle:@"Error With Twitter" message:@"You need to log in to your Twitter first!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [tweetAlert show];
        }
    }
}

@end
