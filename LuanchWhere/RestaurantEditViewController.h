//
//  RestaurantEditViewController.h
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
@interface RestaurantEditViewController : UIViewController {
    UITextView *_nameView;
    UITextField *_levelField;
    
    Restaurant *_restaurant;
}
@property (nonatomic,strong)UITextView *nameView;;
@property (nonatomic,strong)UITextField *levelField;

- (id)initWithRestaurant:(Restaurant *)restaurant;
                        
@end
