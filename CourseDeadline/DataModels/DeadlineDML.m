//
//  DeadlineDML.m
//  Assignment03
//
//  Created by Sheeyam Shellvacumar on 10/27/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import "DeadlineDML.h"
#import <CoreData/CoreData.h>
#import "Deadline+CoreDataProperties.h"
#include "AppDelegate.h"


@implementation DeadlineDML

+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.persistentContainer.viewContext;
}

+ (bool)addUpdateDataOperation:(NSString *)mode: (NSString *) courseName: (NSString *) courseNo: (NSString *) testName: (NSString *) semester: (NSDate *) dueDate
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deadline" inManagedObjectContext:context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Setup Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testname=%@", testName];
    [request setPredicate:predicate];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if([mode isEqualToString:@"edit"]) {
        if (!mutableFetchResults) {
            return false;
        } else {
            if([mutableFetchResults count] > 0) {
                Deadline *deadlineObj = [mutableFetchResults objectAtIndex:0];
                
                [deadlineObj setValue:courseName forKey:@"coursename"];
                [deadlineObj setValue:courseNo forKey:@"courseno"];
                [deadlineObj setValue:testName forKey:@"testname"];
                [deadlineObj setValue:semester forKey:@"semester"];
                [deadlineObj setValue:dueDate forKey:@"duedate"];
                
                NSError *error;
                if(![context save:&error]) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    } else {
        //Get managed object context
        Deadline* deadline = [NSEntityDescription insertNewObjectForEntityForName:@"Deadline" inManagedObjectContext:context];
        deadline.courseno = courseNo;
        deadline.coursename = courseName;
        deadline.semester = semester;
        deadline.testname = testName;
        deadline.duedate = dueDate;
        
        NSError *error;
        if(![context save:&error]) {
            return false;
        } else {
            return true;
        }
        return false;
    }
    return false;
}

+ (NSMutableArray *) fetchUpdateDeadline: (NSString*)coursename
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deadline" inManagedObjectContext:context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testname=%@", coursename];
    [request setPredicate:predicate];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    return mutableFetchResults;
}

+ (bool)deleteDeadlineOperation:(NSString *)str
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deadline" inManagedObjectContext:context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Setup Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testname=%@", str];
    [request setPredicate:predicate];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults.count > 0)
    {
        NSManagedObject *managedObject = [mutableFetchResults objectAtIndex:0];
        [context deleteObject:managedObject];
        if (![context save:&error])
        {
            return false;
        }
    }
    return true;
}

@end
