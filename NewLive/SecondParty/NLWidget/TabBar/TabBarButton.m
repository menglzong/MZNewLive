//
//  TabBarButton.m
//  sfhaitao
//
//  Created by 肖信波 on 16/1/22.
//
//

#import "TabBarButton.h"

@implementation TabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        self.titleMarginBottom = 5;
        self.imgMarginBottom = 2;
        
        [self addSubview:_imgView];
        [self addSubview:_titleLabel];
        
        [self bringSubviewToFront:_tipLabel];
    }
    
    return self;
}



- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (UILabel *)titleLabel
{
    return _titleLabel;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateHighlighted:
            _highlightTitle = title;
            break;
        case UIControlStateDisabled:
            _disabelTitle = title;
            break;
        default:
            _normalTitle = title;
            break;
    }
    
    [self setNeedsLayout];
}

- (NSString *)titleForState:(UIControlState)state
{
    NSString *title = @"";
    switch (state) {
        case UIControlStateHighlighted:
            title = _highlightTitle;
            break;
        case UIControlStateDisabled:
            title = _disabelTitle;
            break;
        default:
            title = _normalTitle;
            break;
    }
    
    return title;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateHighlighted:
            _highlightImage = image;
            break;
        case UIControlStateDisabled:
            _disabelImage = image;
            break;
        default:
            _normalImage = image;
            break;
    }
    
    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateHighlighted:
            _highlightColor = color;
            break;
        case UIControlStateDisabled:
            _disabelColor = color;
            break;
        default:
            _normalColor = color;
            break;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    BOOL isNetwork;
    // Tab bar 只有居中一种情况
    if (!self.isEnabled) {
        isNetwork = self.isNetworkForHighlight;
        _imgView.image = _disabelImage ? _disabelImage : _normalImage;
        _titleLabel.text = _disabelTitle ? _disabelTitle : _normalTitle;
        _titleLabel.textColor = _disabelColor ? _disabelColor : _normalColor;
    } else if (self.isHighlighted) {
        isNetwork = self.isNetworkForHighlight;
        _imgView.image = _highlightImage ? _highlightImage : _normalImage;
        _titleLabel.text = _highlightTitle ? _highlightTitle : _normalTitle;
        _titleLabel.textColor = _disabelColor ? _disabelColor : _normalColor;
    } else {
        isNetwork = self.isNetworkForNormal;
        _imgView.image = _normalImage;
        _titleLabel.text = _normalTitle;
        _titleLabel.textColor = _normalColor;
    }

    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat imgHeight = isNetwork ? _imgView.image.size.height / scale : _imgView.image.size.height;
    CGFloat imgWidth = isNetwork ? _imgView.image.size.width / scale : _imgView.image.size.width;
    
    CGFloat txtHeight = 0;
    CGFloat txtWidth = 0;
    
    if (![NSString sf_isBlankString:_titleLabel.text]) {
        CGSize size = [NSString sf_sizeForString:_titleLabel.text font:_titleLabel.font maxSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        txtWidth = size.width;
        txtHeight = size.height;
    }
    
    _imgView.hidden = imgHeight == 0;
    _titleLabel.hidden = txtHeight == 0;


    _titleLabel.frame = CGRectMake((self.frame.size.width - txtWidth) / 2, self.frame.size.height - self.titleMarginBottom - txtHeight, txtWidth, txtHeight);

    if (imgHeight == 0) {
        // 无图 居中
        _titleLabel.center = CGPointMake(self.width / 2, self.height / 2);
    }
    
    CGFloat marginBottom = txtHeight == 0 ?  self.imgMarginBottom : (self.frame.size.height - CGRectGetMinY(_titleLabel.frame)) + self.imgMarginBottom;

    _imgView.frame = CGRectMake((self.frame.size.width - imgWidth) / 2, self.frame.size.height - marginBottom - imgHeight, imgWidth, imgHeight);
    
    if (_imgView.image) {
        [_tipLabel.layer setCornerRadius:_tipLabel.frame.size.width / 2];
        
        CGFloat offsetY = self.tipStyle == TipButtonTipStyleNormal ? 5 : 5;
        CGFloat offsetX = self.tipStyle == TipButtonTipStyleNormal ? 0 : -3;
        
        CGFloat x = 0;
        CGFloat y = 0;
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentRight:
                x = self.frame.size.width + offsetX;
                y = _imgView.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                x = CGRectGetMaxX(_imgView.frame) + offsetX;
                y = _imgView.frame.origin.y + offsetY;
                break;
            case UIControlContentHorizontalAlignmentLeft:
                x = CGRectGetMaxX(_imgView.frame) + offsetX;
                y = _imgView.frame.origin.y + offsetY;
                break;
            default:
                break;
        }
        
        _tipLabel.center = CGPointMake(x, y);
    } else {
        // TODO 没有图片 只有文字的处理 要做参考积基类
    }
}

@end
