NSOperationQueue+CompletionBlock
================================

[![CocoaPods](http://img.shields.io/cocoapods/v/NSOperationQueue+CompletionBlock.svg?style=flat)](https://cocoapods.org/pods/NSOperationQueue+CompletionBlock)

A missing completionBlock for NSOperationQueue.


At a Glance
-----------

**Swift**

```swift
import NSOperationQueue_CompletionBlock

let queue = NSOperationQueue()
queue.completionBlock = {
    NSLog("I'm done!")
}
queue.addOperationWithBlock {
    NSLog("I am an operation.")
}
```

**Objective-C**

```objc
#import <NSOperationQueue_CompletionBlock/NSOperationQueue+CompletionBlock.h>

NSOperationQueue *queue = [[NSOperationQueue alloc] init];
queue.completionBlock = ^{
    NSLog(@"I'm done!");
};
[queue addOperationWithBlock:^{
    NSLog(@"I am an operation.");
}];
```

**Output**

```
I am an operation.
I'm dont!
```


Installation
------------

I recommend you to use [CocoaPods](https://cocoapods.org), a dependency manager for Cocoa.

**Podfile**

```ruby
pod 'NSOperationQueue+CompletionBlock', '~> 1.0'
```


License
-------

**NSOperationQueue+CompletionBlock** is under MIT license. See the LICENSE file for more info.
