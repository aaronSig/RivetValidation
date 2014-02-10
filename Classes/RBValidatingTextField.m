//
//  RBValidatingTextField.m
//  Pods
//
//  Created by Aaron Signorelli on 07/02/2014.
//
//

#import "RBValidatingTextField.h"
#import "MTKObserving.h"
#import "StringUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation RBValidatingTextField

@synthesize isValid, required, minLength, maxLength, validationRegex;

-(id) init {
    self = [super init];
    if(self) {
        [self initialise];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialise];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialise];
    }
    return self;
}

-(void) initialise {
    isValid = YES;
    _pristine = YES;
    self.required = NO;
    self.minLength = 0;
    self.maxLength = INT32_MAX;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
    [self attachObservers];
}

#pragma mark - catching text changes
-(void) attachObservers {
    //Catch when the user enters text
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(textFieldTextDidBeginEditing) name:@"UITextFieldTextDidBeginEditingNotification" object:self];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(validate) name:@"UITextFieldTextDidChangeNotification" object:self];
    
    //Catch when the user enters text
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(hasFinishedEditing) name:@"UITextFieldTextDidEndEditingNotification" object:self];
    
    //Catch if the code sets the text.
    [self observeProperty:@keypath(self.text) withSelector:@selector(validateTextFieldIgnoreIfPristine)];
    [self observeProperty:@keypath(self.isValid) withSelector:@selector(flushValidationStateToUI)];
}

-(void) detachObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidEndEditingNotification" object:self];
}

-(void) textFieldTextDidBeginEditing {
    _pristine = NO;
}

#pragma mark - validation
-(BOOL) validate {
    _pristine = NO;
    return [self validateTextFieldIgnoreIfPristine];
}

-(BOOL) validateTextFieldIgnoreIfPristine {
    if(_pristine) {
        return YES;
    }
    
    //Check is valid
    BOOL valid = YES;
    NSString *testStr = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(self.required) {
        valid &= [StringUtil isNotBlank:testStr];
    }
    
    valid &= [StringUtil string:testStr isLongerThan:self.minLength andShorterThan:self.maxLength];
    
    if([StringUtil isNotBlank:self.validationRegex])
        valid &= [StringUtil string:testStr matchesRegex:self.validationRegex];
    
    if([@"email_address" isEqualToString:self.validationRule]){
        valid &= [StringUtil isValidEmailAddress:testStr];
    }
    
    if([@"alpha" isEqualToString:self.validationRule]){
        valid &= [StringUtil isAlpha:testStr];
    }
    
    if([@"numeric" isEqualToString:self.validationRule]){
        valid &= [StringUtil isNumeric:testStr];
    }
    
    if([@"alphanumeric" isEqualToString:self.validationRule]){
        valid &= [StringUtil isAlphanumeric:testStr];
    }
    
    if(self.validationBlock) {
        valid &= self.validationBlock(testStr);
    }
    
    return self.isValid = valid;
}

#pragma mark - UI
-(void) flushValidationStateToUI {
    if(_pristine) {
        return;
    }
    
    if(self.validationDelegate) {
        [self.validationDelegate textField:self validationStateDidChange:self.isValid];
        return;
    }
    
    //Default validation notification
    UIColor *highlight = self.isValid ? [UIColor blueColor] : [UIColor redColor];
    self.layer.shadowColor = highlight.CGColor;
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowOpacity = 1.0;
    
    self.textColor = highlight;
    
    self.clipsToBounds = NO;
    
    self.layer.borderColor = highlight.CGColor;
    self.layer.borderWidth = 1.0;
}

-(void) hasFinishedEditing {
    if([self validate]){
        if(self.validationDelegate) {
            [self.validationDelegate clearUIValidationStateForTextField:self];
            return;
        }
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.textColor = [UIColor blackColor];
    }
}

@end
