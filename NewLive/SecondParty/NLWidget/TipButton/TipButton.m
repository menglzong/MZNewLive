//
//  TipButton.m
//  sfhaitao
//
//  Created by 肖信波 on 15/6/27.
//
//

#import "TipButton.h"

#define kTipWidth 15
#define kPointWidth (9)

@implementation TipButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTipWidth, kTipWidth)];
        _tipLabel.font = Small_Font;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [_tipLabel.layer setMasksToBounds:YES];
        
        [self setTipBackgroundColor:COLOR_APP_STYLE];
        [self setTipTitleColor:[UIColor whiteColor]];
        
        [self addSubview:_tipLabel];
        
        _tipLabel.hidden = YES;
    }
    
    return self;
}

//@property (nonatomic, copy) UIColor *tipBackgroundColor;
//@property (nonatomic, copy) UIColor *tipTitleColor;

- (void)setTipBackgroundColor:(UIColor *)tipBackgroundColor
{
    _tipBackgroundColor = tipBackgroundColor;
    _tipLabel.backgroundColor = tipBackgroundColor;
}

- (void)setTipTitleColor:(UIColor *)tipTitleColor
{
    _tipTitleColor = tipTitleColor;
    _tipLabel.textColor = tipTitleColor;
}

- (void)setTipStyle:(TipButtonTipStyle)tipStyle
{
    _tipStyle = tipStyle;
    switch (tipStyle) {
        case TipButtonTipStyleSmall:
        {
            _tipLabel.frame = CGRectMake(0, 0, kPointWidth, kPointWidth);
            _tipLabel.text = @"";
            [self setTipBackgroundColor:COLOR_APP_STYLE];
            [self setTipTitleColor:[UIColor whiteColor]];
            [_tipLabel.layer setBorderColor:SF_COLOR_WHITE.CGColor];
            [_tipLabel.layer setBorderWidth:1];
            [_tipLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
            break;
        }
        case TipButtonTipStyleNormal:
        {
            _tipLabel.frame = CGRectMake(0, 0, kTipWidth, kTipWidth);
            [self setTipValue:_tipValue];
            
            [self setTipBackgroundColor:COLOR_APP_STYLE];
            [self setTipTitleColor:[UIColor whiteColor]];
            [_tipLabel.layer setBorderColor:SF_COLOR_WHITE.CGColor];
            [_tipLabel.layer setBorderWidth:1];
            [_tipLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
            break;
        }
        case TipButtonTipStyleAlignmentRight:
        {
            _tipLabel.frame = CGRectMake(0, 0, kTipWidth, kTipWidth);
            [self setTipValue:_tipValue];
            [_tipLabel.layer setBorderWidth:0];
            [self setTipBackgroundColor:COLOR_APP_STYLE];
            [self setTipTitleColor:[UIColor whiteColor]];
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (void)setTipValue:(NSInteger)tipValue
{
    [self setTipValue:tipValue animate:NO];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    [super setTitleEdgeInsets:titleEdgeInsets];
    [self setNeedsLayout];
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    [super setImageEdgeInsets:imageEdgeInsets];
    [self setNeedsDisplay];
}

- (void)setTipValue:(NSInteger)tipValue animate:(BOOL)animate
{
    tipValue = MAX(0, tipValue);
    if (self.tipStyle != TipButtonTipStyleSmall) {
        _tipLabel.text = [NSString stringWithFormat:@"%@", tipValue > 99 ? @"99+" : @(tipValue)];
    }
    
    if (tipValue > 99) {
        _tipLabel.font = Smallest_Font;
    } else {
        _tipLabel.font = Small_Font;
    }
    
    if (_tipValue != tipValue || self.tipStyle == TipButtonTipStyleAlignmentRight) {
        _tipValue = tipValue;
        if (self.tipStyle == TipButtonTipStyleAlignmentRight) {
            _tipLabel.hidden = NO;
            if (_tipValue == 0) {
                [self setTipBackgroundColor:COLOR_NORMAL_SUB_INFOR];
            }else{
                [self setTipBackgroundColor:COLOR_APP_STYLE];
            }
            [self setNeedsLayout];
        }else{
            _tipLabel.hidden = _tipValue == 0;
            
            if (!animate || _animate) {
                return;
            }
            CGRect frame = _tipLabel.frame;
            _animate = YES;
            [UIView beginAnimations:@"valueChange" context:nil];
            [UIView animateWithDuration:0.2 animations:^{
                CGRect mFrame = _tipLabel.frame;
                mFrame.origin.y = mFrame.origin.y - 20;
                _tipLabel.frame = mFrame;
            } completion:^(BOOL finished) {
                [UIView beginAnimations:@"valueChange" context:nil];
                [UIView animateWithDuration:0.4 animations:^{
                    CGRect mFrame = _tipLabel.frame;
                    mFrame.origin.y = mFrame.origin.y + 10;
                    _tipLabel.frame = mFrame;
                } completion:^(BOOL finished) {
                    [UIView beginAnimations:@"valueChange" context:nil];
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect mFrame = _tipLabel.frame;
                        mFrame.origin.y = frame.origin.y;
                        _tipLabel.frame = mFrame;
                    } completion:^(BOOL finished) {
                        _animate = NO;
                        [self setNeedsLayout];
                    }];
                    [UIView commitAnimations];
                }];
                [UIView commitAnimations];
            }];
            
            [UIView commitAnimations];

        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_tipLabel.layer setCornerRadius:_tipLabel.frame.size.width / 2];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat offsetY = 0;
    CGFloat offsetX = 0;
    if (self.imageView.image) {
        if (self.tipStyle == TipButtonTipStyleAlignmentRight) {
            offsetX = kTipWidth / 2;
        }else{
            offsetY = 5;
            offsetX = self.tipStyle == TipButtonTipStyleNormal ? 0 : -3;
        }
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentRight:
                x = self.frame.size.width + offsetX;
                y = self.imageView.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                x = CGRectGetMaxX(self.imageView.frame) + offsetX;
                y = self.imageView.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentLeft:
                x = CGRectGetMaxX(self.imageView.frame) + offsetX;
                y = self.imageView.frame.origin.y + offsetY;
                break;
            default:
                break;
        }
        
        _tipLabel.center = CGPointMake(x, y = self.tipStyle == TipButtonTipStyleAlignmentRight ? self.frame.size.height/2 : y);
    } else {
        if (self.tipStyle == TipButtonTipStyleAlignmentRight) {
            offsetX = kTipWidth / 2 + 2;
        }else{
            offsetY = 2;
            offsetX = self.tipStyle == TipButtonTipStyleNormal ? 8 : 3;
        }
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentRight:
                x = self.frame.size.width + offsetX;
                y = self.titleLabel.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                x = CGRectGetMaxX(self.titleLabel.frame) + offsetX;
                y = self.titleLabel.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentLeft:
                x = CGRectGetMaxX(self.titleLabel.frame) + offsetX;
                y = self.titleLabel.frame.origin.y + offsetY;
                break;
            default:
                break;
        }
        
        _tipLabel.center = CGPointMake(x, y = self.tipStyle == TipButtonTipStyleAlignmentRight ? self.frame.size.height/2 : y);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    BOOL result = [super pointInside:point withEvent:event];
    
    if (result) {
        return result;
    } else {
        CGRect rect = UIEdgeInsetsInsetRect(self.bounds, self.touchedEdgeInsets);
        return CGRectContainsPoint(rect, point);
    }
    
    return YES;
}

@end
