//
//  AppDelegate.h
//  Assignment03
//
//  Created by Atlink on 10/25/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

