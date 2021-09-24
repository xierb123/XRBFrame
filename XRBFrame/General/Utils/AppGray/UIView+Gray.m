//
//  UIView+Gray.m
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

#import "UIView+Gray.h"

@implementation UIView (Gray)

- (void)changeAppGray:(NSString *)color andClass:(NSString *)name andKey:(NSString *)key {
    if (color == nil || color.length <=0 || name == nil || name.length <=0 || key == nil || key.length <=0) {
        return;
    }
    CIFilter *filter = [NSClassFromString(name) filterWithName:color];
    [filter setValue:@0 forKey:key];
    self.layer.filters = @[filter];
}

@end
