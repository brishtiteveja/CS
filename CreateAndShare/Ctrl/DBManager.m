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
            "create table if not exists category (id integer primary key,user_id integer, category_id integer unique, category_name text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table category");
            }
  
            //Inserting some initial categories.
            
            NSString *tmp = [NSString stringWithFormat:@"insert into category (user_id, category_id, category_name) values (\"%d\",\"%d\",\"%@\")", 1, 1, @"memories"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into table category");
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into category (user_id, category_id, category_name) values (\"%d\",\"%d\",\"%@\")", 1, 2, @"journal"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into table category");
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into category (user_id, category_id, category_name) values (\"%d\",\"%d\",\"%@\")", 1, 3, @"reading"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into table category");
            }else{
                NSLog(@"Successful insertion.");
            }
            
            
            
            
            //page table
            sql_stmt =
            "create table if not exists page (id integer primary key,user_id integer, category_id integer, page_id integer, page_name text, page_img_url text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table page");
            }else{
                NSLog(@"Page table successfully created.");
            }
            
            //inserting some initial pages
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 1, 1, @"cat"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 1);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            //inserting some initial pages
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 1, 2, @"dog"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 1);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 2, 1, @"rose"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 2);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 2, 2, @"belly"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 2);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 2, 3, @"sunflower"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 2);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 3, 1, @"dhaka"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 3);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 3, 2, @"rangpur"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 3);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 3, 3, @"rajshahi"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 3);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 4, 1, @"rice"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 4);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 4, 2, @"milk"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 4);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 4, 3, @"sweet"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 4);
            }else{
                NSLog(@"Successful insertion.");
            }
            
            tmp = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name) values (\"%d\",\"%d\",\"%d\",\"%@\")", 1, 4, 4, @"honey"];
            
            sql_stmt = [tmp cStringUsingEncoding:NSASCIIStringEncoding];
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to insert into page for category id = %d", 4);
            }else{
                NSLog(@"Successful insertion.");
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
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            NSLog(@"Database successfully created.");
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            sqlite3_finalize(statement);
            sqlite3_close(database);
            NSLog(@"Failed to open/create database");
        }
    }else{
        sqlite3_close(database);
        NSLog(@"Database exists.");
    }
    
    return isSuccess;
}

-(NSInteger) getMaxPageNumberWithCategoryID:(NSInteger)category_id{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *maxSQL = [NSString stringWithFormat:@"select max(page_id) from page where category_id=\"%d\"",category_id];
        const char *max_stmt = [maxSQL UTF8String];
        sqlite3_prepare_v2(database, max_stmt, -1, &statement, NULL);
        //        NSLog(@"%d",sqlite3_step(statement));
        
        
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *maxs = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSLog(@"Max page extraction for the category succeeded.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return [maxs intValue];
        }
        else{
            NSLog(@"Max page extraction for the category failed.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return 0;
        }
        
        sqlite3_reset(statement);
    }
    return 0;
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
            return 0;
        }

        sqlite3_reset(statement);
    }
    return 0;
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


-(BOOL)insertPageIntoCategoryWithUserID:(NSInteger)user_id CategoryID:(NSInteger)category_id PageID:(NSInteger)page_id PageName:(NSString *)page_name PageImageURL:(NSString *)page_img_url
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into page (user_id, category_id, page_id, page_name, page_img_url) values (\"%d\",\"%d\", \"%d\", \"%@\", \"%@\")", user_id, category_id, page_id, page_name, page_img_url];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Page insertion with category id: \"%d\" succeeded.", category_id);
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else {
            NSLog(@"Page insertion with category id: \"%d\" failed.", category_id);
            sqlite3_finalize(statement);
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

- (NSMutableArray *) getCategoryNamesWithUserID:(NSUInteger) user_id
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
            NSLog(@"Got category names.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
        }else{
            NSLog(@"Failed to get category names.");
        }
        
        sqlite3_reset(statement);
    }
    return nil;
}

-(NSMutableArray*) getCategoryNameWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger) category_id{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select category_name from category where \
                              user_id=\"%d\" and category_id=\"%d\"", user_id,category_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                //                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            NSLog(@"Got category name.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
        }else{
            NSLog(@"Failed to get category name.");
        }
        
        sqlite3_reset(statement);
    }
    return nil;
}

-(NSMutableArray*) getPageNameWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger) category_id PageID:(NSUInteger)page_id
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select page_name from page where \
                              user_id=\"%d\" and category_id=\"%d\" and page_id=\"%d\"", user_id, category_id, page_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                //                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            NSLog(@"Got page name.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
        }else{
            NSLog(@"Failed to get page name.");
        }
        
        sqlite3_reset(statement);
    }
    return nil;
    
}

- (NSMutableArray *)getPageNamesWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger) category_id
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select page_name from page where \
                              user_id=\"%d\" and category_id=\"%d\"", user_id,category_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                //                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            NSLog(@"Got page names.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
        }
        else{
            NSLog(@"Failed to get page names.");
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
            NSLog(@"Got category ids.");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return resultArray;
        }
        
        sqlite3_reset(statement);
    }
    return nil;
}

- (NSMutableArray*) getPageIDsWithUserID:(NSUInteger) user_id CategoryID:(NSUInteger) category_id
{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select page_id from page where \
                              user_id=\"%d\" and category_id=\"%d\"", user_id,category_id];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW){
                //                NSLog(@"%s", sqlite3_column_text(statement, 0));
                NSString *category_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:category_name];
            }
            sqlite3_finalize(statement);
            NSLog(@"Got page ids.");
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