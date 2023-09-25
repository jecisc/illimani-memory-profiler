
# Illimani: a Memory Profiler

[![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)

<p align="center">
  <img src="https://cdn.fstoppers.com/styles/full/s3/photos/171592/10/30/1d2b5ac3df32b99cd9a22454527e04ff.jpg" width="500">
</p>

<p align="center">
  <em>The Illimani mountain in La Paz, Bolivia</em>
</p>

The release version works on Pharo 10, 11 and Pharo 12. But, keep in mind that the profiler should be faster in Pharo 12. This is because there were some optimizations done in Pharo 12 to make the instrumentation faster.

Illimani is a library of memory profilers. It provides a memory allocation profiler and a finalization profiler. The allocation profiler gives you information about the allocation sites and where the objects where produced in your application. The finalization profiler gives you information about how much time did the objects lived, and about how many GC cycles (both scavenges and full GC) they survived.

## How to install it

```smalltalk
EpMonitor disableDuring: [
	Metacello new
		baseline: 'IllimaniProfiler';
		repository: 'github://jordanmontt/illimani-memory-profiler:main';
		load ].
```

## Quick Getting Started

Profiling a given code snippet

```st
profiler
	profileOn: [ 15 timesRepeat: [ StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

Profiling the Pharo IDE activity for a given amount of time

```st
profiler
	profileFor: 6 seconds;
	open;
	yourself
```

Example 1, allocation profiler for profiling the Pharo IDE activity

```st
IllAllocationProfiler new
	copyExecutionStack;
	profileFor: 6 seconds;
	open;
	yourself
```

Example 2, finalization profiler on a code snippet:

```st
IllFinalizationProfiler new.
	profileOn: [ 15 timesRepeat: [StPlaygroundPresenter open close ] ] ;
	open;
	yourself
```

## How to use

You can decide both to profile a given method block or just watching the activity of the image for some time.

```st
"With this the profiler will block the ui and you will only capture the objects created by your code snippet"
profiler profileOn: [ anObject performSomeAction ].

"With this the profiler with not block the UI nor the image. So, you will capture all the allocations of the image"
profiler profileFor: 2 seconds.
```

For starting the stoping the profiling manually. This can be useful if you don't know how long your program will run.

```st
profiler startProfiling.
profiler stopProfiling.
```

You can open the ui at any time with the message `open` (even if the profiler is still profiling)

```st
profiler open.
```

By default, the profiler captures all the object allocations. You can configure it to sample the samples. This can be useful for reducing the overhead when your application makes lots of allocations.

```st
"Capture only 33% of the allocations"
profiler samplingRate: 33.
```

## Allocation profiler

![GIF1](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/fd915e86-a251-48c9-a087-3929d74509e7)

It is also possible to copy the execution stack of *each* of the allocated objects with the message.
This is very useful when you to make analysis, for example indentify in which context the allocations were prodoced, etc.
Keep in mind that with a lot of allocations, copying the stack can cause the image to grow in size rapidly and making it slow to use.

```st
profiler copyExecutionStack.
```

Without the UI, because the profiler is independent from the UI, you can access to some statistics. See the protocol `accessing - statistics` in the profiler to see the methods. Also, the profiler has a statistics model that groups and sorts the allocation by class and by methods. For example check 'profiler stats allocationsByClass.'

## Finalization profiler

![GIF2](https://github.com/jordanmontt/illimani-memory-profiler/assets/33934979/b1bfd2fd-80d9-4a5b-8c12-0f637f5cfeb5)

## Implementation details

- Illimani uses [method proxies](https://github.com/pharo-contributions/MethodProxies) library to capture the allocations. It insert a proxy in `Behavior>>basicNew:`, `Behavior>>basicNew` and `Array>>#new:`.
- It uses Ephemerons to know when an object is about to be finalized.
- It has an statistics model that helps with the calculations of allocations grouping them by classes and methods and sorting them by number of allocations. 
- The UI is independent of the profiler. It can be used without it. You will have access to all allocations and to the same statistics.
