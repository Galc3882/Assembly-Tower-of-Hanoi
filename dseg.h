dseg segment
	board		db	0,0,0,0,0,0,0
				db	0,0,0,0,0,0,0
				db	0,0,0,0,0,0,0
	
	solvermoves	dw	1000 dup(?)
	from		dw	?
	to			dw	?
	
	num			db	3
	
	colLim		db	0,0,0
	
	x			dw	0
	y			dw	0
	
	highlight	dw	1
	pressed		dw	0
	lastB		db	?
	
	moves		dw	0
	
	Xlim		dw	?
	Ylim		dw	?
	
	num2str		dw	?
	
	buf    		db	6 dup (?)
	seconds		dw	0
	Rsec		db	0
	
	start0		db	'Enter a number from 3 to 6 $'
	start1		db	'Do you want me to solve it?	[Y,N] $'
	
	winS1		db	'You win $'
	winS2		db	'Number of moves: $'
	winS3		db	'Time: $'
	press		db	'Press escape to exit $'
	
dseg ends