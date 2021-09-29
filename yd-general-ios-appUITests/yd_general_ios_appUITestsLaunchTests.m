//
//  yd_general_ios_appUITestsLaunchTests.m
//  yd-general-ios-appUITests
//
//  Created by wangyuandong on 2021/9/29.
//

#import <XCTest/XCTest.h>

@interface yd_general_ios_appUITestsLaunchTests : XCTestCase

@end

@implementation yd_general_ios_appUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
