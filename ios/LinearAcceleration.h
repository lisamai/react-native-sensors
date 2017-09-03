#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface LinearAcceleration : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}

- (void) setUpdateInterval:(double) interval;
- (void) getUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getData:(RCTResponseSenderBlock) cb;
- (void) startUpdates;
- (void) stopUpdates;

@end
