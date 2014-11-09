//
//  SearchViewController.m
//  promonster
//
//  Created by Conrado on 01/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailProductViewController.h"
#import "MainViewController.h"
#import "HomeCell.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize service,filteredTableData, info, tableView;
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
    [self setLayout];
    service = [[WebService alloc] init];
    tableView.hidden = YES;

    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"Cancelar"];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"BUSCAR";
    self.title = @"BUSCAR";
    self.screenName = @"Search Screen";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebService
- (void) download {

    NSString *order = [self getEN_orderName:_option.text];
    NSString *query = _searchBar.text;

    [service searchProductByQuery:query andOrder:order withDelegate:self];
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [info count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linha = indexPath.row;
    static NSString *CellIdentifier = @"HomeCell";
    HomeCell *cell = (HomeCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    Product *product = [info objectAtIndex:linha];
    [cell setProduto:product];
    [cell setDelegate:(MainViewController *)self]; // Conrado alterado
    [cell.name setTitle: product.name forState:UIControlStateNormal];
    [cell setLike];
    cell.price.text = [NSString stringWithFormat:@"R$ %@",product.price];
    cell.date.text = product.date;
    cell.img_url.url = product.img_url;
    cell.source.text = product.source;
    cell.price_mean = [NSString stringWithFormat:@"R$ %@",product.price_mean];
    [cell setStrikeLine];
    cell.count_fav.text = [NSString stringWithFormat:@"%@",product.favorites_count];

    [cell.likeButton setImage:[UIImage imageNamed:@"hearth_unselected"] forState:UIControlStateNormal];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f];
    [cell setSelectedBackgroundView:bgColorView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - TableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"AppSegue" sender:self];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AppSegue"]) {
        DetailProductViewController *detailProduct = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Product *produto = [info objectAtIndex:path.row];
        detailProduct.promo_id = [NSString stringWithFormat:@"%@",produto.promo_id];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202;
}

#pragma mark - SearchBar
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
}
- (void) setLayout {
    [_option setText:@"Ordenar por: Recomendadas"];
    
    
    [_orderButtonOutlet addTarget:self
                           action:@selector(showActionSheet)
                 forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIActionSheet
- (void) showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancelar"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Recomendadas",@"Menor preço", @"Mais recentes", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *order = @"Ordenar por: ";
    order = [order stringByAppendingString:[actionSheet buttonTitleAtIndex:buttonIndex]];
    NSString *old = _option.text;
    
    if (![old isEqualToString:order]) {
        if (![order isEqualToString:@"Ordenar por: Cancelar"]) {
            [_option setText:order];
                [self download];
        }
    }
}
- (NSString *) getEN_orderName: (NSString *) nameOrder {
    NSString *result;
    if ([nameOrder isEqualToString:@"Ordenar por: Menor preço"]) {
        result = @"price";
    } else if ([nameOrder isEqualToString:@"Ordenar por: Mais recentes"]) {
        result = @"date";
    } else if ([nameOrder isEqualToString:@"Ordenar por: Recomendadas"]) {
        result = @"hot";
    } else {
        result = @"price";
        NSLog(@"error");
    }
    return result;
}
#pragma mark - Keyboard
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}
- (void) hideKeyboard {
    [_searchBar resignFirstResponder];
}
#pragma mark - Search Delegate
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self download];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.text = @"";
    [self hideKeyboard];
}


@end
