//
//  TipButton.h
//  sfhaitao
//
//  Created by 肖信波 on 15/6/27.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TipButtonTipStyle) {
    TipButtonTipStyleNormal = 0,
    TipButtonTipStyleSmall = 1,
    TipButtonTipStyleAlignmentRight = 2,
};

@interface TipButton : UIButton
{
    UILabel *_tipLabel;
    BOOL _animate;
}

@property (nonatomic, assign) NSInteger tipValue;
@property (nonatomic, copy) UIColor *tipBackgroundColor;
@property (nonatomic, copy) UIColor *tipTitleColor;
@property (nonatomic, assign) TipButtonTipStyle tipStyle;

@property (nonatomic, assign) UIEdgeInsets touchedEdgeInsets;

- (void)setTipValue:(NSInteger)tipValue animate:(BOOL)animate;

@end
