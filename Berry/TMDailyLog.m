//
//  DailyLog.m
//  Mango
//
//  Created by 夏目夏樹 on 11/16/13.
//  Copyright (c) 2013 Team Mango. All rights reserved.
//

#import "TMDailyLog.h"

@implementation TMDailyLog

static NSString *const kDailyLogDate = @"Date";
static NSString *const kDailyLogRecords = @"Records";
static NSString *const kDailyLogNotes = @"Notes";
static NSString *const kDailyLogGrade = @"Grade";
NSString *const kDailyLogNotesUserSkipAMeal = @"1";
NSString *const kDailyLogNotesUserAteHeavyMeal = @"2";
NSString *const kDailyLogNotesUserExercised = @"3";
NSString *const kDailyLogNotesUserVacation = @"4";

@synthesize data;


+ (NSDate *)localDateWithGMTDate:(NSDate *)aDate
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:aDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:aDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:aDate];
}

+ (NSString *)urlWithDate:(NSDate *)aDate
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[[[[TMDailyLog dateFormatter] stringFromDate:aDate] stringByReplacingOccurrencesOfString:@"/" withString:@"-"]stringByAppendingPathExtension:@"plist"]];
}

+ (TMDailyLog *)dailyLogWithDate:(NSDate *)aDate
{
    NSString * url = [TMDailyLog urlWithDate:aDate];
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        return [TMDailyLog dailyLogFromPlist:url];
    } else {
        return [TMDailyLog emptyDailyLogWithDate:aDate];
    }
}

- (void)writeToDisk
{
    //if (![self isEmpty]) {
        [self writeToPlist:[TMDailyLog urlWithDate:[self date]]];
    //}
}

+ (id)dailyLogFromPlist:(NSString *)aPlist
{
    return [[TMDailyLog alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:aPlist]];
}

- (BOOL)writeToPlist:(NSString *)aPlist
{
    return [[self data] writeToFile:aPlist atomically:YES];
}

+ (id)dailyLogFromDictionary:(NSDictionary *)aDictionary
{
    return [[TMDailyLog alloc] initWithDictionary:aDictionary];
}

+ (id)emptyDailyLogWithDate:(NSDate *)aDate
{
    return [[TMDailyLog alloc] initWithDate:aDate records:@[@0, @0, @0] notes:@{}];
}

- (id)initWithDate:(NSDate *)aDate records:(NSArray *)theRecords notes:(NSDictionary *)theNotes
{
    self = [super init];
    if(self) {
        [self setData:@{}];
        [self setDate:aDate];
        [self setRecords:theRecords];
        [self setNotes:theNotes];
    }
    return(self);
}

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if(self) {
        data = aDictionary;
    }
    return(self);
}

- (BOOL)isEmpty
{
    return ([[self records] isEqual:@[@0, @0, @0]] && [[[self data] objectForKey:kDailyLogNotes] count] == 0);
}

- (NSDictionary *)dictionaryForDailyLog
{
    return [self data];
}

- (void)updateData:(NSDictionary *)theData
{
    
    NSMutableDictionary *newData = [[self data] mutableCopy];
    [newData addEntriesFromDictionary:theData];
    [self setData:[newData copy]];
    [newData addEntriesFromDictionary:@{
                                        kDailyLogGrade:[self regrade]
                                        }];
    [self setData:[newData copy]];
}

- (NSNumber *)regrade
{
    NSInteger totalGrade = 0;
    NSInteger totalNumberOfGrades = 0;
    NSInteger gradeForMorning = [self gradeForMorning];
    NSInteger gradeForNoon = [self gradeForNoon];
    NSInteger gradeForEvening = [self gradeForEvening];
    if (gradeForMorning >= 0) {
        totalGrade += gradeForMorning;
        totalNumberOfGrades += 1;
    }
    if (gradeForNoon >= 0) {
        totalGrade += gradeForNoon;
        totalNumberOfGrades += 1;
    }
    if (gradeForEvening >= 0) {
        totalGrade += gradeForEvening;
        totalNumberOfGrades += 1;
    }
    if (totalNumberOfGrades == 0) {
        return [NSNumber numberWithInt:-1];
    } else {
        return [NSNumber numberWithFloat:(totalGrade / totalNumberOfGrades)];
    }
}

- (NSInteger)gradeForMorning
{
    float g = [[[self records] objectAtIndex:0] floatValue];
    if (g == 0) {
        return -1;
    } else if (g >= 70 && g <= 160) {
        return 5;
    } else if ((g >= 66 && g < 70) || (g > 160 && g <= 180)) {
        return 4;
    } else if ((g >= 62 && g < 66) || (g > 180 && g <= 200)) {
        return 3;
    } else if ((g >= 58 && g < 62) || (g > 200 && g <= 230)) {
        return 2;
    } else if ((g >= 55 && g < 58) || (g > 230 && g <= 280)) {
        return 1;
    } else if (g < 55 || g > 280) {
        return 0;
    }
    return -1;

}

- (NSInteger)gradeForNoon
{
    float g = [[[self records] objectAtIndex:1] floatValue];
    if (g == 0) {
        return -1;
    } else if (g >= 110 && g <= 180) {
        return 5;
    } else if ((g >= 100 && g < 110) || (g > 180 && g <= 205)) {
        return 4;
    } else if ((g >= 85 && g < 100) || (g > 205 && g <= 230)) {
        return 3;
    } else if ((g >= 70 && g < 85) || (g > 230 && g <= 250)) {
        return 2;
    } else if ((g >= 55 && g < 70) || (g > 250 && g <= 300)) {
        return 1;
    } else if (g < 55 || g >= 300) {
        return 0;
    }
    return -1;
}

- (NSInteger)gradeForEvening
{
    float g = [[[self records] objectAtIndex:2] floatValue];
    if (g == 0) {
        return -1;
    } else if (g >= 110 && g <= 180) {
        return 5;
    } else if ((g >= 100 && g < 110) || (g > 180 && g <= 205)) {
        return 4;
    } else if ((g >= 85 && g < 100) || (g > 205 && g <= 230)) {
        return 3;
    } else if ((g >= 70 && g < 85) || (g > 230 && g <= 250)) {
        return 2;
    } else if ((g >= 55 && g < 70) || (g > 250 && g <= 300)){
        return 1;
    } else if (g < 55 || g >= 300) {
        return 0;
    }
    return -1;
}

- (NSDate *)date
{
    return [[TMDailyLog dateFormatter] dateFromString:[[self data] objectForKey:kDailyLogDate]];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return dateFormatter;
}

- (void)setDate:(NSDate *)aDate
{
    [self updateData:@{
                    kDailyLogDate:[[TMDailyLog dateFormatter] stringFromDate:aDate]
                    }];
}

- (NSArray *)records
{
    return [[self data] objectForKey:kDailyLogRecords];
}

- (void)setRecords:(NSArray *)theRecords
{
    [self updateData:@{
                    kDailyLogRecords:theRecords
                    }];
}

- (NSNumber *)hasNoteType:(NSString *)aNoteType
{
    return [NSNumber numberWithBool:([[data objectForKey:kDailyLogNotes] indexOfObject:aNoteType] != NSNotFound)];
}

- (NSDictionary *)notes
{
    return @{
             kDailyLogNotesUserAteHeavyMeal:[self hasNoteType:kDailyLogNotesUserAteHeavyMeal],
             kDailyLogNotesUserExercised:[self hasNoteType:kDailyLogNotesUserExercised],
             kDailyLogNotesUserSkipAMeal:[self hasNoteType:kDailyLogNotesUserSkipAMeal],
             kDailyLogNotesUserVacation:[self hasNoteType:kDailyLogNotesUserVacation]
             };
}

- (void)setNotes:(NSDictionary *)theNotes
{
    NSMutableArray *theMutableNotesArray = [[NSMutableArray alloc] init];
    for (NSString *aNoteType in [theNotes allKeys]) {
        if ([[theNotes objectForKey:aNoteType] boolValue]) {
            [theMutableNotesArray addObject:aNoteType];
        }
    }
    NSArray *theNotesArray = [theMutableNotesArray copy];
    
    [self updateData:@{
                       kDailyLogNotes: theNotesArray
                       }];
}

- (void)updateNotes:(NSDictionary *)theNotes
{
    NSMutableDictionary *newNotes = [[self notes] mutableCopy];
    [newNotes addEntriesFromDictionary:theNotes];
    [self setNotes:[newNotes copy]];
}

- (NSNumber *)grade
{
    return [[self data] objectForKey:kDailyLogGrade];
}

- (BOOL)isAllRecordsExist
{
    for (NSNumber *aRecord in [self records]) {
        if ([aRecord integerValue] == 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNotesExist
{
    return [[self notes] count] != 0;
}

- (BOOL)isGradeAorB
{
    return [[self grade] floatValue] > 4;
}

@end