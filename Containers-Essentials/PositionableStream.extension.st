Extension { #name : #PositionableStream }

{ #category : #'*Containers-Essentials' }
PositionableStream >> merge: aStream sortBlock: lessThan on: outStream [

	^ self
		  merge: aStream
		  sortBlock: lessThan
		  on: outStream
		  inversionsOrNil: nil
]

{ #category : #'*Containers-Essentials' }
PositionableStream >> merge: aStream sortBlock: lessThan on: outStream inversionsOrNil: invStream [

	| inversions append |
	inversions := 0.

	append := invStream ifNil: [ [ :inv |  ] ] ifNotNil: [ 
		          [ :inv | 
		          self preservingPositionDo: [ :each | 
			          invStream nextPut: inv inversion: each ] ] ].

	[ self atEnd or: [ aStream atEnd ] ] whileFalse: [ 
		| anObject myNext itsNext |
		myNext := self peek.
		itsNext := aStream peek.

		anObject := (lessThan value: myNext value: itsNext)
			            ifTrue: [ self next ]
			            ifFalse: [ 
				            append value: itsNext.

				            inversions := inversions + self sizeUpToEnd.

				            aStream next ].

		outStream nextPut: anObject ].

	outStream
		nextPutAll: self upToEnd;
		nextPutAll: aStream upToEnd.

	^ inversions
]

{ #category : #'*Containers-Essentials' }
PositionableStream >> preservingPositionDo: aBlock [

	| currentPosition |
	currentPosition := self position.

	[ self do: aBlock ] ensure: [ self position: currentPosition ]
]

{ #category : #'*Containers-Essentials' }
PositionableStream >> sizeUpToEnd [

	^ readLimit - position
]
