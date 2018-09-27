//
//  CTPersistanceQueryCommand+SchemaManipulations.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (SchemaManipulations)

/**
 *  create table with column information
 *
 *  @param tableName  name of table
 *  @param columnInfo colomn information of table
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo error:(NSError **)error;

/**
 *  create table with column information and defaultVaule
 *
 *  @param tableName  name of table
 *  @param columnInfo colomn information of table
 *  @param defaultSetting colomn default value information of table

 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo columnDefaultValue:(NSDictionary *)defaultSetting error:(NSError **)error;

/**
 *  drop table with table name
 *
 *  @param tableName name of table
 *
 *  @return return CTPersistanceQueryCommnad
 */
- (CTPersistanceSqlStatement *)dropTable:(NSString *)tableName error:(NSError **)error;

/**
 *  add column with column name and column infomation and name of table
 *
 *  @param columnName column name
 *  @param columnInfo column infomation
 *  @param tableName  name of table
 *
 *  @return return CTPersistanceQueryCommnad
 */
- (CTPersistanceSqlStatement *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName error:(NSError **)error;

/**
 *  create Index for table with indexed column list and condition with condition params.
 *
 *  @param indexName         index name
 *  @param tableName         table name
 *  @param indexedColumnList indexed column list
 *  @param isUnique          if YES, create UNIQUE index
 *
 *  @return return CTPerisistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList isUnique:(BOOL)isUnique error:(NSError **)error;

/**
 *  drop index with index name
 *
 *  @param indexName index name
 *
 *  @return return CTPersisitanceQueryCommand
 */
- (CTPersistanceSqlStatement *)dropIndex:(NSString *)indexName error:(NSError **)error;

/**
 *  show the structure of a table
 *
 *  @param tableName tableName name
 *
 *  @return return CTPersisitanceQueryCommand
 */
- (CTPersistanceSqlStatement *)columnInfoWithTableName:(NSString *)tableName error:(NSError **)error;

/**
 *  show tables in database
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)showTablesWithError:(NSError **)error;

@end
