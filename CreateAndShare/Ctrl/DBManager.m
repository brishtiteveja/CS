//
//  DBManager.m
//  CreateAndShare
//
//  Created by Abdullahkhan Zehady on 5/19/14.
//  Copyright (c) 2014 INKA Forschungsgruppe. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

@synthesize databaseName = databaseName_;

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    databaseName = @"createandsharedata.sqlite3";
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: databaseName]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        NSLog(@"Database Path = %@",databasePath);
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            
            //user table
            const char *sql_stmt =
            "create table if not exists user (id integer primary key, name text unique, password text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table user.");
            }
            
            //category table
            sql_stmt =
            "create table if not exists category (id integer primary key,user_id integer unique, category_id, category_name text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table category");
            }
            
            //page table
            sql_stmt =
            "create table if not exists page (id integer primary key,user_id integer unique, category_id integer, page_id integer unique, page_name text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table page");
            }
            
//            //pagecontents table
//            sql_stmt =
//            "create table if not exists pagecontents (page_id integer )";
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
//                != SQLITE_OK)
//            {
//                isSuccess = NO;
//                NSLog(@"Failed to create table page");
//            }
            
            
            sqlite3_close(database);
            NSLog(@"Database successfully created.");
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            sqlite3_close(database);
            NSLog(@"Failed to open/create database");
        }
    }else{
        sqlite3_close(database);
        NSLog(@"Database exists.");
    }
    
    return isSuccess;
}

-(NSInteger) getMaxCategoryNumber
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *maxSQL = [NSString stringWithFormat:@"select max(category_id) from category"];
        const char *max_stmt = [maxSQL UTF8String];
        sqlite3_prepare_v2(database, max_stmt, -1, &statement, NULL);
//        NSLog(@"%d",sqlite3_step(statement));
     

        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *maxs = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSLog(@"Max extraction succeeded.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return [maxs intValue];
        }
        else{
            NSLog(@"Max extraction failed.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }

        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)removeCategoryWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger)category_id{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from category where user_id=\"%d\" and category_id=\"%d\"", user_id,
                               category_id];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Deletion from category table succeeded.");
            sqlite3_close(database);
            return YES;
        }
        else {
            NSLog(@"Deletion from category table failed.");
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)insertCategoryWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger)category_id CategoryName:(NSString *)category_name{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into category (user_id, category_id, category_name) values (\"%d\",\"%d\",\"%@\")", user_id, category_id,
                               category_name];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Insertion to category table succeeded.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else {
            NSLog(@"Insertion to category table failed.");
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
       department:(NSString*)department year:(NSString*)year;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into \
                               studentsDetail (regno,name, department, year) values \
                               (\"%d\",\"%@\", \"%@\", \"%@\")",[registerNumber integerValue],
                                name, department, year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSMutableArray*) getCategoryNamesWithUserID:(NSUInteger) user_id
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select category_name from category where \
                              user_id=\"%d\"", user_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
//                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            
            sqlite3_close(database);
            return resultArray;
        }
        
        sqlite3_reset(statement);
    }
    return nil;
}

- (NSMutableArray*) getCategoryIDsWithUserID:(NSUInteger) user_id
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select category_id from category where \
                              user_id=\"%d\"", user_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                //                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            
            sqlite3_close(database);
            return resultArray;
        }
        
        sqlite3_reset(statement);
    }
    return nil;
}

//- (NSMutableArray*) getCategoryNameWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger) category_id
//{
//    const char *dbpath = [databasePath UTF8String];
//    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat:@"select category_name from category where \
//                              user_id=\"%d\" and category_id=\"%d\"", user_id, category_id];
//        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//        
//        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
//            if(sqlite3_step(statement) == SQLITE_ROW){
//                NSString *category_name = [[NSString alloc] initWithUTF8String:
//                                           (const char *) sqlite3_column_text(statement, 1)];
//                [resultArray addObject:category_name];
//                
//                return resultArray;
//            }
//            else{
//                NSLog(@"Database step error.");
//                return nil;
//            }
//        }else{
//            
//        }
//        
//        sqlite3_reset(statement);
//    }
//    return nil;
//}

- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
{
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:
                                      @"select name, department, year from studentsDetail where \
                                      regno=\"%@\"",registerNumber];
            const char *query_stmt = [querySQL UTF8String];
            NSMutableArray *resultArray = [[NSMutableArray alloc]init];
            if (sqlite3_prepare_v2(database,
                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *name = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                    [resultArray addObject:name];
                    NSString *department = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                    [resultArray addObject:department];
                    NSString *year = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
                    [resultArray addObject:year];
                    sqlite3_close(database);
                    return resultArray;
                }
                else{
                    NSLog(@"Not found");
                    sqlite3_close(database);
                    return nil;
                }
                sqlite3_reset(statement);
                }
            }
            return nil;
        }
@end