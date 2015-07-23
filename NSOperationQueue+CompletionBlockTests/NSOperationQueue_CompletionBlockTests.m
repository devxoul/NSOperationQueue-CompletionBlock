// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <XCTest/XCTest.h>
#import <NSOperationQueue_CompletionBlock/NSOperationQueue+CompletionBlock.h>

@interface NSOperationQueue_CompletionBlockTests : XCTestCase

@end

@implementation NSOperationQueue_CompletionBlockTests

- (void)testCompletionBlockExecution {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Execute completion block"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.completionBlock = ^{
        [expectation fulfill];
    };
    [queue addOperation:[[NSOperation alloc] init]];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
}

- (void)testCompletionBlockExecutionAfterOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Execute completion block"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __block NSInteger count;
    queue.completionBlock = ^{
        NSLog(@"B");
        XCTAssertEqual(count, 2);
        [expectation fulfill];
    };
    [queue addOperationWithBlock:^{
        for (NSInteger i = 0; i < 10000000; i++) {}
        NSLog(@"A");
        count += 1;
    }];
    [queue addOperationWithBlock:^{
        for (NSInteger i = 0; i < 10000000; i++) {}
        NSLog(@"A");
        count += 1;
    }];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
