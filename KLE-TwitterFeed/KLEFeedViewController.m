//
//  KLEFeedViewController.m
//  KLE-TwitterFeed
//
//  Created by Kelvin Lee on 10/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "STTwitter.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "KLEFeedCell.h"
#import "KLEFeedViewController.h"

@interface KLEFeedViewController ()

@property (nonatomic, strong) NSMutableArray *twitterFeed;

@property (nonatomic, strong) KLEFeedCell *customCell;

@end

@implementation KLEFeedViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"TENDIGI Twitter Feed";
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_twitterFeed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create an instance of UITableViewCell, with default appearance
    KLEFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KLEFeedCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    
    NSDictionary *tweets = _twitterFeed[index];
    
    cell.tweetTextLabel.text = tweets[@"text"];
    
    NSLog(@"%@", [tweets allKeys]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // phantom cell for calculating cell height
    
    if (!_customCell) {
        _customCell = [tableView dequeueReusableCellWithIdentifier:@"KLEFeedCell"];
    }
    
    // configure the cell
    NSInteger index = indexPath.row;
    
    NSDictionary *tweets = _twitterFeed[index];
    
    _customCell.tweetTextLabel.text = tweets[@"text"];
    
    // layout the cell
    [_customCell layoutIfNeeded];
    
    // get the height for cell
    CGFloat height = [_customCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

- (void)getFeed
{
    // access twitter API
    STTwitterAPI *twitterKey = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"Fd23cwtGmtb8qbSo1vTDlxth1" consumerSecret:@"iZQIgzctPFAYTriUnPizzzaUjIM1tpvikeU8hLOpGrQPW8EbWh"];
    
    [twitterKey verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [twitterKey getUserTimelineWithScreenName:@"TENDIGI" successBlock:^(NSArray *statuses) {
            // add twitter feed to array and reload the table
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.debugDescription);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the nib file
    UINib *nib = [UINib nibWithNibName:@"KLEFeedCell" bundle:nil];
    
    // register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KLEFeedCell"];
    
    // access twitter API
    STTwitterAPI *twitterKey = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"Fd23cwtGmtb8qbSo1vTDlxth1" consumerSecret:@"iZQIgzctPFAYTriUnPizzzaUjIM1tpvikeU8hLOpGrQPW8EbWh"];
    
    [twitterKey verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [twitterKey getUserTimelineWithScreenName:@"TENDIGI" successBlock:^(NSArray *statuses) {
            //
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.debugDescription);
    }];
    
}

@end
