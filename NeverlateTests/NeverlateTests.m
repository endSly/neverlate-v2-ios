//
//  NeverlateTests.m
//  NeverlateTests
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GSNeverlateService.h"

@interface NeverlateTests : XCTestCase

@end

@implementation NeverlateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testService
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [[GSNeverlateService sharedService] getAgencies:nil callback:^(NSArray *agencies, NSHTTPURLResponse *resp, NSError *error) {
        XCTAssertNil(error, @"Service should get agencies");
        XCTAssertTrue([agencies isKindOfClass:NSArray.class], @"Agencies should be an array");
        XCTAssertEqual(resp.statusCode, 200, @"Service should response 200");
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

@end
