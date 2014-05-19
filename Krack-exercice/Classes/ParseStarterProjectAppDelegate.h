@class ParseStarterProjectViewController;


#define METERS_PER_MILE 1609.344

typedef NS_ENUM(NSInteger, KrackPlaceType) {
    AllTypes = 0
    ,   FirstType = 1
    ,   SecondType = 2
    ,   ThirdType = 3
};


@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) UIWindow *window;

@end
