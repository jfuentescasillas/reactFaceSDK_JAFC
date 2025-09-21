//
//  UIColor+RGLCAdditions.h
//  RegulaCommon
//
//  Created by Dmitry Evglevsky on 16.02.23.
//  Copyright © 2023 Regula. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RGLCAdditions)

+ (UIColor *)rglc_colorFromHexString:(NSString *)hexString;
- (NSString *)rglc_asHexString;

@end

NS_ASSUME_NONNULL_END
