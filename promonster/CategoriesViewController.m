//
//  CategoriesViewController.m
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "CategoriesViewController.h"
#import "MainViewController.h"
#import "CategorieCell.h"
#import "WebService.h"
#import "UIColor+HexString.h"
#import "Categories.h"
#import "CCAux.h"
#import "CreateCategoryViewController.h"
#import "DejalActivityView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CategoriesViewController ()

@end

@implementation CategoriesViewController
@synthesize info, tableView, createCategoryOutlet, update;

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
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Atualizando"];
    self.tableView.hidden = YES;
    self.navigationItem.title = @"Criar";
    loadAgain = YES;
    [self download];
    log = [CCAux shouldSkipLogIn];
    createCategoryOutlet.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:16.0f];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self backButtonCustom];
    [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];

    self.navigationItem.title = @"CATEGORIAS";

    if (log != [CCAux shouldSkipLogIn]) {
        [self download];
        log = [CCAux shouldSkipLogIn];
    } else {
        if (update) {
            [self download];
            update = NO;
        }
    }
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Categories Screen";

}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (disapearWithNavigation) {
        loadAgain = NO;
        disapearWithNavigation = NO;
    } else {
        loadAgain = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WebService
- (void) download {
    WebService *service = [[WebService alloc] init];
    service.delegate = self;
    [service getListCategorie];
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [info count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategorieCell";
    CategorieCell *cell = (CategorieCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategorieCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Categories  *cat = [info objectAtIndex:indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@ (%@)",cat.name,cat.quant];
    cell.image.image = [cell.image.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    NSString *color = cat.color;
    NSString *userId = cat.user_id;
    if (userId) {
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cell.image.tintColor = [UIColor colorWithHexString:color];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;  {
    return 54;
}

#pragma mark - TableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // [self performSegueWithIdentifier:@"AppSegue" sender:self];
    MainViewController *detailProduct = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    Categories *cat = [info objectAtIndex:indexPath.row];
    detailProduct.name = cat.name;
    detailProduct.start = YES;
    
    NSString *userId = cat.user_id;
    if (userId) {
        detailProduct.custom = YES;
    }
    
    disapearWithNavigation = YES;
    [self.navigationController pushViewController:detailProduct animated:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - SWTableViewCell
- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Editar"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Remover"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    switch (state) {
        case 0:
            // NSLog(@"utility buttons closed");
            break;
        case 1:
            // NSLog(@"left utility buttons open");
            break;
        case 2:
            // NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    WebService *service = [[WebService alloc] init];
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    Categories *cat = [info objectAtIndex:cellIndexPath.row];

    switch (index) {
        case 0: {
            [service editCategoryGET: cat andDelegate:self forCell: cell];
            break;
        }
        case 1: {
            [service deleteCategoryName:cat.name andDelegate:self forCell: cell];
            break;
        }
        default:
            break;
    }
}

- (void) openView: (CreateCategories *) cat {
    CreateCategoryViewController *viewCategorie = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateCategoryViewController"];
    viewCategorie.edit = YES;
    viewCategorie.cat = cat;
    [viewCategorie setDelegate:self];
    [self.navigationController pushViewController:viewCategorie animated:YES];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AppSegue"]) {
    }
}

#pragma mark - Button Action
- (IBAction)createCategory:(UIButton *)sender {
    if ([CCAux shouldSkipLogIn]) {
        CreateCategoryViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateCategoryViewController"];
        [newView setDelegate:self];
        [self.navigationController pushViewController:newView animated:YES];
    } else {
        [self performSelector:@selector(logIn) withObject:nil afterDelay:0.3];
    }
}
- (void) logIn {
    [self.tabBarController setSelectedIndex:4];
    [CCAux setLoginStatus:YES];
}
@end
