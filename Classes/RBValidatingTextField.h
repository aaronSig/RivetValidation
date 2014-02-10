//
//  RBValidatingTextField.h
//  Pods
//
//  Created by Aaron Signorelli on 07/02/2014.
//
//

#import <UIKit/UIKit.h>

@protocol RBValidatingTextFieldDelegate <NSObject>

-(void) textField:(UITextField *) textField validationStateDidChange:(BOOL) isValid;

@optional
/*
 Called when the user has finished editing and the field is valid.
 */
-(void) clearUIValidationStateForTextField:(UITextField *) textField;

@end

//---

@interface RBValidatingTextField : UITextField

@property(nonatomic, retain) id<RBValidatingTextFieldDelegate> validationDelegate;

@property(nonatomic, assign) BOOL isValid;
@property(nonatomic, readonly) BOOL pristine;

@property(nonatomic, assign) BOOL required;
@property(nonatomic, assign) int minLength;
@property(nonatomic, assign) int maxLength;
@property(nonatomic, retain) NSString *validationRegex;
@property(nonatomic, retain) NSString *validationRule; // email_address, alpha, numeric, alphanumeric

/*
 Set this for complex custom validation rules (like validating phone numbers across regions)
 Return true if the text is valid, false if the text is incorrect.
 */
@property(nonatomic, copy) BOOL (^validationBlock)(NSString *);

/*
 Manually force a validation check to run.
 Returns true if the text field is valid
 */
-(BOOL) validate;

@end

