//
//  NVSection.m
//  35. TableViewSearch
//
//  Created by Admin on 17.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVSection.h"

@implementation NVSection
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.students=[[NSMutableArray alloc]init];
    }
    return self;
}
@end
