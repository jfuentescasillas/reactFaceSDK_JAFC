//
//  RFSMatchFacesConfiguration.h
//  FaceSDK
//
//  Created by Dmitry Evglevsky on 27.11.23.
//  Copyright © 2023 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FaceSDK/RFSBaseConfiguration.h>

typedef NS_CLOSED_ENUM(NSInteger, RFSProcessingMode) {
    RFSProcessingModeOnline,
    RFSProcessingModeOffline
} NS_SWIFT_NAME(FaceSDK.ProcessingMode);

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MatchFacesConfigurationBuilder)
@interface RFSMatchFacesConfigurationBuilder: RFSBaseConfigurationBuilder
@end

NS_SWIFT_NAME(MatchFacesConfiguration)
@interface RFSMatchFacesConfiguration : RFSBaseConfiguration<RFSMatchFacesConfigurationBuilder *> <NSObject>

@property(readonly, nonatomic, assign) RFSProcessingMode processingMode;
/// Defines whether the match face request sends a location of a device. Defaults to `true`.
/// When set to `true` the liveness request to web service will contain the `location` object within the json `metadata` object.
/// The location is used only when permissions are granted and the location is available.
@property(readonly, nonatomic, assign, getter=isLocationTrackingEnabled) BOOL locationTrackingEnabled;

@end

@interface RFSMatchFacesConfigurationBuilder ()

@property(readwrite, nonatomic, assign) RFSProcessingMode processingMode;
/// @see RFSMatchFacesConfiguration.locationTrackingEnabled.
@property(readwrite, nonatomic, assign, getter=isLocationTrackingEnabled) BOOL locationTrackingEnabled;

@end

NS_ASSUME_NONNULL_END
