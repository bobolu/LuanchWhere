//
//  RestaurantListViewController.m
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "Restaurant.h"
#import "RestaurantEditViewController.h"

@implementation RestaurantListViewController

@synthesize items = _items;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self action:@selector(done)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self action:@selector(add)];
}
- (void)viewWillAppear:(BOOL)animated {
    self.items = nil;
    [self items];
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
                                       
- (void)add {
    RestaurantEditViewController *controller = [[RestaurantEditViewController alloc] initWithRestaurant:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)done {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSMutableArray *)items {
    if (_items == nil) {
        
        NSArray *restaurants = [Restaurant objects];
        _items = [[NSMutableArray alloc] initWithArray:restaurants];
        
    }
    return _items;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Restaurant *item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item.level stringValue];
    return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Restaurant *item = [_items objectAtIndex:indexPath.row];
    RestaurantEditViewController *controller = [[RestaurantEditViewController alloc] initWithRestaurant:item];
    [self.navigationController pushViewController:controller animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
@end
