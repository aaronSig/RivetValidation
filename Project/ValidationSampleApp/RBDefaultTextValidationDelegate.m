//
//  RBDefaultTextValidationDelegate.m
//  ValidationSampleApp
//
//  Created by Aaron Signorelli on 10/02/2014.
//  Copyright (c) 2014 BullOrBear. All rights reserved.
//

#import "RBDefaultTextValidationDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation RBDefaultTextValidationDelegate

-(void) textField:(UITextField *)textField validationStateDidChange:(BOOL)isValid {
    UIColor *highlight = isValid ? [UIColor blueColor] : [UIColor redColor];
    textField.layer.shadowColor = highlight.CGColor;
    textField.layer.shadowRadius = 2.0;
    textField.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    textField.layer.shadowOpacity = 1.0;
    textField.textColor = highlight;
    textField.clipsToBounds = NO;
    textField.layer.borderColor = highlight.CGColor;
    textField.layer.borderWidth = 1.0;
}

-(void) clearUIValidationStateForTextField:(UITextField *)textField {
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.shadowColor = [UIColor clearColor].CGColor;
    textField.textColor = [UIColor blackColor];
}

@end
