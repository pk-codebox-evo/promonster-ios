//
//  MainViewController.m
//  promonster
//
//  Created by Conrado on 25/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//


#import "DejalActivityView.h"
#import "CSNotificationView.h"
#import "WebService.h"
#import "CCAux.h"

#import "DetailProductViewController.h"
#import "NavigationViewController.h"
#import "MainViewController.h"
#import "HomeCell.h"

#define IS_IOS7 [[UIDevice currentDevice].systemVersion hasPrefix:@"7"]

@interface MainViewController ()
@end

@implementation MainViewController
@synthesize tableView;
@synthesize info, start, name, service, custom, failLoad;

#define kLevelUpdatesPerSecond 18
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived) name:@"pushNotification" object:nil];
    
    [self setLayout];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Atualizando"];

    [self download];
    loadAgain = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (failLoad) {
        [self download];
        failLoad = NO;
    }
    self.screenName = @"Main Screen";
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (start) {
        //self.title = name;
    } else {
        
    }
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PushNotification
- (void)pushNotificationReceived {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"promoIdPush"];
    NSString *promoId = [userInfo valueForKey:@"promo_id"];
    
    NSUInteger tabSelected = self.tabBarController.selectedIndex;
    
    if (promoId) {

        if (tabSelected!=2) {
            [self.tabBarController setSelectedIndex:2];
        }
        
        
        DetailProductViewController *detailProduct = (DetailProductViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailProductViewController"];
        detailProduct.promo_id = promoId;
        detailProduct.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NavigationViewController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
        
        
        NSString *currentController = NSStringFromClass(self.navigationController.visibleViewController.class);
        
        if ([currentController isEqualToString:@"MainViewController"]) {
            [nav pushViewController:detailProduct animated:YES];
        } else if ([currentController isEqualToString:@"DetailProductViewController"]) {
            DetailProductViewController *detail = (DetailProductViewController *)self.navigationController.visibleViewController;
            detail.promo_id = promoId;
            detail.showAct = YES;
            [detail download];
        }
    } else {
        NSArray *itens = self.tabBarController.tabBar.items;
        UITabBarItem *tab = [itens objectAtIndex:0];
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *badge = [NSString stringWithFormat:@"%@",[aps valueForKey:@"badge"]];
        
        [tab setBadgeValue: badge];
    }
}

- (void) setLayout {
    [_option setText:@"Ordenar por: Recomendadas"];
    [_orderButtonOutlet addTarget:self
                           action:@selector(showActionSheet)
                 forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - WebService
- (void) download {
    NSString *order = _option.text;
    service = [[WebService alloc] init];
    if (start) {
        self.title = name;

        [service getProductsByName:name
                          andOrder:[self getEN_orderName:order]
                      withDelegate:self];
    } else {
        [self titleCustom];

        [service getProductsByOrder:[self getEN_orderName:order]
                       withDelegate:self];
    }
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [info count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger linha = indexPath.row;
    static NSString *CellIdentifier = @"HomeCell";
    HomeCell *cell = (HomeCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Product *product = [info objectAtIndex:linha];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [cell setProduto:product];
    [cell setDelegate:self];
    cell.img_url.url = product.img_url;
    [cell setLike];
    [cell.name setTitle: product.name forState:UIControlStateNormal];
    cell.produto = product;
    cell.price.text = [NSString stringWithFormat:@"R$ %@",product.price];
    cell.price_mean = [NSString stringWithFormat:@"R$ %@",product.price_mean];
    [cell setStrikeLine];
    cell.date.text = product.date;
    cell.source.text = product.source;
    cell.count_fav.text = [NSString stringWithFormat:@"%@",product.favorites_count];
    [cell.likeButton setImage:[UIImage imageNamed:@"hearth_unselected"] forState:UIControlStateNormal];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:92/255.0f
                                                  green:202/255.0f
                                                   blue:222/255.0f
                                                  alpha:1.0f];
    [cell setSelectedBackgroundView:bgColorView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"AppSegue" sender:self];
    disapearWithNavigation = YES;
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
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Ordenando..."];

            [self download];
        }
    }
}

- (void) setSelectedIndex: (int) index {
    [self.tabBarController setSelectedIndex:index];
}
- (void) sharedEmailProduct: (Product *) produto {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet: produto];
    } else  {
		NSString *feedbackMsg = @"Ops... impossível enviar e-mail por esse dispositivo!";
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:feedbackMsg];
    }
}

#pragma mark - E-mail Application
- (void)displayMailComposerSheet: (Product *)produto {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    
    [self.navigationController presentViewController:picker animated:YES completion:^{
        // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
    NSString *title = [NSString stringWithFormat:@"[Promonster] %@",produto.name];
	[picker setSubject:title];
	
	// Fill out the email body text
    NSString *site = @"http://www.promonster.com.br/promo/";
    site = [site stringByAppendingString:[NSString stringWithFormat:@"%@",produto.promo_id]];
	NSString *emailBody = [NSString stringWithFormat:@"Dá uma olhada nessa promo: \n%@ - R$ %@ \n\n %@ \n\n\nPromonster: Os preços mais f**** do polvo!",produto.name, produto.price, site];
    
    [picker setMessageBody:emailBody isHTML:NO];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^{

    NSString *feedbackMsg = @"";
    BOOL succes = YES;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled: {
			feedbackMsg = @"E-mail cancelado.";
            succes = NO;
			break;
        }
		case MFMailComposeResultSaved: {
			feedbackMsg = @"E-mail salvo.";
			break;
        }
		case MFMailComposeResultSent: {
			feedbackMsg = @"E-mail enviado.";
			break;
        }
		case MFMailComposeResultFailed: {
			feedbackMsg = @"Envio de e-mail falhou.";
            succes = NO;
			break;
        }
		default: {
			feedbackMsg = @"E-mail não enviado.";
            succes = NO;
			break;
        }
	}
    if (succes) {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleSuccess
                                         message:feedbackMsg];
    } else {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:feedbackMsg];
    }
        }];
}



@end
