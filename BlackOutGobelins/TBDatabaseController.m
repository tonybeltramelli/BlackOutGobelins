//
//  TBDataBaseController.m
//  BlackOutGobelins
//
//  Created by tony's computer on 19/04/13.
//
//

#import "TBDatabaseController.h"
#import "/usr/include/sqlite3.h"

@implementation TBDatabaseController
{
    sqlite3 *_database;
    NSString *_databasePath;
    sqlite3_stmt *_statement;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [allPaths objectAtIndex:0];
        
        _databasePath = [[NSString alloc] initWithString: [path stringByAppendingPathComponent: @"data.db"]];
    }
    return self;
}

-(BOOL) isDatabaseAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: _databasePath] == NO)
    {
		return [self openDatabase];
        
        NSLog(@"database create");
        return TRUE;
    }else{
        return [self openDatabase];
        
        NSLog(@"database already exist");
        return TRUE;
    }
}

-(BOOL) openDatabase
{
    const char *dbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &_database) == SQLITE_OK)
    {
        return TRUE;
    } else {
        NSLog(@"Failed to open/create database");
        return FALSE;
    }
}

- (void) createTable:(NSString *)tableName andParams:(NSString *)params
{
    NSString *request = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@)", tableName, params];
    
    if ([self isDatabaseAvailable])
    {
        char *errMsg;
        
        if (sqlite3_exec(_database, [request UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create table");
        }
            
        sqlite3_close(_database);
    }
}

- (NSMutableArray *) getRow:(NSString *)rowName fromTable:(NSString *)tableName
{
    NSString *request = [NSString stringWithFormat:@"SELECT %@ FROM %@", rowName, tableName];
    NSMutableArray *_data = [[NSMutableArray alloc] init];
    
    if ([self isDatabaseAvailable])
    {
        if (sqlite3_prepare_v2(_database, [request UTF8String], -1, &_statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(_statement) == SQLITE_ROW)
            {
                NSString *rowValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(_statement, 0)];
                [_data addObject:rowValue];
            }
            sqlite3_finalize(_statement);
        }
        sqlite3_close(_database);
    }
    
    return _data;
}

- (void) insertIntoTable:(NSString *)tableName theseRowsAndValues:(NSDictionary *)rowsAndValues
{
    NSString *rows = @"";
    NSString *values = @"";
    
    int i = 0;
    int length = [rowsAndValues count];
    
    for(NSString* key in rowsAndValues)
    {
        i++;
        
        NSString *endLine = (i == length) ? @"" : @", ";
        
        rows = [rows stringByAppendingString:[NSString stringWithFormat:@"%@%@", key, endLine]];
        values = [values stringByAppendingString:[NSString stringWithFormat:@"\"%@\"%@", [rowsAndValues objectForKey:key], endLine]];
    }
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO %@(%@) VALUES(%@)", tableName, rows, values];
    
    [self executeQuery:insertSQL];
}

- (void) deleteFromTable:(NSString *)tableName withTheseConditions:(NSString *)conditions
{
    NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@", tableName, conditions];
    
    [self executeQuery:deleteSQL];
}

- (void) executeQuery:(NSString *)query
{
    const char *dbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &_database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &_statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(_statement) == SQLITE_DONE)
            {
                NSLog(@"query executed with success");
            }
        }
        
        sqlite3_finalize(_statement);
        sqlite3_close(_database);
    }
}

- (void) dropTable:(NSString *)tableName
{
    NSString *request = [NSString stringWithFormat: @"DROP TABLE IF EXISTS %@", tableName];
    
    if ([self isDatabaseAvailable])
    {
        char *errMsg;
        
        if (sqlite3_exec(_database, [request UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to drop table");
        }
        
        sqlite3_close(_database);
    }
}

@end
