//
//  OAStackView+CustomSpace.h
//  OAStackView_Example
//
//  Created by dabao on 2018/8/15.
//  Copyright © 2018年 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView.h"

@interface OAStackView (CustomSpace)

@property (nonatomic, readonly) NSMapTable *customSpaces;

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;
@end
