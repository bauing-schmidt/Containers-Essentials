"
I represent a complex number.

real			--	real part of the complex number
imaginary	--	imaginary part of the complex number

Complex number constructors:

	5 i
	6 + 7 i.
	5.6 - 8 i.
	Complex real: 10 imaginary: 5.
	Complex abs: 5 arg: (Float pi / 4)

Arithmetic operation with other complex or non-complex numbers work.

	(5 - 6 i) + (-5 + 8 i).			""Arithmetic between two complex numbers.""
	5 * (5 - 6 i).				""Arithmetic between a non-complex and a complex number.""
					
It is also possible to perform arithmetic operations between a complex number
and a array of (complex) numbers:

	2 * {1 + 2i.
	     3 + 4i.
	     5 + 6i}

	5 + 5i * {1 + 2i.
	          3.
	          5 + 6i}

It behaves analogously as it is with normal numbers and an array.

NOTE: Although Complex something similiar to the Smalltalk's Number class, it would
not be a good idea to make a Complex to be a subclass of a Number because:
- Number is subclass of Magnitude and Complex is certainly not a magnitude.
  Complex does not behave very well as a Magnitude. Operations such as
	<
	>
	<=
	>=
  do not have sense in case of complex numbers.
- Methods in the following Number methods' categories do not have sense for a Complex numbers
	trucation and round off
	testing
	intervals
	comparing
- However the following Number methods' categories do have sense for a Complex number
	arithmetic (with the exception of operation
		//
		\\
		quo:
		rem:	
	mathematical functions

Thus Complex is somewhat similar to a Number but it is not a subclass of it. Some operations
we would like to inherit (e.g. #abs, #negated, #reciprocal) but some of the Number operation
do not have sens to inherit or to overload. Classes are not always neat mechanism.

!!! We had to COPY the implementation of the
		abs
		negated
		reciprocal
		log:
		isZero
		reciprocal
		...
	methods from the Number class to the Complex class. Awful solution. Now I begin to
	appreciate the Self.

Missing methods
	String | converting | asComplex
	Complex | mathematical functions | arcSin
	Complex | mathematical functions | arcCos
	Complex | mathematical functions | arcTan
"
Class {
	#name : #Complex,
	#superclass : #Object,
	#instVars : [
		'real',
		'imaginary'
	],
	#category : #'Containers-Essentials-Numbers'
}

{ #category : #'instance creation' }
Complex class >> abs: aNumber1 arg: aNumber2 [
	^self
		real: aNumber1 * aNumber2 cos
		imaginary: aNumber1 * aNumber2 sin
]

{ #category : #'instance creation' }
Complex class >> new [
	^ self real: 0 imaginary: 0
]

{ #category : #'instance creation' }
Complex class >> one [
	^ self real: 1 imaginary: 0
]

{ #category : #'instance creation' }
Complex class >> real: aNumber1 imaginary: aNumber2 [
	^self basicNew	real: aNumber1 imaginary: aNumber2
]

{ #category : #'instance creation' }
Complex class >> zero [
	^ self real: 0 imaginary: 0
]

{ #category : #arithmetic }
Complex >> * anObject [
	"Answer the result of multiplying the receiver by aNumber."
	| a b c d newReal newImaginary |
	anObject isComplex
		ifTrue:
			[a := self real.
			b := self imaginary.
			c := anObject real.
			d := anObject imaginary.
			newReal := (a * c) - (b * d).
			newImaginary := (a * d) + (b * c).
			^ Complex real: newReal imaginary: newImaginary]
		ifFalse:
			[^ anObject adaptToComplex: self andSend: #*]
]

{ #category : #arithmetic }
Complex >> + anObject [
	"Answer the sum of the receiver and aNumber."
	| a b c d newReal newImaginary |
	anObject isComplex
		ifTrue:
			[a := self real.
			b := self imaginary.
			c := anObject real.
			d := anObject imaginary.
			newReal := a + c.
			newImaginary := b + d.
			^ Complex real: newReal imaginary: newImaginary]
		ifFalse:
			[^ anObject adaptToComplex: self andSend: #+]
]

{ #category : #arithmetic }
Complex >> - anObject [
	"Answer the difference between the receiver and aNumber."
	| a b c d newReal newImaginary |
	anObject isComplex
		ifTrue:
			[a := self real.
			b := self imaginary.
			c := anObject real.
			d := anObject imaginary.
			newReal := a - c.
			newImaginary := b - d.
			^ Complex real: newReal imaginary: newImaginary]
		ifFalse:
			[^ anObject adaptToComplex: self andSend: #-]
]

{ #category : #arithmetic }
Complex >> / anObject [
	"Answer the result of dividing receiver by aNumber"
	| a b c d newReal newImaginary |
	anObject isComplex ifTrue:
		[a := self real.
		b := self imaginary.
		c := anObject real.
		d := anObject imaginary.
		newReal := ((a * c) + (b * d)) / ((c * c) + (d * d)).
		newImaginary := ((b * c) - (a * d)) / ((c * c) + (d * d)).
		^ Complex real: newReal imaginary: newImaginary].
	^ anObject adaptToComplex: self andSend: #/.
]

{ #category : #comparing }
Complex >> = anObject [
	anObject isNumber ifFalse: [^false].
	anObject isComplex
		ifTrue: [^ (real = anObject real) & (imaginary = anObject imaginary)]
		ifFalse: [^ anObject adaptToComplex: self andSend: #=]
]

{ #category : #arithmetic }
Complex >> abs [
	"Answer the distance of the receiver from zero (0 + 0 i)."

	^ ((real * real) + (imaginary * imaginary)) sqrt
]

{ #category : #arithmetic }
Complex >> absSecure [
	"Answer the distance of the receiver from zero (0 + 0 i).
	Try avoiding overflow and/or underflow"

	| scale |
	scale := real abs max: imaginary abs.
	^scale isZero 
		ifTrue: [scale]
		ifFalse: [(self class real: real / scale imaginary: imaginary / scale) squaredNorm sqrt * scale]
]

{ #category : #converting }
Complex >> adaptToCollection: rcvr andSend: selector [
	"If I am involved in arithmetic with a Collection, return a Collection of
	the results of each element combined with me in that expression."

	^ rcvr collect: [:element | element perform: selector with: self]
]

{ #category : #converting }
Complex >> adaptToFloat: rcvr andSend: selector [
	"If I am involved in arithmetic with a Float, convert it to a Complex number."
	^ rcvr asComplex perform: selector with: self
]

{ #category : #converting }
Complex >> adaptToFraction: rcvr andSend: selector [
	"If I am involved in arithmetic with a Fraction, convert it to a Complex number."
	^ rcvr asComplex perform: selector with: self
]

{ #category : #converting }
Complex >> adaptToInteger: rcvr andSend: selector [
	"If I am involved in arithmetic with an Integer, convert it to a Complex number."
	^ rcvr asComplex perform: selector with: self
]

{ #category : #'mathematical functions' }
Complex >> arcCos [
	"Answer the arc cosine of the receiver.
	This is the inverse function of cos."

	| x y tmp sh2y shy delta ch2y chy |
	imaginary = 0 ifTrue: [real abs > 1
			ifTrue: 
				[x := real < 0
					ifTrue: [Float pi]
					ifFalse: [0].
				y := real copySignTo: real abs arcCosh.
				^self class real: x imaginary: y]
			ifFalse: [^self class real: real arcCos imaginary: 0]].
	tmp := self squaredNorm - 1 / 2.
	delta := tmp squared + imaginary squared.
	sh2y := tmp + delta sqrt.
	shy := sh2y sqrt.
	ch2y := 1 + sh2y.
	chy := ch2y sqrt.
	y := imaginary copySignTo: shy arcSinh.
	x := (real / chy) arcCos.
	^self class real: x imaginary: y negated
]

{ #category : #'mathematical functions' }
Complex >> arcCosh [
	"Answer receiver's area hyperbolic cosine.
	That is the inverse function of cosh.
	Some possible implementations:
	^imaginary > 0 
		ifTrue: [(self + (self * self - 1) sqrt) ln]
		ifFalse: [(self + (self * self - 1) sqrt) ln negated]
	^self arcCos i
	This implementation provides an answer with a positive real part.
	It also avoids creating intermediate Complex."
	
	| x y tmp sh2x shx delta ch2x chx |
	imaginary = 0 ifTrue: [real abs > 1
			ifTrue: 
				[y := real < 0
					ifTrue: [Float pi]
					ifFalse: [0].
				x := real abs arcCosh.
				^self class real: x imaginary: y]
			ifFalse: [^self class real: 0 imaginary: real arcCos]].
	tmp := self squaredNorm - 1 / 2.
	delta := tmp squared + imaginary squared.
	sh2x := tmp + delta sqrt.
	shx := sh2x sqrt.
	ch2x := 1 + sh2x.
	chx := ch2x sqrt.
	x := shx arcSinh.
	y := imaginary copySignTo: (real / chx) arcCos.
	^self class real: x imaginary: y
]

{ #category : #'mathematical functions' }
Complex >> arcSin [
	"Answer the arc sine of the receiver.
	This is the inverse function of sin."

	| x y tmp delta sh2y shy ch2y chy |
	imaginary = 0 
		ifTrue: 
			[real abs > 1 
				ifTrue: 
					[x := Float pi / 2 * real sign.
					y := (real copySignTo: real abs arcCosh) negated.
					^self class real: x imaginary: y]
				ifFalse: [^self class real: real arcSin imaginary: 0]].
	tmp := (self squaredNorm - 1) / 2.
	delta := tmp squared + imaginary squared.
	sh2y := tmp + delta sqrt.
	shy := sh2y sqrt.
	ch2y := 1 + sh2y.
	chy := ch2y sqrt.
	y := imaginary copySignTo: shy arcSinh.
	x := (real / chy) arcSin.
	^self class real: x imaginary: y
]

{ #category : #'mathematical functions' }
Complex >> arcSinh [
	"Answer receiver's area hyperbolic sine.
	That is the inverse function of sinh."

	"Some possible implementation:

	^imaginary * real < 0 
		ifTrue: [(self + (self * self + 1) sqrt) ln]
		ifFalse: [(self - (self * self + 1) sqrt) ln]"

	^self i arcSin i negated
]

{ #category : #'mathematical functions' }
Complex >> arcTan [
	"Answer the arc tangent of the receiver.
	This is the inverse function of tan."

	| r2 |
	r2 := self squaredNorm.
	^self class
		real: (real * 2 arcTan: 1 - r2) / 2
		imaginary: ((r2 + (imaginary * 2) + 1) / (r2 - (imaginary * 2) + 1)) ln / 4
]

{ #category : #'mathematical functions' }
Complex >> arcTan: denominator [ 
	"Answer the  four quadrants arc tangent of receiver over denominator."

	^denominator isZero 
		ifTrue: 
			[self isZero 
				ifTrue: 
					["shouldn't it be an error ? ^DomainError signal: '0 arcTan: 0'"
					^self class real: 0 imaginary: 0]
				ifFalse: 
					[self class
						real: Float pi / (real copySignTo: 2)
						imaginary: 0]]
		ifFalse: 
			[| res |
			res := (self / denominator) arcTan.
			denominator real < 0 ifTrue: [res := res + Float pi].
			res real > Float pi 
				ifTrue: [res := res - (Float pi * 2)].
			res]
]

{ #category : #'mathematical functions' }
Complex >> arcTanh [
	"Answer receiver's area hyperbolic tangent.
	That is the inverse function of tanh."

	"Some other possible implementation:

	^((1 + self) / (1 - self)) ln / 2"

	^self i arcTan i negated
]

{ #category : #arithmetic }
Complex >> arg [
	"Answer the argument of the receiver."

	self isZero ifTrue: [self error: 'zero has no argument.'].
	^imaginary arcTan: real
]

{ #category : #converting }
Complex >> asComplex [
	^self
]

{ #category : #arithmetic }
Complex >> conjugated [
	"Return the complex conjugate of this complex number."

	^self class real: real imaginary: imaginary negated
]

{ #category : #'mathematical functions' }
Complex >> cos [
	"Answer receiver's cosine."

	^self i cosh
]

{ #category : #'mathematical functions' }
Complex >> cosh [
	"Answer receiver's hyperbolic cosine.
	Hyperbolic cosine is defined by same power serie expansion as for real numbers, that is in term of exponential:
	^ (self exp + self negated exp) / 2.
	This implementation avoids creating intermediate objects."
	
	^self class
		real: real cosh * imaginary cos
		imaginary: real sinh * imaginary sin
]

{ #category : #arithmetic }
Complex >> divideFastAndSecureBy: anObject [
	"Answer the result of dividing receiver by aNumber"
	" Both operands are scaled to avoid arithmetic overflow. 
	  This algorithm works for a wide range of values, and it needs only three divisions.
	  Note: #reciprocal uses #/ for devision "
	 
	| r d newReal newImaginary |
	anObject isComplex ifTrue:
		[anObject real abs > anObject imaginary abs
		  ifTrue:
		    [r := anObject imaginary / anObject real.
			d := r*anObject imaginary + anObject real.
			newReal := r*imaginary + real/d.
			newImaginary := r negated * real + imaginary/d.
		    ]
		  ifFalse:
		    [r := anObject real / anObject imaginary.
			d := r*anObject real + anObject imaginary.
			newReal := r*real + imaginary/d.
			newImaginary := r*imaginary - real/d.
		    ].
		
		^ Complex real: newReal imaginary: newImaginary].
	^ anObject adaptToComplex: self andSend: #/.
]

{ #category : #arithmetic }
Complex >> divideSecureBy: anObject [
	"Answer the result of dividing receiver by aNumber"
	" Both operands are scaled to avoid arithmetic overflow. This algorithm 
	  works for a wide range of values, but it requires six divisions.  
	  #divideFastAndSecureBy:  is also quite good, but it uses only 3 divisions.
	   Note: #reciprocal uses #/ for devision"
	 
	| s ars ais brs bis newReal newImaginary |
	anObject isComplex ifTrue:
		[s := anObject real abs + anObject imaginary abs.
		 ars := self real / s.
		 ais := self imaginary / s.
		 brs := anObject real / s.
		 bis := anObject imaginary / s.
		 s := brs squared + bis squared.
		
		newReal := ars*brs + (ais*bis) /s.
		newImaginary := ais*brs - (ars*bis)/s.
		^ Complex real: newReal imaginary: newImaginary].
	^ anObject adaptToComplex: self andSend: #/.
]

{ #category : #'mathematical functions' }
Complex >> exp [
	"Answer the exponential of the receiver."

	^ real exp * (imaginary cos + imaginary sin i)
]

{ #category : #comparing }
Complex >> hash [
	"Hash is reimplemented because = is implemented."
	
	^ real hash bitXor: imaginary hash.
]

{ #category : #arithmetic }
Complex >> i [
	"Answer the result of multiplying the receiver with pure imaginary.
		^self * 1 i
	This is an obvious extension of method i implemented in Number."

	^self class real: imaginary negated imaginary: real
]

{ #category : #accessing }
Complex >> imaginary [
	^ imaginary
]

{ #category : #testing }
Complex >> isComplex [
	^ true
]

{ #category : #testing }
Complex >> isNumber [
	^ true
]

{ #category : #testing }
Complex >> isZero [
	^ real isZero and: [imaginary isZero]
]

{ #category : #'mathematical functions' }
Complex >> ln [
	"Answer the natural log of the receiver."

	^ self abs ln + self arg i
]

{ #category : #'mathematical functions' }
Complex >> log: aNumber [ 
	"Answer the log base aNumber of the receiver."

	^self ln / aNumber ln
]

{ #category : #arithmetic }
Complex >> negated [
	"Answer a Number that is the negation of the receiver."

	^self class real: real negated imaginary: imaginary negated
]

{ #category : #'as yet unclassified' }
Complex >> polarForm: aBlock [

	| aPoint |
	aPoint := self real @ self imaginary.

	^ aBlock value: aPoint distanceToOrigin value: aPoint π * Float π
]

{ #category : #printing }
Complex >> printOn: aStream [
	real printOn: aStream.
	aStream nextPut: Character space.
	imaginary signBit = 0
		ifTrue: [aStream nextPut: $+]
		ifFalse: [aStream nextPut: $-].
	aStream nextPut: Character space.
	imaginary abs printOn: aStream.
	aStream nextPut: Character space.
	aStream nextPut: $i

]

{ #category : #printing }
Complex >> printOn: aStream showingDecimalPlaces: placesDesired [
	real printOn: aStream showingDecimalPlaces: placesDesired.
	aStream nextPut: Character space.
	imaginary signBit = 0
		ifTrue: [aStream nextPut: $+]
		ifFalse: [aStream nextPut: $-].
	aStream nextPut: Character space.
	imaginary abs printOn: aStream showingDecimalPlaces: placesDesired.
	aStream nextPut: Character space.
	aStream nextPut: $i

]

{ #category : #'mathematical functions' }
Complex >> raisedTo: aNumber [ 
	"Answer the receiver raised to aNumber."

	aNumber isInteger ifTrue:
		["Do the special case of integer power"
		^ self raisedToInteger: aNumber].
	
	0 = aNumber ifTrue: [^ self class one].	"Special case of exponent=0"
	1 = aNumber ifTrue: [^ self].	"Special case of exponent=1"
	0 = self ifTrue: [				"Special case of self = 0"
		aNumber < 0
			ifTrue: [^ (ZeroDivide dividend: self) signal]
			ifFalse: [^ self]].
	^ (aNumber * self ln) exp		"Otherwise use logarithms"
]

{ #category : #'mathematical functions' }
Complex >> raisedToInteger: operand [ 
	"Answer the receiver raised to the power operand, an Integer."

	"implementation note: this code is copied from Number.
	This suggest that both Number and Complex should have an
	ArithmeticValue common superclass like in Visualworks.
	Or maybe should it be a Traits (a property of fields ?)"

	| count result |
	operand isInteger ifFalse: [^ ArithmeticError signal: 'parameter is not an Integer'].
	operand = 0 ifTrue: [^ self class one].
	operand = 1 ifTrue: [^ self].
	operand < 0 ifTrue: [^ (self raisedToInteger: operand negated) reciprocal].
	count := 1 bitShift: (operand-1) highBit.
	result := self class one.
	[count > 0]
		whileTrue: 
			[result := result squared.
			(operand bitAnd: count)
				= 0 ifFalse: [result := result * self].
			count := count bitShift: -1].
	^ result
]

{ #category : #accessing }
Complex >> real [
	^ real
]

{ #category : #private }
Complex >> real: aNumber1 imaginary: aNumber2 [
	"Private - initialize the real and imaginary parts of a Complex"
	real := aNumber1.
	imaginary := aNumber2.
]

{ #category : #arithmetic }
Complex >> reciprocal [
	"Answer 1 divided by the receiver. Create an error notification if the 
	receiver is 0."

	self = 0
		ifTrue: [^ (ZeroDivide dividend: 1) signal]
		ifFalse: [^1 / self]
		
]

{ #category : #'mathematical functions' }
Complex >> sin [
	"Answer receiver's sine."

	^self i sinh i negated
]

{ #category : #'mathematical functions' }
Complex >> sinh [
	"Answer receiver's hyperbolic sine.
	Hyperbolic sine is defined by same power serie expansion as for real numbers, that is in term of exponential:
	^ (self exp - self negated exp) / 2.
	This implementation avoids creating intermediate objects."
	
	^self class
		real: real sinh * imaginary cos
		imaginary: real cosh * imaginary sin
]

{ #category : #'mathematical functions' }
Complex >> sqrt [
	"Return the square root of the receiver with a positive imaginary part."

	| u v |
	(imaginary = 0 and: [real >= 0])
		ifTrue:	[^self class real: real sqrt imaginary: 0].
	v := (self abs - real / 2) sqrt.
	u := imaginary / 2 / v.
	^self class real: u imaginary: v
]

{ #category : #'mathematical functions' }
Complex >> squared [
	"Answer the receiver multipled by itself."

	^self * self
]

{ #category : #arithmetic }
Complex >> squaredNorm [
	"Answer the square of receiver norm."

	^real * real + (imaginary * imaginary)
]

{ #category : #'mathematical functions' }
Complex >> tan [
	"Answer receivers tangent."

	^ self sin / self cos
]

{ #category : #'mathematical functions' }
Complex >> tanh [
	"Answer receiver's hyperbolic tangent."

	"Some possible implementation are:

	^self sinh / self cosh

	| tr ti |
	tr := real tanh.
	ti := imaginary tan i.
	^(tr + ti) / (tr * ti + 1)"

	^self i tan i negated
]
