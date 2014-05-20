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
-(BOOL)createDB;
-(BOOL)insertUserWithName:(NSString*) name Password:(NSString*) password;
-(BOOL)insertCategoryWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger)category_id CategoryName:(NSString*)category_name;
-(BOOL)removeCategoryWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger)category_id;
-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;
-(NSMutableArray*) getCategoryNamesWithUserID:(NSUInteger) user_id;
-(NSMutableArray*) getCategoryIDsWithUserID:(NSUInteger) user_id;
-(NSMutableArray*) getCategoryNameWithUserID:(NSUInteger) user_id CategoryName:(NSUInteger) category_id;
-(NSInteger) getMaxCategoryNumber;

@end
