//
//  StringUtil.h
//  Pods
//
//  Created by Aaron Signorelli on 07/02/2014.
//
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

+(BOOL) isValidEmailAddress:(NSString *) str;
+(BOOL) string:(NSString *) str matchesRegex:(NSString *) regex;

+(BOOL) isAlpha: (NSString *) str;
+(BOOL) isAlphaOrSpaces: (NSString *) str;
+(BOOL) isAlphanumeric: (NSString *) str;
+(BOOL) isNumeric:(NSString *) str;
+(BOOL) string: (NSString *) str onlyContainsCharactersInSet: (NSMutableCharacterSet *) characterSet;

+(BOOL) string:(NSString *) str isLongerThan:(int) minLength;
+(BOOL) string:(NSString *) str isShorterThan:(int) maxLength;
+(BOOL) string:(NSString *) str isLongerThan:(int)minLength andShorterThan:(int) maxLength;

+(BOOL) isEmpty:(NSString *) str;
+(BOOL) isNotEmpty:(NSString *) str;
+(BOOL) isBlank:(NSString *) str;
+(BOOL) isNotBlank:(NSString *) str;

@end
