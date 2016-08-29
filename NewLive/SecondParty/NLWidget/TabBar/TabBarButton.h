//
//  TabBarButton.h
//  sfhaitao
//
//  Created by 肖信波 on 16/1/22.
//
//

#import <UIKit/UIKit.h>
#import "TipButton.h"

@interface TabBarButton : TipButton
{
    UIImageView *_imgView;
    UILabel *_titleLabel;

    UIImage *_normalImage;
    UIImage *_highlightImage;
    UIImage *_disabelImage;

    NSString *_normalTitle;
    NSString *_highlightTitle;
    NSString *_disabelTitle;
    
    UIColor *_normalColor;
    UIColor *_highlightColor;
    UIColor *_disabelColor;
}

@property (nonatomic, assign) BOOL isBigImage;
@property (nonatomic, assign) CGFloat titleMarginBottom;
@property (nonatomic, assign) CGFloat imgMarginBottom;

@property (nonatomic, assign) BOOL isNetworkForNormal;
@property (nonatomic, assign) BOOL isNetworkForHighlight;

@end
