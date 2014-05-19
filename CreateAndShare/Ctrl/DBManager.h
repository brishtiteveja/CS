//
//  DBManager.h
//  CreateAndShare
//
//  Created by Abdullahkhan Zehady on 5/19/14.
//  Copyright (c) 2014 INKA Forschungsgruppe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databaseName;
    NSString *databasePath;
}

@property (nonatomic,retain) NSString* databaseName;

+(DBManager*)getSharedInstance;
-(BOOL)connectToDB;
-(BOOL)insertUserWithName:(NSString*) name Password:(NSString*) password;
-(BOOL)insertCategoryWithUserID:(NSUInteger) userID CategoryName:(NSString*)categoryName;
-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;

@end
