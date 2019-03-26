//
//  DeadlineDML.h
//  Assignment03
//
//  Created by Sheeyam Shellvacumar on 10/27/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeadlineDML : NSObject
+ (bool)deleteDeadlineOperation:(NSString *)str;
+ (bool)addUpdateDataOperation:(NSString *)mode: (NSString *) courseName: (NSString *) courseNo: (NSString *) testName: (NSString *) semester: (NSDate *) dueDate;
+ (NSMutableArray *) fetchUpdateDeadline: (NSString*)coursename;

@end
