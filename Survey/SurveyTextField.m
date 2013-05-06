//
//  SurveyTextField.m
//  Survey
//
//  Created by Wess Cope on 2/21/13.
//  Copyright (c) 2013 Wess Cope. All rights reserved.
//

#import "SurveyTextField.h"
#import "SurveyValidator.h"
#import "SurveyForm.h"

@interface SurveyTextField()//<UITextFieldDelegate>
@end

@implementation SurveyTextField
@synthesize errors = _errors;

- (void)setup
{
    self.validationOptions  = @[SurveyValidationRequired];
    self.errorMessages      = [SurveyDefaultErrorMessages mutableCopy];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if(!self.placeholder)
        self.placeholder = [title capitalizedString];
    
    _title = title;
}

- (BOOL)isValid
{
    __weak typeof(self) weakSelf                = self;
    __block BOOL isValid                        = YES;
    __block NSMutableDictionary *currentErrors  = [NSMutableDictionary new];

    if([self.validationOptions containsObject:SurveyValidationRequired] && !self.text)
    {
        currentErrors[SurveyValidationRequired] = self.errorMessages[SurveyValidationRequired];
        isValid = NO;
    }
    else
    {
        [self.validationOptions enumerateObjectsUsingBlock:^(NSString *option, NSUInteger idx, BOOL *stop) {
            NSString *value = weakSelf.text;
            if(value && ![SurveyValidator validateString:value withValidator:option])
            {
                currentErrors[option] = self.errorMessages[option];
                isValid = NO;
            }
        }];
    }

    _errors = [currentErrors copy];
    
    if(self.onError != nil)
        self.onError(self, _errors);
    
    return isValid;
}

@end
