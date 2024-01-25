Class {
	#name : 'IllAllocationRateProfilerTest',
	#superclass : 'IllAbstractProfilerTest',
	#category : 'IllimaniProfiler-Tests-Finalization-Profiler',
	#package : 'IllimaniProfiler-Tests',
	#tag : 'Finalization-Profiler'
}

{ #category : 'running' }
IllAllocationRateProfilerTest >> profilerClass [

	^ IllAllocationRateProfiler
]

{ #category : 'tests' }
IllAllocationRateProfilerTest >> testSamplingRate [

	| allocatedByteSrings |
	
	profiler
		samplingRate: 33;
		profileOn: [ 100 timesRepeat: [ ByteString new ] ].

	"We don't have the classes on this profiler"
	allocatedByteSrings := profiler objectAllocations size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot check that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 33) & (allocatedByteSrings < 40)
]

{ #category : 'tests' }
IllAllocationRateProfilerTest >> testSamplingRateOtherPercentage [

	| allocatedByteSrings |
	
	profiler
		samplingRate: 75;
		profileOn: [ 100 timesRepeat: [ ByteString new ] ].

	"We don't have the class on this profiler"
	allocatedByteSrings := profiler objectAllocations size.

	"We are cheking in this range becase the profiler makes some allocations that are
	necessary for the profiler to work, like Durations objects. So we cannot chack that the
	allocations are exacty 1/3 of the total."
	self assert: (allocatedByteSrings >= 75) & (allocatedByteSrings < 80)
]