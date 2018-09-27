//
//  YQLSSearchResultItem.h
//  YQDataBaseDevelop
//
//  Created by FreakyYang on 2017/11/14.
//  Copyright © 2017年 FreakyYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YQLocalStorage;

@interface YQLSSearchResultItem : NSObject

@property (nonatomic,weak,readonly) YQLocalStorage *localStorage;
@property (nonatomic,strong,readonly) NSString *fromTable;

@property (nonatomic,assign,readonly) long ID;

@property (nonatomic,assign,readonly) double creatTime;

@property (nonatomic,assign,readonly) double updateTime;

@property (nonatomic,strong) NSDictionary<NSString *,NSString *> * data;


- (instancetype)initWithLocalStorage:(YQLocalStorage *)localStorage
                               table:(NSString *)tableName
                                  ID:(long)ID
                           creatTime:(double)creatTime
                          updateTime:(double)updateTime
                                data:(NSDictionary<NSString *,NSString *> *)data;

- (void)reloadFromLS;

- (void)reloadFromLSWithBlock:(void(^)(BOOL successed,NSString *reason))block;

- (void)deleteMyself;

- (void)deleteMyselfWithBlock:(void(^)(BOOL successed,NSString *reason))block;

- (void)updateData:(NSDictionary<NSString *,NSString *> *)data
         withBlock:(void(^)(BOOL successed,NSString *reason))block;

@end

