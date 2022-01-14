#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "FlutterflappyconnectPlugin.h"
#import "ReachabilityFlappy.h"


//interface
@interface FlutterflappyconnectPlugin ()<FlutterStreamHandler>

//event
@property(nonatomic,strong) FlutterEventChannel* eventChannel;
//event sink
@property(nonatomic,strong) FlutterEventSink eventSink;
//host changed
@property (nonatomic) ReachabilityFlappy *hostReachability;
//Reachability changed
@property (nonatomic) ReachabilityFlappy *internetReachability;


@end


@implementation FlutterflappyconnectPlugin


//reg
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    
    //eventChannel
    FlutterEventChannel* eventChannel=[FlutterEventChannel eventChannelWithName:@"flutterflappyconnect_event"
                                                                binaryMessenger:[registrar messenger]];
    //channel
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutterflappyconnect"
                                     binaryMessenger:[registrar messenger]];
    //instance
    FlutterflappyconnectPlugin* instance = [[FlutterflappyconnectPlugin alloc] init];
    //set value
    instance.eventChannel=eventChannel;
    //set StreamHandler
    [eventChannel setStreamHandler:instance];
    //start listen
    [instance listenNetWorkingStatus];
    //add delegate
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)listenNetWorkingStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotificationFlappy object:nil];
    
    self.internetReachability = [ReachabilityFlappy reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

//changed
- (void) reachabilityChanged:(NSNotification *)note
{
    ReachabilityFlappy* curReach = [note object];
    [self updateInterfaceWithReachability:curReach];
}

//evetn
- (void)updateInterfaceWithReachability:(ReachabilityFlappy *)reachability
{
    //sink
    if(_eventSink!=nil){
        _eventSink(@"");
    }
}

//remove
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotificationFlappy
                                                  object:nil];
    _eventChannel=nil;
}


//handle method call
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getConnectionType" isEqualToString:call.method]) {
        result([self getNetconnType]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

//get type
- (NSString *)getNetconnType{
    
    NSString *netconnType = @"Mobile";
    NSString *netconnTypeMine = @"4";
    
    ReachabilityFlappy *reach = [ReachabilityFlappy reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
            //no network
        case NotReachable:
        {
            netconnType = @"no network";
            netconnTypeMine=@"6";
            break;
        }
            // Wifi
        case ReachableViaWiFi:
        {
            netconnType = @"Wifi";
            netconnTypeMine=@"5";
            break;
        }
            // self
        case ReachableViaWWAN:
        {
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = info.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
                netconnTypeMine=@"0";
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
                netconnTypeMine=@"0";
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
                netconnTypeMine=@"1";
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
                netconnTypeMine=@"1";
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
                netconnTypeMine=@"1";
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
                netconnTypeMine=@"0";
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
                netconnTypeMine=@"1";
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
                netconnTypeMine=@"1";
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
                netconnTypeMine=@"1";
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
                netconnTypeMine=@"1";
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
                netconnTypeMine=@"2";
                netconnType = @"4G";
            }else if (@available(iOS 14.1, *)) {
                if ([currentStatus isEqualToString:CTRadioAccessTechnologyNRNSA]){
                    netconnTypeMine=@"3";
                    netconnType = @"5G NSA";
                }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyNR]){
                    netconnTypeMine=@"3";
                    netconnType = @"5G";
                }
            }
        }
            break;
        default:
            break;
    }
    
    return netconnTypeMine;
}


//end
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}
//listen
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    return nil;
}


@end
