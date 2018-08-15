//
//  OAStackView+CustomSpace.m
//  OAStackView_Example
//
//  Created by dabao on 2018/8/15.
//  Copyright © 2018年 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView+CustomSpace.h"
#import "OAStackViewDistributionStrategy.h"
#import <objc/message.h>

@interface OAStackView ()
@property (nonatomic, readonly) NSMapTable *customSpaces;
@end

@implementation OAStackView (CustomSpace)
static char kAssociatedObjectKey_CustomSpaces;
- (void)setCustomSpaces:(NSMapTable *)argv {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_CustomSpaces, argv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMapTable *)customSpaces {
    NSMapTable *customSpaces = objc_getAssociatedObject(self, &kAssociatedObjectKey_CustomSpaces);
    if (customSpaces == nil) {
        [self setCustomSpaces:[NSMapTable strongToWeakObjectsMapTable]];
    }
    return customSpaces;
}

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview
{
    [self.customSpaces setObject:@(spacing) forKey:arrangedSubview];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        BOOL isWidthOrHeight =
        (constraint.firstAttribute == NSLayoutAttributeWidth) ||
        (constraint.firstAttribute == NSLayoutAttributeHeight);
        
        if ([self.subviews containsObject:constraint.firstItem] &&
            [self.subviews containsObject:constraint.secondItem] &&
            !isWidthOrHeight) {
            
            if (constraint.secondItem == arrangedSubview) {
                constraint.constant = spacing;
            }
        }
    }
}
@end

@interface OAStackViewDistributionStrategy ()
/// 这些都是原类的，这里只是重新申明
/// 调用还会是原类里面的
@property (nonatomic, strong) OAStackView *stackView;
@property (nonatomic, strong) NSMutableArray *constraints;
- (NSString *)currentAxisString;
- (NSString *)symbolicSpacingRelation;
@end

@implementation OAStackViewDistributionStrategy (CustomSpace)
- (void)alignMiddleView:(UIView*)view afterView:(UIView*)previousView {
    CGFloat spacing = self.stackView.spacing;
    CGFloat customSpace = [[self.stackView.customSpaces objectForKey:previousView] floatValue];
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
