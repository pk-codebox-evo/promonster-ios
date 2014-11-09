//
//  StaredViewController.m
//  promonster
//
//  Created by Conrado on 01/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "StaredViewController.h"
#import "DetailProductViewController.h"
#import "WebService.h"
#import "HomeCell.h"
#import "Product.h"
#import "CCAux.h"
#import "DejalActivityView.h"
@interface StaredViewController ()

@end

@implementation StaredViewController
@synthesize info, fav, monsterFav;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNoFav];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Atualizando"];

    [self setLayout];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self backButtonCustom];
    self.navigationItem.title = @"FAVORITOS";

    [self download];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Favorites Screen";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logIn {
    [self.tabBarController setSelectedIndex:4];
    [CCAux setLoginStatus:YES];
}
#pragma mark - WebService
- (void) download {
    WebService *service = [[WebService alloc] init];
    service.delegate = self;
    
    if ([CCAux shouldSkipLogIn]) {
        [service getListFavoritesOrder:[self getEN_orderName:_optionLabel.text]];
    } else {
        self.info = nil;
        [self.tableView reloadData];
        [self performSelector:@selector(logIn) withObject:nil afterDelay:0.3];
        
    }
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger value = [info count];
    if (value==0) {
        [self showNoFav];
    } else {
        [self hiddenNoFav];
    }
    return value;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linha = indexPath.row;
    //if (linha%2==0) {
    static NSString *CellIdentifier = @"HomeCell";
    HomeCell *cell = (HomeCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Product *product = [info objectAtIndex:linha];
    [cell.name setTitle: product.name forState:UIControlStateNormal];
    cell.price.text = [NSString stringWithFormat:@"R$ %@",product.price];
    cell.date.text = product.date;
    cell.img_url.url = product.img_url;
    cell.source.text = product.source;
    cell.produto = product;
    [cell setDelegate2:self];
    cell.price_mean = [NSString stringWithFormat:@"R$ %@",product.price_mean];
    [cell setStrikeLine];
    cell.count_fav.hidden = YES;

    [cell.likeButton setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [cell setUnlike];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 202;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AppSegue"]) {
        DetailProductViewController *detailProduct = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Product *produto = [info objectAtIndex:path.row];
        detailProduct.promo_id = [NSString stringWithFormat:@"%@",produto.promo_id];
    }
}


- (IBAction)optionButton:(UIButton *)sender {
    [self showActionSheet];
}
- (void) setLayout {
    _optionLabel.text = @"Ordenar por: Recomendadas";
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *order = @"Ordenar por: ";
    order = [order stringByAppendingString:[actionSheet buttonTitleAtIndex:buttonIndex]];
    
    NSString *old = _optionLabel.text;
    
    if (![old isEqualToString:order]) {
        if (![order isEqualToString:@"Ordenar por: Cancelar"]) {
            [_optionLabel setText:order];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Ordenando..."];
            
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
- (void) showNoFav {
    fav.hidden = NO;
    monsterFav.hidden = NO;
}
- (void) hiddenNoFav {
    fav.hidden = YES;
    monsterFav.hidden = YES;
}

@end
