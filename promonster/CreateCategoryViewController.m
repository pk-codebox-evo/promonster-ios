//
//  CreateCategoryViewController.m
//  promonster
//
//  Created by Conrado on 11/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "CreateCategoryViewController.h"
#import "CSNotificationView.h"
#import "WebService.h"

@interface CreateCategoryViewController ()

@end

@implementation CreateCategoryViewController
@synthesize scrollView,cat, nameTextField, inWordsTextField, outWordsTextField;
@synthesize edit, salveOutlet, tagOption, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    newCategory = [[CreateCategories alloc] init];
    newCategory.color = [self getColorAtIndex:0];
    
    [self defineSalveButton];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retractKeyboard)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    [scrollView setScrollEnabled:YES];
    CGSize scrollViewContentSize = CGSizeMake(320, 800);
    [self.scrollView setContentSize:scrollViewContentSize];
    int temp = 0;
    int cont = (int)[tagOption count];

    if (edit) {
        self.nameTextField.enabled = NO;
        int colorTag = [self getIndexByColor:cat.color];
        for (int i = 0; i < cont; i++) {
            UIButton *but = [tagOption objectAtIndex:i];
            if (i!=colorTag) {
                UIImage *image = [[UIImage imageNamed:@"tag_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [but setImage:image forState:UIControlStateNormal];
            } else {
                NSString *name = @"tag";
                name = [name stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
                UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [but setImage:image forState:UIControlStateNormal];
                newCategory.color = [self getColorAtIndex:i];
            }
        }
        
        self.navigationItem.title = @"EDITAR CATEGORIA";
        self.nameTextField.placeholder = cat.name;
        NSString *text = @"";

        if ([cat.wordsIn count]!=0) {

            for (NSString *word in cat.wordsIn) {
                if (temp) {
                    text = [text stringByAppendingString:@","];
                }
                temp = 1;
                text = [text stringByAppendingString:word];
            }
            self.inWordsTextField.text = text;
        }
        if ([cat.wordsOut count]!=0) {
            temp = 0;
            text = @"";
            for (NSString *word in cat.wordsOut) {
                if (temp) {
                    text = [text stringByAppendingString:@","];
                }
                temp = 1;
                text = [text stringByAppendingString:word];
            }
            self.outWordsTextField.text = text;
        }
    } else {
        self.navigationItem.title = @"CRIAR CATEGORIA";
        [self.nameTextField becomeFirstResponder];
    }

    for (int i = 0; i<cont; i++) {
        UIButton *but = [tagOption objectAtIndex:i];
        [self actionButton:but];
    }
}

- (NSString *) getColorAtIndex: (int) index {
    NSString *color = @"";
    switch (index) {
        case 0:
            color = @"#FFD600";
            break;
        case 1:
            color = @"#FF7E7E";
            break;
        case 2:
            color = @"#FB1470";
            break;
        case 3:
            color = @"#9C578D";
            break;
        case 4:
            color = @"#5CC9E0";
            break;
        default:
            color = @"#78E05C";
            break;
    }
    return color;
}
- (int) getIndexByColor: (NSString *) color {
    int index = 0;
    if ([color isEqualToString:@"#FFD600"]) {
        index = 0;
    } else if ([color isEqualToString:@"#FF7E7E"]){
        index = 1;
    } else if ([color isEqualToString:@"#FB1470"]){
        index = 2;
    }else if ([color isEqualToString:@"#9C578D"]){
        index = 3;
    } else {
        index = 4;
    }
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField Delegate
- (void) retractKeyboard {
    [nameTextField resignFirstResponder];
    [inWordsTextField resignFirstResponder];
    [outWordsTextField resignFirstResponder];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self retractKeyboard];
}

#pragma mark - ScrollView with TextField
// This code handles the scrolling when tabbing through input fields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.25;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 400;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	CGRect textFieldRect = [self.scrollView.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect = [self.scrollView.window convertRect:self.scrollView.bounds fromView:self.scrollView];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0) {
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0) {
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else {
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = self.scrollView.frame;
	viewFrame.origin.y -= animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.scrollView setFrame:viewFrame];
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	CGRect viewFrame = self.scrollView.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.scrollView setFrame:viewFrame];
 	[UIView commitAnimations];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameTextField) {
        [inWordsTextField becomeFirstResponder];
        //  return  YES;
    } else if (textField == inWordsTextField) {
        [outWordsTextField becomeFirstResponder];
        // return  YES;
    } else if (textField == outWordsTextField){
        [self salveAction];
    }
    return NO;
}

#pragma mark - Button Action
- (IBAction)salve:(id)sender {
    [self salveAction];
}

- (void) salveAction {
    if (!_isSalve) {
        if (edit) {
            newCategory.name = nameTextField.placeholder;
        } else {
            newCategory.name = nameTextField.text;
        }
        newCategory.stringIn = inWordsTextField.text;
        newCategory.stringOut = outWordsTextField.text;
        
        if (!service) {
            service = [[WebService alloc] init];
            service.delegate = self;
        }
        
        if (edit) {
            [service editCategoryPOST:newCategory];
        } else {
            if ([nameTextField.text isEqualToString:@""]) {
                [CSNotificationView showInViewController:self
                                                   style:CSNotificationViewStyleError
                                                 message:@"Insira um nome para a categoria!"];
                [nameTextField becomeFirstResponder];
            } else {
                [service createCategory:newCategory];
            }
        }
    }
}
- (void)buttonPress:(id)sender{
    UIButton* button = (UIButton*)sender;
    int cont = (int)[tagOption count];
    for (int i = 0; i<cont; i++) {
        UIButton *but = [tagOption objectAtIndex:i];
        
        if (button!=but) {
            UIImage *image = [[UIImage imageNamed:@"tag_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [but setImage:image forState:UIControlStateNormal];
        } else {
            NSString *name = @"tag";
            name = [name stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
            UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [but setImage:image forState:UIControlStateNormal];
            newCategory.color = [self getColorAtIndex:i];
        }
    }
}
- (void) actionButton: (UIButton *) button {
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
}
- (void) defineSalveButton {
    salveOutlet.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:16.0f];
    
    salveOutlet.layer.borderWidth = 1;
    salveOutlet.layer.cornerRadius = CGRectGetHeight(salveOutlet.bounds) / 8;
    
    salveOutlet.layer.shadowColor = [UIColor grayColor].CGColor;
    salveOutlet.layer.shadowOffset = CGSizeMake(0, 1);
    salveOutlet.layer.shadowOpacity = 2;
    salveOutlet.layer.shadowRadius = 2.0;
    salveOutlet.clipsToBounds = NO;
}
- (void) setDelegate:(CategoriesViewController *)delegateTmp {
    delegate = delegateTmp;
}
@end
