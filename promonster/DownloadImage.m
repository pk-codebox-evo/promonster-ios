//
//  DownloadImage.m
//  uGuide UFOP
//
//  Created by Conrado on 15/01/14.
//  Copyright (c) 2014 Conrado. All rights reserved.
//

#import "DownloadImage.h"
#import "AppDelegate.h"

@implementation DownloadImage {
    AppDelegate *appDelegate;
}
@synthesize url;

#define LOG_ON      NO
#define CACHE_ON    YES
#define kAnimation 0.55

#pragma mark - ciclo de vida
// Called if the object is instantiated by the code
- (id)initWithFrame:(CGRect)rect {
    if (self = [super initWithFrame:rect]) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        progress.color = [UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f];

        [self addSubview:progress];
    }
    return self;
}
// Called if the object is instantiated by the xib file
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        progress.color = [UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f];
        [self addSubview:progress];
    }
    return self;
}
// Sets the layout
- (void)layoutSubviews {
    [super layoutSubviews];
    // Initializes the progress in the center
    progress.center = [self convertPoint:self.center fromView:self.superview];
}

// Overwrites the SetUrl to download in background
- (void)setUrl:(NSString *)urlParam {
    if ([urlParam length] == 0) {
        url = nil;
        self.image = nil;
    }
    else if (urlParam != self.url) {
        url = [urlParam copy];
        self.image = nil;
        
        if (!queue) {
            queue = [[NSOperationQueue alloc] init];
        }
        
        [queue cancelAllOperations];
        
        // Starts animation Spinner
        [progress startAnimating];
        
        // Triggers the download in a NSOperation
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImg) object:nil];
        [queue addOperation:operation];
    }
}

#pragma mark - download in background
// Download image
- (void)downloadImg {
    // Creates the file path to save the img in cache
    NSString* file = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    file = [file stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
    file = [file stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    file = [@"/Documents/" stringByAppendingString:file];
    file = [NSHomeDirectory() stringByAppendingString:[NSString stringWithString:file]];
   
    if(LOG_ON && CACHE_ON) {
        NSLog(@"Arquivo img %@", file);
    }
    
    // If there Cached
    if(CACHE_ON && [[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        // Reads the image cache
        NSData* data = [NSData dataWithContentsOfFile:file];
        
        if(data)
        {
            if(LOG_ON) {
                NSLog(@"Encontrado no cache %@ " , url);
            }
            UIImage *img = [[UIImage alloc] initWithData:data];
            // Atualiza o UIImageView com a imagem carregada do cache
            [self performSelectorOnMainThread:@selector(showImg:) withObject:img waitUntilDone:YES];
            
            return;
        }
    }
    
    // Otherwise Download (This method is executed in another thread)
    if(LOG_ON) {
        NSLog(@"Download URL %@", url);
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    // Saved in Cache
    if(CACHE_ON) {
        if(LOG_ON) {
            NSLog(@"Salvo no cache URL %@", url);
        }
        [data writeToFile:file atomically:YES];
    }
    
    if (!img) {
       // img = [UIImage imageNamed:@"no_img"]; // link da img com problema
    } else {
        // tem imagem
    }
    
    // Once downloaded, updated UIImageView on the main thread
    [self performSelectorOnMainThread:@selector(showImg:) withObject:img waitUntilDone:YES];
    // frees memory
}
// Updated UIImageView with the result
- (void)showImg:(UIImage *)imagem {
    // Updated UIImage object inside UIImageView
    self.image = imagem;
    self.alpha = 1;
    
    // Terminates animation Spinner
    [progress stopAnimating];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - dealloc

- (void)dealloc {
    [progress removeFromSuperview];
}

- (void) arredondar {
    UIColor *color = [UIColor blackColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 8;
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 2;
    self.layer.shadowRadius = 2.0;
    self.clipsToBounds = NO;

}
- (void) shadowImg {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 2;
    self.layer.shadowRadius = 2.0;
    self.clipsToBounds = NO;
}
@end
