//
// Created by Sergey Ilyevsky on 11/19/14.
// Copyright (c) 2014 DeDoCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROXFreeze.h"
#import "ROXFetcherResult.h"
#import "ROXReportingValue.h"
#import "ROXDynamicPropertiesRule.h"
#import "ROXNetworkConfigurationsOptions.h"

/**
 :nodoc:
 */

typedef void (^ROXConfigurationFetchedHandler)(ROXFetcherResult* _Nonnull result);
typedef void (^ROXImpressionHandler)(ROXReportingValue* _Nonnull value);

/**
 Error codes for configuration-related errors.
 */
typedef NS_ENUM(NSInteger, ROXConfigurationError) {
    /// Cached configuration has mismatched appKey
    ROXConfigurationErrorAppKeyMismatch = 1001,
    /// Cached configuration is corrupted or invalid
    ROXConfigurationErrorCacheCorrupted = 1002,
    /// Network fetch failed
    ROXConfigurationErrorNetworkFailed = 1003,
    /// Configuration JSON is invalid
    ROXConfigurationErrorInvalidJSON = 1004
};

/**
 Error domain for ROX configuration errors.
 */
extern NSErrorDomain const ROXConfigurationErrorDomain;

/**
 Block type for configuration error notifications.
 @param error The error that occurred during configuration loading
 */
typedef void (^ROXConfigurationErrorHandler)(NSError* _Nonnull error);

/**
 Block type for cache loaded notifications.
 @param appKey The appKey of the loaded cache
 @param timestamp The timestamp when the cache was created
 @param sdkVersion The SDK version that created the cache
 */
typedef void (^ROXCacheLoadedHandler)(NSString* _Nonnull appKey, NSDate* _Nullable timestamp, NSString* _Nullable sdkVersion);

/**
 Block type for cache cleared notifications.
 @param appKey The appKey whose cache was cleared
 @param reason The reason why cache was cleared (e.g., "appKey mismatch", "expired", "corrupted")
 */
typedef void (^ROXCacheClearedHandler)(NSString* _Nonnull appKey, NSString* _Nonnull reason);

/**
 Block type for network fetch started notifications.
 @param appKey The appKey being fetched
 @param fetchSource The source that triggered the fetch (e.g., "setup", "foreground", "push")
 */
typedef void (^ROXNetworkFetchStartedHandler)(NSString* _Nonnull appKey, NSString* _Nullable fetchSource);

/**
 Block type for network fetch completed notifications.
 @param appKey The appKey that was fetched
 @param success Whether the fetch succeeded
 @param error Error message if fetch failed, nil if successful
 */
typedef void (^ROXNetworkFetchCompletedHandler)(NSString* _Nonnull appKey, BOOL success, NSString* _Nullable error);

/**
 The enum to define SDK verbosilty level 
 @see `ROXOptions.verbose`
 */
typedef NS_ENUM (NSUInteger, ROXOptionsVerboseLevel){
    ///Silent log
    ROXOptionsVerboseLevelSilent,
    ///Verbsoe log
    ROXOptionsVerboseLevelDebug
} /** :nodoc: */;

/**
 This is the configuration class that is used when running `+[ROXCore setupWithKey:options:]`.
 */
@interface ROXOptions : NSObject

/**
 :nodoc:
 */
@property (nonatomic, copy, nullable) ROXConfigurationFetchedHandler onConfigurationFetched;

/**
 Called when a configuration error occurs (e.g., cache corruption, appKey mismatch).
 This allows the application to detect and handle configuration issues.

 @note This callback is particularly useful for detecting when cached configuration
       becomes invalid due to appKey changes or corruption.

 @warning The callback is invoked on a background thread. If you need to update UI,
          dispatch to the main queue.

 Example usage:
 @code
 ROXOptions *options = [[ROXOptions alloc] init];
 options.onConfigurationError = ^(NSError *error) {
     NSLog(@"Configuration error: %@", error.localizedDescription);

     if (error.code == ROXConfigurationErrorAppKeyMismatch) {
         // Handle appKey mismatch - cache was cleared automatically
         NSLog(@"AppKey mismatch detected. Expected: %@, Got: %@",
               error.userInfo[@"expectedAppKey"],
               error.userInfo[@"actualAppKey"]);
     }
 };
 @endcode

 @see ROXConfigurationError for possible error codes
 @see ROXConfigurationErrorDomain
 */
@property (nonatomic, copy, nullable) ROXConfigurationErrorHandler onConfigurationError;

/**
 Called when cached configuration is successfully loaded.
 Provides visibility into cache usage and metadata.

 @note This callback is invoked during SDK initialization if valid cache exists.
       It provides metadata about when the cache was created and which SDK version created it.

 Example usage:
 @code
 options.onCacheLoaded = ^(NSString *appKey, NSDate *timestamp, NSString *sdkVersion) {
     NSLog(@"Cache loaded for appKey: %@", appKey);
     NSLog(@"Cache created: %@ by SDK version: %@", timestamp, sdkVersion);

     // Calculate cache age
     NSTimeInterval age = [[NSDate date] timeIntervalSinceDate:timestamp];
     NSLog(@"Cache age: %.0f seconds", age);
 };
 @endcode
 */
@property (nonatomic, copy, nullable) ROXCacheLoadedHandler onCacheLoaded;

/**
 Called when cache is cleared due to validation failure, expiration, or manual clearing.
 Provides visibility into cache invalidation events.

 Common reasons include:
 - "appKey mismatch" - Cached configuration has different appKey
 - "corrupted" - Checksum validation failed
 - "expired" - Cache exceeded maximum age
 - "manual" - Developer called clearCache manually

 @note After cache is cleared, SDK will fetch fresh configuration from network.

 Example usage:
 @code
 options.onCacheCleared = ^(NSString *appKey, NSString *reason) {
     NSLog(@"Cache cleared for appKey: %@ - Reason: %@", appKey, reason);

     if ([reason isEqualToString:@"appKey mismatch"]) {
         // Track this event in analytics
         [Analytics track:@"cache_invalidated" properties:@{@"reason": reason}];
     }
 };
 @endcode
 */
@property (nonatomic, copy, nullable) ROXCacheClearedHandler onCacheCleared;

/**
 Called when a network fetch for configuration starts.
 Provides visibility into network activity.

 @param appKey The appKey being fetched
 @param fetchSource The source that triggered the fetch:
        - "setup" - Initial SDK setup
        - "foreground" - App returned to foreground
        - "push" - Remote notification triggered fetch
        - nil - Manual fetch or other sources

 Example usage:
 @code
 options.onNetworkFetchStarted = ^(NSString *appKey, NSString *fetchSource) {
     NSLog(@"Fetching configuration for %@ (source: %@)", appKey, fetchSource ?: @"unknown");

     // Show loading indicator if this is user-initiated
     if ([fetchSource isEqualToString:@"manual"]) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showLoadingIndicator];
         });
     }
 };
 @endcode
 */
@property (nonatomic, copy, nullable) ROXNetworkFetchStartedHandler onNetworkFetchStarted;

/**
 Called when a network fetch for configuration completes (success or failure).
 Provides visibility into network results.

 @param appKey The appKey that was fetched
 @param success YES if fetch succeeded, NO if failed
 @param error Error message if fetch failed, nil if successful

 @note This callback is invoked on a background thread.

 Example usage:
 @code
 options.onNetworkFetchCompleted = ^(NSString *appKey, BOOL success, NSString *error) {
     if (success) {
         NSLog(@"Configuration fetched successfully for %@", appKey);
     } else {
         NSLog(@"Configuration fetch failed for %@: %@", appKey, error);

         // Track fetch failures in monitoring system
         [Monitoring recordError:@"config_fetch_failed" message:error];
     }

     dispatch_async(dispatch_get_main_queue(), ^{
         [self hideLoadingIndicator];
     });
 };
 @endcode
 */
@property (nonatomic, copy, nullable) ROXNetworkFetchCompletedHandler onNetworkFetchCompleted;

@property (nonatomic, copy, nullable) ROXImpressionHandler impressionHandler;

@property (nonatomic, copy, nullable) ROXDynamicPropertiesRule dynamicPropertiesRule;
/**
 :nodoc:
 */
@property (nonatomic) BOOL disableSyncLoadingFallback;
/** 
 Set SDK verbosity level for debugging
 */
@property (nonatomic) ROXOptionsVerboseLevel verbose;
/**
 :nodoc:
 */
@property (nonatomic, strong) NSArray * _Nullable silentFiles;
/**
 :nodoc:
 */
@property (nonatomic, copy) NSString * _Nullable customSigningCertificate;
/**
 :nodoc:
 */
@property (nonatomic, copy) NSString * _Nullable defaultConfigurationPath;

@property (nonatomic) ROXFreeze defaultFreezeLevel;

@property (nonatomic, copy, nullable) ROXNetworkConfigurationsOptions* networkConfigurations;

/**
 :nodoc:
 */
@property (nonatomic) BOOL disableSignatureVerification;

@end

