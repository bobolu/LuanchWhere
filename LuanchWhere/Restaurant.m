//
//  Restaurant.m
//  LuanchWhere
//
//  Created by 李 帅 on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Restaurant.h"
#import "AppDelegate.h"

@implementation Restaurant

@dynamic name;
@dynamic level;

+ (Restaurant *)object {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    Restaurant *object = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:delegate.managedObjectContext];
    return object;
}

+ (NSArray *)objects {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    NSFetchRequest *reqest = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:reqest error:nil];
    return objects;
}
@end
