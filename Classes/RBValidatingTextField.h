//
//  RBValidatingTextField.h
//  Pods
//
//  Created by Aaron Signorelli on 07/02/2014.
//
//

#import <UIKit/UIKit.h>

@protocol RBValidatingTextFieldDelegate <NSObject>

-(void) validationStateDidChange:(BOOL) isValid;

@optional
/*
 Called when the user has finished editing and the field is valid.
 */
-(void) clearUIValidationState;

@end

//---

@interface RBValidatingTextField : UITextField

@property(nonatomic, retain) id<RBValidatingTextFieldDelegate> validationDelegate;

@property(nonatomic, assign) BOOL isValid;

@property(nonatomic, assign) BOOL required;
@property(nonatomic, assign) int minLength;
@property(nonatomic, assign) int maxLength;
@property(nonatomic, retain) NSString *validationRegex;
@property(nonatomic, retain) NSString *validationRule; // email_address, alpha, numeric, alphanumeric

@end

