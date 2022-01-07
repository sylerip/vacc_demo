//
//  BulletProofsFunc.m
//  VaccinationDemo
//
//  Created by Comp 631C on 7/1/2022.
//  Copyright © 2022 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bulletproofs/Bulletproofs.h"

//@interface BulletProofs:NSObject
///* method declaration */
//+ (NSString *)genDateProof:(NSString *)dateStr;
//+ (BOOL)proofDate:(NSString *)proofStr;
//@end

@implementation BulletProofs : NSObject
    
    long m = 1, veclength = 8;

// this function return the json with the day ranage

+ (NSString *)genDateProof:(NSString *)dateStr {
    NSString *dateRange = @"\"hiddenDayRanage\":\"";
//    NSString *proofStrJson = @"\"proof\":\"";
    NSString *proofStrJson = @"\"proof\":";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    NSDate *currentDate = [dateFormatter dateFromString: dateStr];
    NSLog(@"Current Date = %@", currentDate);

    
    // Getting the first day of Month before
    NSDateComponents *dateBeforeComponents = [NSDateComponents new];
    dateBeforeComponents.month = -1;

    NSDate *currentDateMin1Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateBeforeComponents toDate:currentDate options:0];
//    NSLog(@"One month before = %@", currentDateMin1Month);
    NSCalendar* calendarMin = [NSCalendar currentCalendar];
    NSDateComponents* compsMin = [calendarMin components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:currentDateMin1Month]; // Get necessary date components

    // set last of month
    [compsMin setMonth:[compsMin month]];
    [compsMin setDay:1];
    NSDate *tDateMonthMin = [calendarMin dateFromComponents:compsMin];
    NSLog(@"Start range %@", tDateMonthMin);
    dateRange = [dateRange stringByAppendingString:[formatter stringFromDate:tDateMonthMin]];
    dateRange = [dateRange stringByAppendingString:@" to "];
    
    
    // Getting the last day of next month
    
    NSDateComponents *dateAfterComponents = [NSDateComponents new];
    dateAfterComponents.month = 1;

    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateAfterComponents toDate:currentDate options:0];
//    NSLog(@"One month after = %@", currentDatePlus1Month);
    
    NSCalendar* calendarMax = [NSCalendar currentCalendar];
    NSDateComponents* compsMac = [calendarMax components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:currentDatePlus1Month]; // Get necessary date components

    // set last of month
    [compsMac setMonth:[compsMac month]+1];
    [compsMac setDay:0];
    NSDate *tDateMonthMax = [calendarMax dateFromComponents:compsMac];
    NSLog(@"End range %@", tDateMonthMax);
    dateRange = [dateRange stringByAppendingString:[formatter stringFromDate:tDateMonthMax]];
    dateRange = [dateRange stringByAppendingString:@"\","];
    NSLog(dateRange);
    // translate the date to to number of dates between 2 dates
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsMax = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:tDateMonthMin
                                                          toDate:tDateMonthMax
                                                         options:0];
    
    NSLog(@"%1d",[componentsMax day]);
    NSDateComponents *componentsToday = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:tDateMonthMin
                                                          toDate:currentDate
                                                         options:0];
    
    NSLog(@"%1d",[componentsToday day]);
    
    // --------------------------------------------------------------------------------------------
    
    //Arb start
//    long m = 1, veclength = 16;
////    NSString *secrets[] = {@"11", @"366"};
//    NSString *secrets[] = {[NSString stringWithFormat:@"%d",[componentsToday day]]};
//    NSData *VAS[m];
//    NSString *VASstrs = @"";
////    long min = 60000;
////    long max = 65000;
//    long min = 1;
//    long max = [componentsMax day];
//
//    for (int i=0; i<m; i++){
//        VAS[i] = BulletproofsArbProverGenVAS(veclength, m, i, min, max, secrets[i]);
//        NSString *tmp = [[NSString alloc] initWithData:VAS[i] encoding:NSUTF8StringEncoding];
//        VASstrs = [VASstrs stringByAppendingString:tmp];
//        VASstrs = [VASstrs stringByAppendingString:@";"];
//    }
//    NSData *mpcrp = BulletproofsArbDealerGenyz(veclength, m, VASstrs);
//
//    NSString *T1T2strs = @"";
//    NSData *T1T2[m];
//    for (int i=0; i<m; i++){
//        T1T2[i] = BulletproofsArbProverGenT1T2(veclength, m, VAS[i], mpcrp);
//        NSString *tmp = [[NSString alloc] initWithData:T1T2[i] encoding:NSUTF8StringEncoding];
//        T1T2strs = [T1T2strs stringByAppendingString:tmp];
//        T1T2strs = [T1T2strs stringByAppendingString:@";"];
//    }
//    mpcrp = BulletproofsArbDealerGenx(veclength, m, T1T2strs, mpcrp);
//
//    NSString *Otherstrs = @"";
//    NSData *Other[m];
//    for (int i=0; i<m; i++){
//        Other[i] = BulletproofsArbProverGenOtherShare(veclength, m, T1T2[i], mpcrp);
//        NSString *tmp = [[NSString alloc] initWithData:Other[i] encoding:NSUTF8StringEncoding];
//        Otherstrs = [Otherstrs stringByAppendingString:tmp];
//        Otherstrs = [Otherstrs stringByAppendingString:@";"];
//    }
//    mpcrp = BulletproofsArbDealerGenFinProof(veclength, m, Otherstrs, mpcrp);
    // Arb end
    
    NSData *mpcrp = BulletproofsStardandRPProve(veclength, m,[NSString stringWithFormat:@"%d",[componentsToday day]]);
//    NSString *test = [NSString stringWithFormat:@"%s", [mpcrp base64EncodedDataWithOptions:0]];
    NSString *proofStr =  [[NSString alloc] initWithData:mpcrp encoding:NSUTF8StringEncoding];
    
    proofStrJson = [proofStrJson stringByAppendingString:proofStr];
//    proofStrJson = [proofStrJson stringByAppendingString:@"\""];
//    NSData *testDecode = [[NSData alloc]initWithBase64EncodedString:test options:0];
//    BOOL res6 = BulletproofsArbVerifierVerifyProof(veclength, m, testDecode);
////    BOOL res6 = BulletproofsArbVerifierVerifyProof(veclength, m, mpcrp);
//
//    if (res6) {
//        NSLog(@"the verification of multi party arbitrary range proof is successful");
//    } else {
//        NSLog(@"the verification of multi party arbitrary range proof is failed");
//    }
//    return [mpcrp base64EncodedDataWithOptions:0];
    return [dateRange stringByAppendingString:proofStrJson];
}

+ (BOOL)proofDate:(NSString *)proofStr {
//    NSData *testDecode = [[NSData alloc]initWithBase64EncodedString:proofStr options:0];
    NSData *testDecode = [proofStr dataUsingEncoding:NSUTF8StringEncoding];;
//    BOOL res6 = BulletproofsArbVerifierVerifyProof(veclength, m, testDecode);
////    BOOL res6 = BulletproofsArbVerifierVerifyProof(veclength, m, mpcrp);
//
//    if (res6) {
//        NSLog(@"the verification of multi party arbitrary range proof is successful");
//    } else {
//        NSLog(@"the verification of multi party arbitrary range proof is failed");
//    }
    BOOL res1 = BulletproofsStardandRPVerify(8, 1, testDecode);
    if (res1) {
        NSLog(@"the verification of stardand range proof is successful");
    } else {
        NSLog(@"the verification of stardand range proof is failed");
    }
    return res1;
}

@end
