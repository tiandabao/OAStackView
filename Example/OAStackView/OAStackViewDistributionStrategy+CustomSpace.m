//
//  OAStackViewDistributionStrategy+CustomSpace.m
//  OAStackView_Example
//
//  Created by dabao on 2018/8/15.
//  Copyright © 2018年 Omar Abdelhafith. All rights reserved.
//

#import "OAStackViewDistributionStrategy+CustomSpace.h"
#import "OAStackView+CustomSpace.h"

@interface OAStackViewDistributionStrategy ()
- (NSMutableArray *)constraints;
- (NSString *)currentAxisString;
- (NSString *)symbolicSpacingRelation;
- (OAStackView *)stackView;
@end

@implementation OAStackViewDistributionStrategy (CustomSpace)
- (void)alignMiddleView:(UIView*)view afterView:(UIView*)previousView {
    
    NSLog(@"view: %@ \n previousView:%@", view, previousView);
    
    CGFloat spacing = self.stackView.spacing;
    
    CGFloat customSpace = [[self.stackView.customSpaces objectForKey:previousView] doubleValue];
    
    if (customSpace > 0) {
        spacing = customSpace;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@:[previousView]-(%@%f)-[view]",
                     [self currentAxisString],
                     [self symbolicSpacingRelation],
                     spacing];
    
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:str
                                                           options:0
                                                           metrics:nil
                                                             views:NSDictionaryOfVariableBindings(view, previousView)];
    
    [self.constraints addObjectsFromArray:arr];
    [self.stackView addConstraints:arr];
}


@end
