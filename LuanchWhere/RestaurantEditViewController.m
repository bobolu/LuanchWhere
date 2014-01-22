//
//  RestaurantEditViewController.m
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RestaurantEditViewController.h"
#import "AppDelegate.h"
@implementation RestaurantEditViewController

@synthesize nameView = _nameView;
@synthesize levelField = _levelField;

- (id)initWithRestaurant:(Restaurant *)restaurant {
    self = [super init];
    if (self) {
        _restaurant = restaurant;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                            target:self action:@selector(save)];
    if (_restaurant) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                                target:self action:@selector(delete)];
    }    
    
    self.nameView.frame = CGRectMake(5, 5, 310, 80);
    self.nameView.text = _restaurant.name;
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 310, 18)];
    promptLabel.text = @"评分（1-5）";
    promptLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:promptLabel];
    
    self.levelField.frame = CGRectMake(5, 120, 310, 40);
    self.levelField.text = [_restaurant.level stringValue];
}

- (void)delete {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.managedObjectContext deleteObject:_restaurant];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save {
    if (!([_levelField.text intValue]>0 && [_levelField.text intValue]<6)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评分不符合要求" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_restaurant == nil) {
        _restaurant = [Restaurant object];
    }
    _restaurant.name = _nameView.text;
    _restaurant.level = [NSNumber numberWithInt:[_levelField.text intValue]];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextView *)nameView {
    if (_nameView == nil) {
        _nameView = [[UITextView alloc] init];
        _nameView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_nameView];
    }
    return _nameView;
}

- (UITextField *)levelField {
    if (_levelField == nil) {
        _levelField = [[UITextField alloc] init];
        _levelField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:_levelField];
    }
    return _levelField;
}
@end
