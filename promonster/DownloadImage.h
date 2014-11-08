//
//  DownloadImage.h
//  uGuide UFOP
//
//  Created by Conrado on 15/01/14.
//  Copyright (c) 2014 Conrado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadImage : UIImageView {
    NSString *url;
    UIActivityIndicatorView *progress;
    NSOperationQueue *queue;
}
@property (nonatomic, copy) NSString *url;
- (void) arredondar;
- (void) shadowImg;
@end
