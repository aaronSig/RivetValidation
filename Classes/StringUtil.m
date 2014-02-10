//
//  StringUtil.m
//  Pods
//
//  porting some of Apache StringUtils.java and sprinkling in some extras
//

#import "StringUtil.h"

NSString * const EmailRegex = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                              @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                              @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                              @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                              @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                              @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                              @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@implementation StringUtil

// Specific Matchers
//-----------------------------------------------------------------------
/**
 * True if the email address is valid to the RFC 2822 spec.
 */
+(BOOL) isValidEmailAddress:(NSString *) str {
    return [StringUtil string:str matchesRegex:EmailRegex];
}

+(BOOL) string:(NSString *) str matchesRegex:(NSString *) regex {
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    return [test evaluateWithObject:str];
}

// Character sets
//-----------------------------------------------------------------------

/**
 * <p>Checks if the String contains only unicode letters.</p>
 *
 * <p><code>null</code> will return <code>false</code>.
 * An empty String ("") will return <code>true</code>.</p>
 *
 * <pre>
 * [StringUtil isAlpha:nil]    = false
 * [StringUtil isAlpha:@""]     = true
 * [StringUtil isAlpha:@" "]   = false
 * [StringUtil isAlpha:@"abc"]  = true
 * [StringUtil isAlpha:@"ab2c"] = false
 * [StringUtil isAlpha:@"ab-c"] = false
 * </pre>
 */
+(BOOL) isAlpha: (NSString *) str {
    return [StringUtil string:str onlyContainsCharactersInSet: [NSCharacterSet letterCharacterSet]];
}

/**
 * <p>Checks if the String contains only unicode letters or spaces.</p>
 *
 * <pre>
 * [StringUtil isAlphaOrSpaces:nil]    = false
 * [StringUtil isAlphaOrSpaces:@""]     = true
 * [StringUtil isAlphaOrSpaces:@" "]   = true
 * [StringUtil isAlphaOrSpaces:@"abc"]  = true
 * [StringUtil isAlphaOrSpaces:@"ab2c"] = false
 * [StringUtil isAlphaOrSpaces:@"ab-c"] = false
 * </pre>
 */
+(BOOL) isAlphaOrSpaces: (NSString *) str {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [StringUtil string:str onlyContainsCharactersInSet: characterSet];
}

/**
 * <p>Checks if the String contains only letters, numbers or spaces.</p>
 *
 * <pre>
 * [StringUtil isAlphanumeric:nil]         = false
 * [StringUtil isAlphanumeric:@""]         = true
 * [StringUtil isAlphanumeric:@" "]        = true
 * [StringUtil isAlphanumeric:@"abc"]      = true
 * [StringUtil isAlphanumeric:@"ab2c"]     = true
 * [StringUtil isAlphanumeric:@"ab-c"]     = false
 * </pre>
 */
+(BOOL) isAlphanumeric: (NSString *) str {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [StringUtil string:str onlyContainsCharactersInSet: characterSet];
}


/**
 * <p>Checks if the String contains only unicode digits.
 * A decimal point is not a unicode digit and returns false.</p>
 *
 * <p><code>null</code> will return <code>false</code>.
 * An empty String ("") will return <code>true</code>.</p>
 *
 * <pre>
 * [StringUtil isNumeric:nil]     = false
 * [StringUtil isNumeric:@""]     = true
 * [StringUtil isNumeric:@"  "]   = false
 * [StringUtil isNumeric:@"123"]  = true
 * [StringUtil isNumeric:@"12 3"] = false
 * [StringUtil isNumeric:@"ab2c"] = false
 * [StringUtil isNumeric:@"12-3"] = false
 * [StringUtil isNumeric:@"12.3"] = false
 * </pre>
 *
 */
+(BOOL) isNumeric:(NSString *) str {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    return [StringUtil string:str onlyContainsCharactersInSet: characterSet];
}

/**
 * <p>False if any of the characters in the string do not exist in the supplied character set</p>
 *
 */
+(BOOL) string: (NSString *) str onlyContainsCharactersInSet: (NSMutableCharacterSet *) characterSet {
    // Since we invert the character set if it is == NSNotFound then it is in the character set.
    return ([str rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}

// Length checks
//-----------------------------------------------------------------------

/** 
 * Checks if a string is longer than minLength chars.
 */
+(BOOL) string:(NSString *) str isLongerThan:(int) minLength {
    return [str length] > minLength;
}

/**
 * Checks if a string is shorter than maxLength chars.
 */
+(BOOL) string:(NSString *) str isShorterThan:(int) maxLength {
    return [str length] < maxLength;

}

/**
 * Checks if a string length is in a given range.
 */
+(BOOL) string:(NSString *) str isLongerThan:(int)minLength andShorterThan:(int) maxLength {
    int len = [str length];
    return len > minLength && len < maxLength;
}

// Empty checks
//-----------------------------------------------------------------------
/**
 * <p>Checks if a String is empty ("") or null.</p>
 *
 * <pre>
 * [StringUtil isEmpty:nil]        = true
 * [StringUtil isEmpty:@""]        = true
 * [StringUtil isEmpty:@" "]       = false
 * [StringUtil isEmpty:@"bob"]     = false
 * [StringUtil isEmpty:@"  bob  "] = false
 * </pre>
 *
 */
+(BOOL) isEmpty:(NSString *) str {
    return str == nil || [str length] == 0;
}

/**
 * <p>Checks if a String is not empty ("") and not null.</p>
 *
 * <pre>
 * [StringUtil isNotEmpty:nil]        = false
 * [StringUtil isNotEmpty:@""]        = false
 * [StringUtil isNotEmpty:@" "]       = true
 * [StringUtil isNotEmpty:@"bob"]     = true
 * [StringUtil isNotEmpty:@"  bob  "] = true
 * </pre>
 */
+(BOOL) isNotEmpty:(NSString *) str {
    return ![StringUtil isEmpty:str];
}

/**
 * <p>Checks if a String is whitespace, empty (@"") or null.</p>
 *
 * <pre>
 * [StringUtil isBlank:nil]        = true
 * [StringUtil isBlank:@""]        = true
 * [StringUtil isBlank:@" "]       = true
 * [StringUtil isBlank:@"bob"]     = false
 * [StringUtil isBlank:@"  bob  "] = false
 * </pre>
 *
 */
+(BOOL) isBlank:(NSString *) str {
    if (![str length]){
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return ([[str stringByTrimmingCharactersInSet: set] length] == 0);
}

/**
 * <p>Checks if a String is not empty (@""), not null and not whitespace only.</p>
 *
 * <pre>
 * [StringUtil isNotBlank:nil]        = false
 * [StringUtil isNotBlank:@""]        = false
 * [StringUtil isNotBlank:@" "]       = false
 * [StringUtil isNotBlank:@"bob"]     = true
 * [StringUtil isNotBlank:@"  bob  "] = true
 * </pre>
 *
 */

+(BOOL) isNotBlank:(NSString *) str {
    return ![StringUtil isBlank:str];
}

@end
