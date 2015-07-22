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

#import "NSOperationQueue+CompletionBlock.h"
#import <objc/runtime.h>

#pragma mark - NSOperationQueueOperationCountObserver

@interface NSOperationQueueOperationCountObserver : NSObject

@property (nonatomic, strong, nullable) NSOperationQueueCompletionBlock completionBlock;

@end


@implementation NSOperationQueueOperationCountObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"operationCount"]) {
        NSInteger operationCount = [change[NSKeyValueChangeNewKey] integerValue];
        if (operationCount == 0 && self.completionBlock) {
            self.completionBlock();
        }
    }
}

@end


#pragma mark - NSOperationQueue+AsyncBlockOperation

@implementation NSOperationQueue (AsyncBlockOperation)

#pragma mark Swizzle Dealloc

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.completionBlock) {
        [self removeObserver:self.observer forKeyPath:@"operationCount"];
    }
    [self swizzledDealloc];
}


#pragma mark operationCounterObserver

- (nonnull NSOperationQueueOperationCountObserver *)observer {
    NSOperationQueueOperationCountObserver *observer = objc_getAssociatedObject(self, "observer");
    if (!observer) {
        observer = [[NSOperationQueueOperationCountObserver alloc] init];
        objc_setAssociatedObject(self, "observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}


#pragma mark completionBlock

- (nullable NSOperationQueueCompletionBlock)completionBlock {
    return self.observer.completionBlock;
}

- (void)setCompletionBlock:(nullable NSOperationQueueCompletionBlock)completionBlock {
    if (completionBlock) {
        [self addObserver:self.observer forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];
    } else {
        [self removeObserver:self.observer forKeyPath:@"operationCount"];
    }
    self.observer.completionBlock = completionBlock;
}

@end
