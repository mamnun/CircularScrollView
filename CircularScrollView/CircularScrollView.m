//
//  CircularScrollView.m
//  SwipeTest
//
//  Created by Bhuiyan, Mamnun | Mamnun | SDTD on 3/29/13.
//  Copyright (c) 2013 Bhuiyan, Mamnun | Mamnun | SDTD. All rights reserved.
//

#import "CircularScrollView.h"

@interface CircularScrollView (){
    NSMutableArray *pages;
    NSMutableArray *titles;
    UIView*firstDummy;
    UIView*lastDummy;
}


@end

@implementation CircularScrollView

@synthesize
pageSize = _pageSize;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
        self.pageSize = self.frame.size;
        NSLog(@"pagesize = %@", NSStringFromCGSize(self.frame.size));
        self.delegate = self;
        
        pages = [NSMutableArray array];
        titles = [NSMutableArray array];
    }
    return self;
}


-(void)addPage:(UIView*)page withTitle:(NSString*)title{
    [pages addObject:page];
    [titles addObject:title];
    [self reset];
}

-(void)reset{
    for (UIView*page in pages) {
        [page removeFromSuperview];
        [firstDummy removeFromSuperview];
        [lastDummy removeFromSuperview];
        firstDummy = nil;
        lastDummy = nil;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width * (pages.count+2), self.frame.size.height);
    
    
    //add the first dummy
    
    
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    firstDummy = (UIView*)[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[pages objectAtIndex:pages.count-1]]];
    firstDummy.frame = frame;
    [self addSubview:firstDummy];
    
    
    //add original pages
    for (int i=1; i<=pages.count; i++) {
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        
        UIView *view = (UIView*)[pages objectAtIndex:(i-1)];
        view.frame = frame;
        
        [self addSubview:view];
    }
    
    
    //add the last dummy
    frame.origin.x = self.frame.size.width * (pages.count+1);
    frame.origin.y = 0;
    frame.size = self.frame.size;
    lastDummy = (UIView*)[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[pages objectAtIndex:0]]];
    lastDummy.frame = frame;
    [self addSubview:lastDummy];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)sender {
////    NSLog(@"content offset %f", self.scrollView.contentOffset.x);
////    // Update the page when more than 50% of the previous/next page is visible
////    CGFloat pageWidth = self.frame.size.width;
////    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
////    self.pageControl.currentPage = page;
//}

//- (void)sc

-(void)goToPageWithTitle:(NSString*)title{
    int index = [titles indexOfObject:title];
    NSLog(@"index = %d", index);
    
    [self goToPageWithIndex:index];
}

-(void)goToPageWithIndex:(NSUInteger)index{
    if (index>=pages.count) {
        return;
    }
    
    int scrollOffset = index*self.pageSize.width;
    //int page = floor((self.contentOffset.x - self.pageSize.width / 2) / self.pageSize.width) + 1;
    //int targetPage = floor(scrollOffset / self.pageSize.width) + 1;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        //animation 1
        for (UIView*page in pages) {
            [page setAlpha:0.0];
        }
        
        [firstDummy setAlpha:0.0];
        [lastDummy setAlpha:0.0];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.0 animations:^{
            // animation 2
            [self setContentOffset:CGPointMake(scrollOffset, 0) animated:NO];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.5 animations:^{
                // animation 3
                for (UIView*page in pages) {
                    [page setAlpha:1.0];
                }
                
                [firstDummy setAlpha:1.0];
                [lastDummy setAlpha:1.0];
            }];
        }];
    }];
    
    
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    
    [UIView commitAnimations];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    // The key is repositioning without animation
    
    CGFloat lastmarker = self.contentSize.width-self.frame.size.width;
    
    if (self.contentOffset.x == 0) {
        [self setContentOffset:CGPointMake(lastmarker-self.frame.size.width, 0) animated:NO];
    }
    else if (self.contentOffset.x == lastmarker) {
        [self scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
}
@end
