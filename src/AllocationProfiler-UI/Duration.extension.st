Extension { #name : #Duration }

{ #category : #'*AllocationProfiler-UI' }
Duration >> humanReadableStringWithOnlySeconds [

	^ String streamContents: [ :out | self printHumanReadableStringWithOnlySecondsOn: out ]
]

{ #category : #'*AllocationProfiler-UI' }
Duration >> printHumanReadableStringWithOnlySecondsOn: stream [

	self negative ifTrue: [
		stream << '- '.
		^ self abs printHumanReadableStringWithOnlySecondsOn: stream ].

	stream
		<< (self totalSeconds printShowingDecimalPlaces: 3)
		<< String space
		<< ('second' asPluralBasedOn: self totalSeconds)
]