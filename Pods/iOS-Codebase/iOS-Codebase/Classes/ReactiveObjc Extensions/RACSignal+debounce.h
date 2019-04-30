//
//  RACSignal+debounce.h
//  rac_tets
//
//  Created by Hamidreza Vakilian on 1/6/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>


typedef enum : NSUInteger {
    RACDebounceTypeI,
    RACDebounceTypeII,
    RACDebounceTypeIII,
} RACDebounceType;

NS_ASSUME_NONNULL_BEGIN


/**
 RACDebounceTypeI: Normal Debounce Behavior
 RACDebounceTypeII: Debounce with guaranteed last value send upon the end of the interval. The next interval will begin on the next input value.
 RACDebounceTypeIII: Debounce with guaranteed last value send upon the end of the interval. The next interval will begin sequentially after the last interval.
 */
@interface RACSignal<__covariant ValueType> (debounce)


/// Sends `next`s only if we don't receive another `next` in `interval` seconds.
///
/// If a `next` is received, and then another `next` is received before
/// `interval` seconds have passed, the first value is discarded.
///
/// After `interval` seconds have passed since the most recent `next` was sent,
/// the most recent `next` is forwarded on the scheduler that the value was
/// originally received on. If +[RACScheduler currentScheduler] was nil at the
/// time, a private background scheduler is used.
///
/// Returns a signal which sends debounced and delayed `next` events. Completion
/// and errors are always forwarded immediately.
- (RACSignal<ValueType> *)debounce:(NSTimeInterval)interval type:(RACDebounceType)type RAC_WARN_UNUSED_RESULT;

/// Debounces `next`s for which `predicate` returns YES.
///
/// When `predicate` returns YES for a `next`:
///
///  1. If another `next` is received before `interval` seconds have passed, the
///     prior value is discarded. This happens regardless of whether the new
///     value will be debounced.
///  2. After `interval` seconds have passed since the value was originally
///     received, it will be forwarded on the scheduler that it was received
///     upon. If +[RACScheduler currentScheduler] was nil at the time, a private
///     background scheduler is used.
///
/// When `predicate` returns NO for a `next`, it is forwarded immediately,
/// without any debouncing.
///
/// interval  - The number of seconds for which to buffer the latest value that
///             passes `predicate`.
/// predicate - Passed each `next` from the receiver, this block returns
///             whether the given value should be debounced. This argument must
///             not be nil.
///
/// Returns a signal which sends `next` events, debounced when `predicate`
/// returns YES. Completion and errors are always forwarded immediately.
- (RACSignal<ValueType> *)debounce:(NSTimeInterval)interval valuesPassingTest:(BOOL (^)(id _Nullable next))predicate type:(RACDebounceType)type RAC_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
