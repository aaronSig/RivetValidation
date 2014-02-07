//
//  StringUtilTests.m
//  Pods
//
//  Created by Aaron Signorelli on 07/02/2014.
//
//

#import <XCTest/XCTest.h>
#import "StringUtil.h"

@interface StringUtilTests : XCTestCase

@end

@implementation StringUtilTests

// Specific Matchers
//-----------------------------------------------------------------------

- (void) testValidEmailAddresses {
    NSArray *validEmails = @[@"email@domain.com",
                            @"firstname.lastname@domain.com",
                            @"email@subdomain.domain.com",
                            @"firstname+lastname@domain.com",
                            @"email@123.123.123.123",
                            @"email@[123.123.123.123]",
                            @"email@domain.com",
                            @"1234567890@domain.com",
                            @"email@domain-one.com",
                            @"_______@domain.com",
                            @"email@domain.name",
                            @"email@domain.co.jp",
                            @"firstname-lastname@domain.com"];
    
    [validEmails enumerateObjectsUsingBlock:^(NSString* emailAddress, NSUInteger idx, BOOL *stop) {
        BOOL isValid = [StringUtil isValidEmailAddress:emailAddress];
        if(isValid == NO) {
            XCTFail(@"Valid email address: %@ did not pass validation test.", emailAddress);
        }
    }];
}

- (void) testInvalidEmailAddresses {
    NSArray *validEmails = @[@"plainaddress",
                             @"#@%^%#$@#$@#.com",
                             @"@domain.com",
                             @"Joe Smith <email@domain.com>",
                             @"email.domain.com",
                             @"email@domain@domain.com",
                             @".email@domain.com",
                             @"email.@domain.com",
                             @"email..email@domain.com",
                             @"あいうえお@domain.com",
                             @"email@domain.com (Joe Smith)",
                             @"email@domain",
                             @"email@-domain.com",
                             @"email@domain..com"];
    
    [validEmails enumerateObjectsUsingBlock:^(NSString* emailAddress, NSUInteger idx, BOOL *stop) {
        BOOL isValid = [StringUtil isValidEmailAddress:emailAddress];
        if(isValid == YES) {
            XCTFail(@"Invalid email address: %@ did passed validation test.", emailAddress);
        }
    }];
}

// Character sets
//-----------------------------------------------------------------------

- (void) testIsAlpha
{
    XCTAssertTrue([StringUtil isAlpha:@""]);
    XCTAssertTrue([StringUtil isAlpha:@"abc"]);

    XCTAssertFalse([StringUtil isAlpha:nil]);
    XCTAssertFalse([StringUtil isAlpha:@" "]);
    XCTAssertFalse([StringUtil isAlpha:@"ab2c"]);
    XCTAssertFalse([StringUtil isAlpha:@"ab-c"]);
}

- (void) testIsAlphaOrSpaces
{
    XCTAssertTrue([StringUtil isAlphaOrSpaces:@""]);
    XCTAssertTrue([StringUtil isAlphaOrSpaces:@"abc"]);
    XCTAssertTrue([StringUtil isAlphaOrSpaces:@" "]);
    
    XCTAssertFalse([StringUtil isAlphaOrSpaces:nil]);
    XCTAssertFalse([StringUtil isAlphaOrSpaces:@"ab2c"]);
    XCTAssertFalse([StringUtil isAlphaOrSpaces:@"ab-c"]);
}

- (void) testIsAlphaNumeric
{
    XCTAssertFalse([StringUtil isAlphanumeric:nil]);
    XCTAssertFalse([StringUtil isAlphanumeric:@"ab-c"]);
    
    XCTAssertTrue([StringUtil isAlphanumeric:@""]);
    XCTAssertTrue([StringUtil isAlphanumeric:@"abc"]);
    XCTAssertTrue([StringUtil isAlphanumeric:@" "]);
    XCTAssertTrue([StringUtil isAlphanumeric:@"ab2c"]);
}

- (void) testIsNumeric {
    XCTAssertFalse([StringUtil isNumeric:nil]);
    XCTAssertFalse([StringUtil isNumeric:@"  "]);
    XCTAssertFalse([StringUtil isNumeric:@"12 3"]);
    XCTAssertFalse([StringUtil isNumeric:@"ab2c"]);
    XCTAssertFalse([StringUtil isNumeric:@"12-3"]);
    XCTAssertFalse([StringUtil isNumeric:@"12.3"]);
    
    XCTAssertTrue([StringUtil isNumeric:@""]);
    XCTAssertTrue([StringUtil isNumeric:@"123"]);
}

// Length checks
//-----------------------------------------------------------------------
- (void) testLongerThan {
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:0]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:1]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:2]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:3]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:4]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:5]);
}

- (void) testShorterThan {
    XCTAssertFalse([StringUtil string:@"abc" isShorterThan:0]);
    XCTAssertFalse([StringUtil string:@"abc" isShorterThan:1]);
    XCTAssertFalse([StringUtil string:@"abc" isShorterThan:2]);
    XCTAssertFalse([StringUtil string:@"abc" isShorterThan:3]);
    XCTAssertTrue([StringUtil string:@"abc" isShorterThan:4]);
    XCTAssertTrue([StringUtil string:@"abc" isShorterThan:5]);
}

- (void) testLengthRange
{
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:0 andShorterThan:INT32_MAX]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:1 andShorterThan:INT32_MAX]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:2 andShorterThan:INT32_MAX]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:3 andShorterThan:INT32_MAX]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:4 andShorterThan:INT32_MAX]);
    
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:0 andShorterThan:1]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:0 andShorterThan:2]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:0 andShorterThan:3]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:0 andShorterThan:4]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:0 andShorterThan:5]);

    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:1 andShorterThan:4]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:2 andShorterThan:4]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:4 andShorterThan:4]);
    XCTAssertFalse([StringUtil string:@"abc" isLongerThan:4 andShorterThan:3]);
    XCTAssertTrue([StringUtil string:@"abc" isLongerThan:0 andShorterThan:4]);
}

// Empty checks
//-----------------------------------------------------------------------
- (void) testIsEmpty
{
    XCTAssertTrue([StringUtil isEmpty:nil]);
    XCTAssertTrue([StringUtil isEmpty:@""]);
    
    XCTAssertFalse([StringUtil isEmpty:@" "]);
    XCTAssertFalse([StringUtil isEmpty:@"bob"]);
    XCTAssertFalse([StringUtil isEmpty:@"  bob  "]);
}

- (void) testIsNotEmpty
{
    XCTAssertFalse([StringUtil isNotEmpty:nil]);
    XCTAssertFalse([StringUtil isNotEmpty:@""]);
    
    XCTAssertTrue([StringUtil isNotEmpty:@" "]);
    XCTAssertTrue([StringUtil isNotEmpty:@"bob"]);
    XCTAssertTrue([StringUtil isNotEmpty:@"  bob  "]);
}

- (void) testIsBlank {
    XCTAssertTrue([StringUtil isBlank:nil]);
    XCTAssertTrue([StringUtil isBlank:@""]);
    XCTAssertTrue([StringUtil isBlank:@" "]);
    
    XCTAssertFalse([StringUtil isBlank:@"bob"]);
    XCTAssertFalse([StringUtil isBlank:@"  bob  "]);
}

- (void) testIsNotBlank {
    XCTAssertFalse([StringUtil isNotBlank:nil]);
    XCTAssertFalse([StringUtil isNotBlank:@""]);
    XCTAssertFalse([StringUtil isNotBlank:@" "]);
    
    XCTAssertTrue([StringUtil isNotBlank:@"bob"]);
    XCTAssertTrue([StringUtil isNotBlank:@"  bob  "]);
}

@end
