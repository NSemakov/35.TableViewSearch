//
//  Student.h
//  8. NSDictionary
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVStudent : NSObject
@property (strong,nonatomic) NSString* firstname;
@property (strong,nonatomic) NSString* lastname;
@property (strong,nonatomic) NSDate * dateOfBirth;
@property (assign,nonatomic) NSInteger monthOfBirth;
@property (assign,nonatomic) NSRange rangeInFirstname;
@property (assign,nonatomic) NSRange rangeInLastname;
- (instancetype)initWithProperties;
@end
