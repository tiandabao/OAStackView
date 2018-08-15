//
//  OAStackView+CustomSpace.m
//  OAStackView_Example
//
//  Created by dabao on 2018/8/15.
//  Copyright © 2018年 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView+CustomSpace.h"
#import <objc/runtime.h>

@implementation OAStackView (CustomSpace)
static char kAssociatedObjectKey_CustomSpaces;
- (void)setCustomSpaces:(NSMapTable *)argv {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_CustomSpaces, argv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMapTable *)customSpaces {
    NSMapTable *customSpaces = objc_getAssociatedObject(self, &kAssociatedObjectKey_CustomSpaces);
    if (customSpaces == nil) {
        [self setCustomSpaces:[NSMapTable weakToStrongObjectsMapTable]];
    }
    return customSpaces;
}

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview
{
    [self.customSpaces setObject:arrangedSubview forKey:@(spacing)];
    
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
