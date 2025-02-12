Extension { #name : #Point }

{ #category : #'*Containers-Essentials' }
Point >> asFloatPointRound: numberOfWishedDecimal [

	| aPoint |
	aPoint := self asFloatPoint.

	^ (aPoint x round: numberOfWishedDecimal)
	  @ (aPoint y round: numberOfWishedDecimal)
]

{ #category : #'*Containers-Essentials' }
Point >> unitAffine: aPoint at: aParam [

	| t |
	t := aParam min: 1 max: 0.

	^ self * t + (1 - t * aPoint)
]

{ #category : #'*Containers-Essentials' }
Point >> unitAffine: aPoint at: aParam and: anotherPoint at: anotherParam [

	| t s |
	t := aParam min: 1 max: 0.
	s := anotherParam min: 1 max: 0.


	^ self * t + (aPoint * s) + (1 - t - s * anotherPoint)
]

{ #category : #'*Containers-Essentials' }
Point >> xMinusY [

	^ self x - self y
]

{ #category : #'*Containers-Essentials' }
Point >> yMinusX [

	^ self y - self x
]
