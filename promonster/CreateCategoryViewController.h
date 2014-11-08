//
//  CreateCategoryViewController.h
//  promonster
//
//  Created by Conrado on 11/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateCategories.h"
#import "CategoriesViewController.h"
#import "WebService.h"
@interface CreateCategoryViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    CGFloat animatedDistance;
    CreateCategories *newCategory;
    WebService *service;
}
@property (nonatomic, retain) CategoriesViewController *delegate;
@property (retain, nonatomic) CreateCategories *cat;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tagOption;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *salveOutlet;
@property (strong, nonatomic) IBOutlet UIButton *tag1;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *inWordsTextField;
@property (strong, nonatomic) IBOutlet UITextField *outWordsTextField;

@property (nonatomic) BOOL isSalve;
@property (nonatomic) BOOL edit;

- (void) setDelegate:(CategoriesViewController *)delegateTmp;
- (IBAction)salve:(id)sender;
- (void) retractKeyboard;

@end
