//
//  UMMoreLoadingView.h
//  TaxiPassenger
//
//  Created by HM on 2014. 12. 26..
//  Copyright (c) 2014년 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMMoreLoadingView;

@protocol UMMoreLoadingViewDelegate;

/**
 공통 더로딩뷰
 */
@interface UMMoreLoadingView : UIView

/**
 델리게이트
 */
@property (assign, nonatomic) id <UMMoreLoadingViewDelegate> delegate;

/**
 visible 여부
 */
@property (assign, nonatomic, getter = isVisible) BOOL visible;
/**
 로딩 enable 여부
 */
@property (assign, nonatomic, getter = isEnableLoading) BOOL enableLoading;

/**
 더로딩을 끝낸다.
 */
- (void)endMoreLoading;

@end

@protocol UMMoreLoadingViewDelegate <NSObject>

@required
/**
 로딩이 시작될때 호출, 해당 함수에서 더로딩 로직을 처리한다.

 @param moreLoadingView 자기자신
 */
- (void)didBeginLoadingUMMoreLoadingView:(UMMoreLoadingView *)moreLoadingView;

@end

UIKIT_EXTERN CGFloat const UMMoreLoadingViewHeight;
UIKIT_EXTERN CGFloat const UMMoreLoadingViewBottomMargin;
