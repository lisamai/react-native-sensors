
//  LinearAcceleration.m


#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "LinearAcceleration.h"

@implementation LinearAcceleration

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"LinearAcceleration");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        // LinearAcceleration
        if([self->_motionManager isDeviceMotionAvailable])
        {
            NSLog(@"LinearAcceleration available");
            /* Start the device motion if it is not active already */
            if([self->_motionManager isDeviceMotionActive] == NO)
            {
                NSLog(@"LinearAcceleration active");
            } else {
                NSLog(@"LinearAcceleration not active");
            }
        }
        else
        {
            NSLog(@"LinearAcceleration not available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
    NSLog(@"setUpdateInterval: %f", interval);
    double intervalInSeconds = interval / 1000;

    [self->_motionManager setDeviceMotionUpdateInterval:intervalInSeconds];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.deviceMotionUpdateInterval;
    NSLog(@"getUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.deviceMotion.userAcceleration.x;
    double y = self->_motionManager.deviceMotion.userAcceleration.y;
    double z = self->_motionManager.deviceMotion.userAcceleration.z;

    NSLog(@"getData: %f, %f, %f", x, y, z);

    cb(@[[NSNull null], @{
                 @"x" : [NSNumber numberWithDouble:x],
                 @"y" : [NSNumber numberWithDouble:y],
                 @"z" : [NSNumber numberWithDouble:z]
             }]
       );
}

RCT_EXPORT_METHOD(startUpdates) {
    NSLog(@"startUpdates");
    [self->_motionManager startDeviceMotionUpdates];

    /* Receive the linear acceleration data on this block */
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                               withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
     {
         double x = deviceMotion.userAcceleration.x;
         double y = deviceMotion.userAcceleration.y;
         double z = deviceMotion.userAcceleration.z;
         NSLog(@"startLinearAccelerationUpdates: %f, %f, %f", x, y, z);

         [self.bridge.eventDispatcher sendDeviceEventWithName:@"LinearAcceleration" body:@{
                                                                                   @"x" : [NSNumber numberWithDouble:x],
                                                                                   @"y" : [NSNumber numberWithDouble:y],
                                                                                   @"z" : [NSNumber numberWithDouble:z]
                                                                               }];
     }];

}

RCT_EXPORT_METHOD(stopUpdates) {
    NSLog(@"stopUpdates");
    [self->_motionManager stopDeviceMotionUpdates];
}

@end
