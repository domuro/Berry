//
//  DailyLog.h
//  Mango
//
//  Created by 夏目夏樹 on 11/16/13.
//  Copyright (c) 2013 Team Mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDailyLog : NSObject

extern NSString *const kDailyLogNotesUserSkipAMeal;
extern NSString *const kDailyLogNotesUserAteHeavyMeal;
extern NSString *const kDailyLogNotesUserExercised;
extern NSString *const kDailyLogNotesUserVacation;

@property NSDictionary *data;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSArray *records;
@property (nonatomic) NSDictionary *notes;
@property (nonatomic) NSNumber *grade;

+ (NSDate *)localDateWithGMTDate:(NSDate *)aDate;
+ (TMDailyLog *)dailyLogWithDate:(NSDate *)aDate;
- (void)writeToDisk;

+ (id)dailyLogFromPlist:(NSString *)aPlist;
+ (id)dailyLogFromDictionary:(NSDictionary *)aDictionary;
+ (id)emptyDailyLogWithDate:(NSDate *)aDate;
+ (NSDateFormatter *)dateFormatter;
- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (id)initWithDate:(NSDate *)aDate records:(NSArray *)theRecords notes:(NSDictionary *)theNotes;
- (BOOL)writeToPlist:(NSString *)aPlist;

- (BOOL)isEmpty;
- (void)setData:(NSDictionary *)data;
- (NSDictionary *)data;
- (void)setDate:(NSDate *)date;
- (NSDate *)date;
- (NSArray *)records;
- (void)setRecords:(NSArray *)theRecords;
- (NSNumber *)hasNoteType:(NSString *)aNoteType;
- (void)updateNotes:(NSDictionary *)theNotes;

- (NSNumber *)grade;
- (BOOL)isAllRecordsExist;
- (BOOL)isNotesExist;
- (BOOL)isGradeAorB;

@end
