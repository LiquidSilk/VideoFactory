//
//  CTPersistanceTable+Delete.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"

@interface CTPersistanceTable (Delete)

/**
 *  delete a record.
 *
 *  @param record the record you want to delete
 *  @param error  the error if delete fails
 */
- (void)deleteRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;

/**
 *  delete a list of record
 *
 *  @param recordList the record list you want to delete
 *  @param error      the error if delete fails
 */
- (void)deleteRecordList:(NSArray <NSObject<CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  delete with condition. The "where condition" is a string which will be used in SQL WHERE clause. Can bind params if you have words start with colon.
 *
 *  Example for whereCondition and conditionParams:
 *
 *      NSString *whereCondition = @"hello = :something"; // the key in string must start wich colon
 *
 *      NSDictionary *conditionParams = @{
 *
 *          @"something":@"world"
 *
 *      };// the where string will be "hello = world"
 *
 *  @param whereCondition  the string for WHERE clause
 *  @param conditionParams the params to bind in to where condition
 *  @param error           the error if delete fails
 */
- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;

/**
 *  delete with parimary key
 *
 *  @param primaryKeyValue the primary key of record to be deleted
 *  @param error           the error if delete fails
 */
- (void)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  delete a list record by primary key list.
 *
 *  @param primaryKeyValueList the primary key list
 *  @param error               the error if delete fails
 */
- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

/**
 *  delete a record in table where key = value
 *  if key or value is nil, do nothing.
 */
- (void)deleteRecordWhereKey:(NSString *)key value:(id)value error:(NSError **)error;

- (void)truncate;

@end
