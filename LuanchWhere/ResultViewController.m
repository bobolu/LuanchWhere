//
//  ResultViewController.m
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "RestaurantListViewController.h"
#import "Restaurant.h"
@implementation ResultViewController {
    BOOL _stop;
    
    NSMutableArray *_indexArray;
}

@synthesize resultLabel = _resultLabel;


- (void)loadView {
    self.view = self.resultLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _indexArray = [[NSMutableArray alloc] init];
    _stop = YES;
    
    NSArray *restaurants = [Restaurant objects];
    for (Restaurant *aRestaurant in restaurants) {
        int area = [aRestaurant.level intValue];
        while (area>0) {
            [_indexArray addObject:aRestaurant];
            area--;
        }
    }
    if (_indexArray.count == 0) {
        _resultLabel.text = @"Swipe Up To Add Restaurant";
    }else {
        _resultLabel.text = @"Tap To Begin";
    }
}
- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textAlignment = UITextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:24];
        _resultLabel.numberOfLines = 0;
        _resultLabel.text = @"Tap To Begin";
        _resultLabel.userInteractionEnabled = YES;
    
        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;

        [_resultLabel addGestureRecognizer:upSwipe];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_resultLabel addGestureRecognizer:tapGesture];
    }
    return _resultLabel;
}

- (void)swipeUp:(UISwipeGestureRecognizer *)sender {
    _stop = YES;
    
    RestaurantListViewController *listController = [[RestaurantListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
    
    [self presentModalViewController:navController animated:YES];
    
}

- (void)tap {
    if (_indexArray.count == 0) {
        return;
    }
    _stop = !_stop;
    if (_stop == NO) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^void(){
            while (_stop == NO) {
                int value = arc4random() % _indexArray.count;
                Restaurant *randedRest = [_indexArray objectAtIndex:value];
                dispatch_async(dispatch_get_main_queue(), ^void(){
                    _resultLabel.text = randedRest.name;
                });
                sleep(0.1);
            }
        });
        
        
    }
    
}
@end
