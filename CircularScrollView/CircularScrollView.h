//
//  CircularScrollView.h
//  SwipeTest
//
//  Created by Bhuiyan, Mamnun | Mamnun | SDTD on 3/29/13.
//  Copyright (c) 2013 Bhuiyan, Mamnun | Mamnun | SDTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic) CGSize pageSize;

-(void)addPage:(UIView*)page withTitle:(NSString*)title;

-(void)goToPageWithIndex:(NSUInteger)index;
-(void)goToPageWithTitle:(NSString*)title;

@end
