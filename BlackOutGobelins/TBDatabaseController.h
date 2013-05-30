//
//  TBDataBaseController.h
//  BlackOutGobelins
//
//  Created by tony's computer on 19/04/13.
//
//

#import <Foundation/Foundation.h>

@interface TBDatabaseController : NSObject

- (void)createTable:(NSString *)tableName andParams:(NSString *)params;
- (NSMutableArray *)getRow:(NSString *)rowName fromTable:(NSString *)tableName;
- (NSMutableArray *) getRowsfromTable:(NSString *)tableName;
- (void)insertIntoTable:(NSString *)tableName theseRowsAndValues:(NSDictionary *)rowsAndValues;
- (void)deleteFromTable:(NSString *)tableName withTheseConditions:(NSString *)conditions;
- (void)dropTable:(NSString *)tableName;

@end
