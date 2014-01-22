//
//  Restaurant.h
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Restaurant : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * level;

+ (Restaurant *)object;
+ (NSArray *)objects;

@end
