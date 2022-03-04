//
//  UMMoreLoadingView.m
//  TaxiPassenger
//
//  Created by HM on 2014. 12. 26..
//  Copyright (c) 2014년 HM. All rights reserved.
//

#import "UMMoreLoadingView.h"

CGFloat const UMMoreLoadingViewHeight = 0;
CGFloat const UMMoreLoadingViewBottomMargin = 20;

@interface UMMoreLoadingView()

@property (assign, nonatomic, getter=isVisibleKVO)	BOOL visibleKVO;
@property (assign, nonatomic, getter=isLoading)		BOOL loading;

/**
 UI를 구성한다.
 */
- (void)__defaultLayout;

/**
 로딩을 시작한다.
 */
- (void)__beginLoading;
/**
 로딩을 끝낸다.
 */
- (void)__endLoading;

@end

@implementation UMMoreLoadingView

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self == nil) return nil;
	
	[self __defaultLayout];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
	[self __defaultLayout];
	
	return self;
}

- (void)__defaultLayout
{
	self.hidden = YES;
}

- (void)removeFromSuperview
{
	[self __endLoading];
	self.visible = NO;
	
	[super removeFromSuperview];
}

#pragma mark - Setter/Getter

- (void)setVisible:(BOOL)visible
{
	if (_visible == visible) {
		return;
	}
	
	_visible = visible;
	
	self.hidden = !self.isVisible;
	
	self.visibleKVO = self.isVisible;
}

- (void)setVisibleKVO:(BOOL)visibleKVO
{
	if (_visibleKVO == visibleKVO) {
		return;
	}
	
	_visibleKVO = visibleKVO;
	
	if ([self.superview isKindOfClass:[UIScrollView class]]) {
		UIScrollView *scrollView_ = (UIScrollView *)self.superview;
		
		if (self.visibleKVO) {
			[scrollView_ addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
		}
		else {
			[scrollView_ removeObserver:self forKeyPath:@"contentOffset"];
		}
	}
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScrollView *)scrollView change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"contentOffset"]) {
		if (self.isLoading) {
			return;
		}
		
		if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
			if (self.visible) {
				[self __beginLoading];
			}
		}
		else {
			self.enableLoading = YES;
		}
	}
}

#pragma mark - Method

- (void)__beginLoading
{
	if (self.isEnableLoading == NO) {
		return;
	}
	
	if (self.isLoading) {
		return;
	}
	
	self.loading = YES;
	
	
	if ([self.delegate respondsToSelector:@selector(didBeginLoadingUMMoreLoadingView:)]) {
		[self.delegate didBeginLoadingUMMoreLoadingView:self];
	}
}

- (void)__endLoading
{
	if (self.isLoading == NO) {
		return;
	}
	
	self.loading = NO;
	self.enableLoading = NO;
}

- (void)endMoreLoading
{
	[self __endLoading];
}

@end
