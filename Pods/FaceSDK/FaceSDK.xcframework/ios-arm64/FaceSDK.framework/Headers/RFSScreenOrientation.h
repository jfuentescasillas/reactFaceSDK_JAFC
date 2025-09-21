//
//  RFSScreenOrientation.h
//  FaceSDK
//
//  Created by Dmitry Evglevsky on 26.03.25.
//  Copyright © 2025 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(ScreenOrientation)
typedef NS_OPTIONS(NSUInteger, RFSScreenOrientation) {
    RFSScreenOrientationPortrait    = 1 << 0,
    RFSScreenOrientationLandscape   = 1 << 1
};
