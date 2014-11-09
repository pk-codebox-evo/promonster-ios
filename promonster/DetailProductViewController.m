//
//  DetailProductViewController.m
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "DetailProductViewController.h"
#import "CSNotificationView.h"
#import "DetailCell.h"
#import "ForumCell.h"
#import "TipCell.h"
#import "infoCell.h"
#import "ProsConsCell.h"
#import "SharedCell.h"
#import "DejalActivityView.h"
#import "Shared.h"
#import "CCAux.h"
#import <UAAppReviewManager.h>
@interface DetailProductViewController ()

@end

@implementation DetailProductViewController
@synthesize produto, service,promo_id, itens, tableView;
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
    
    if ([CCAux setContEvent] ==3) {
        [UAAppReviewManager showPrompt];
    }
    _contItens = 0;
    contProsTemp = 0;
    contConsTemp = 0;
    tableView.hidden = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Baixando info.."];

    [self download];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Detail Product Screen";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebService
- (void) download {
    if (!service) {
        service = [[WebService alloc] init];
    }
    if (_showAct) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Baixando info.."];
        _showAct = NO;
    }
    [service getProductDetailWithPromo_ID:promo_id withDelegate:self];
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itens count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *item = [[itens objectAtIndex:indexPath.row] mutableCopy];
    NSString *name = [item objectForKey:@"name"];
    
    if ([name isEqualToString:@"DetailCell"]) {
        static NSString *CellIdentifier = @"DetailCell";
        DetailCell *cell = (DetailCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        cell.delegate = self;
        [cell.name setTitle: produto.name forState:UIControlStateNormal];
        cell.price.text = [NSString stringWithFormat:@"R$ %@",produto.price];
        cell.date.text = produto.date;
        cell.img_url.url = produto.img_url;
        cell.source.text = produto.source;
        cell.promo_id = produto.promo_id;
        cell.link = produto.promo_url;
        cell.contFav.text = [NSString stringWithFormat:@"%@",produto.favorites_count];
        
        cell.price_mean = [NSString stringWithFormat:@"R$ %@",produto.price_mean];
        [cell setStrikeLine];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f];
        [cell setSelectedBackgroundView:bgColorView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if ([name isEqualToString:@"TipCell"]){
        static NSString *CellIdentifier = @"TipCell";
        TipCell *cell = (TipCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TipCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        [cell.tip setTitle: produto.tip forState:UIControlStateNormal];
  
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f];
        [cell setSelectedBackgroundView:bgColorView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([name isEqualToString:@"ForumCell"]) {
        static NSString *CellIdentifier = @"ForumCell";
        ForumCell *cell = (ForumCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        cell.delegate = self;
        cell.forum_url = produto.forum_url;
        cell.promo_url = produto.promo_url;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if ([name isEqualToString:@"ProsConsCell"]){
        static NSString *CellIdentifier = @"ProsConsCell";
        ProsConsCell *cell = (ProsConsCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProsConsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([name isEqualToString:@"infoCell"]){
        static NSString *CellIdentifier = @"infoCell";
        infoCell *cell = (infoCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"infoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        NSArray *contra = produto.cons;
        if (contConsTemp<_contCons) {
            cell.contText.text = [NSString stringWithFormat:@"- %@",[contra objectAtIndex:contConsTemp]];
            contConsTemp++;
        }
        NSArray *pros = produto.pros;
        if (contProsTemp<_contPros) {
            cell.proText.text = [NSString stringWithFormat:@"- %@",[pros objectAtIndex:contProsTemp]];
            contProsTemp++;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([name isEqualToString:@"SharedCell"]){
        static NSString *CellIdentifier = @"SharedCell";
        SharedCell *cell = (SharedCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SharedCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
      
        cell.delegate = self;
        cell.promo_id = promo_id;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"errror";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    NSDictionary *item = [itens objectAtIndex:indexPath.row];
    float value = [[item objectForKey:@"height"] floatValue];
    return value;
}
- (void) sharedEmailProduct {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    } else  {
        
		NSString *feedbackMsg = @"Ops... impossível enviar e-mail por esse dispositivo!";
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:feedbackMsg];
    }
}

#pragma mark - E-mail Application
- (void)displayMailComposerSheet
{
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
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSString *feedbackMsg = @"";
        BOOL succes = YES;
        // Notifies users about errors associated with the interface
        switch (result) {
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
#pragma mark - UIActionSheet
- (void) showActionSheet{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancelar"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook",@"Twitter", @"E-mail",@"Copiar Link", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Shared *share = [[Shared alloc] init];
    share.delegate = self;
    
    switch (buttonIndex) {
        case 0: {
            [share sharedFacebookProduct:produto];
            break;
        }
        case 1:  {
            [share sharedTwitterProduct:produto];
            break;
        }
        case 2: {
            [self sharedEmailProduct];
            break;
        }
        case 3:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *promoID = [NSString stringWithFormat:@"%@",produto.promo_id];
            NSString *site = @"www.promonster.com.br/promo/";
            site = [site stringByAppendingString:promoID];
            pasteboard.string = site;
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleSuccess
                                             message:@" Copiado para área de transferencia"];
            break;
        }
        default:
            break;
    }
}

@end
