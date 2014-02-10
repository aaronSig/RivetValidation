//
//  ViewController.m
//  ValidationSampleApp
//
//  Created by Aaron Signorelli on 07/02/2014.
//  Copyright (c) 2014 BullOrBear. All rights reserved.
//

#import "ViewController.h"
#import "RBDefaultTextValidationDelegate.h"
#import "RBValidatingTextField.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) awakeFromNib {
    [RBValidatingTextField setDefaultUIValidationDelegate:[[RBDefaultTextValidationDelegate alloc] init]];
}

@end
