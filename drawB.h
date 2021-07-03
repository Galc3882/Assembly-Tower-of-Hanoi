	drawBox		proc 
			pop bx cx dx
			mov Xlim, cx
			mov Ylim, dx
			pop cx dx ax
			push bx
			push cx
			
			mov ah, 0ch
			mov bh, 0
	
	a:		pop cx
			push cx
			
			dec cx
	b:		inc cx
			int 10h
			cmp cx, [Xlim]
			jnz b
			inc dx
			cmp dx, [Ylim]
			jnz a
			
			pop cx
			ret
	drawBox		endp
	
	drawButtons	proc 
			push ax bx cx dx
			
			;first button
			push 6				;color
			push 170			;Ystart
			push 20				;Xstart
			push 190			;Ylim
			push 80				;Xlim
			call drawBox
			
			;second button
			push 6				;color
			push 170			;Ystart
			push 130			;Xstart
			push 190			;Ylim
			push 190			;Xlim
			call drawBox
			
			;third button
			push 6				;color
			push 170			;Ystart
			push 240			;Xstart
			push 190			;Ylim
			push 300			;Xlim
			call drawBox
			
			;pressed identification
			cmp pressed, 0
			jz noPr
			
			push 1				;color
			push 172			;Ystart
			
			mov cx, 25			
			mov dx, [pressed]
	bu2:	dec dx
			cmp dx, 0
			jz bu3
			add cx, 110
			jmp bu2
	bu3:	push cx				;Xstart
			
			push 188			;Ylim
			
			add cx, 50
			push cx				;Xlim
			
			call drawBox
	noPr:	
			;highlight identification
			push 2				;color
			push 175			;Ystart
			
			mov cx, 30			
			mov dx, [highlight]
	bu0:	dec dx
			cmp dx, 0
			jz bu1
			add cx, 110
			jmp bu0
	bu1:	push cx				;Xstart
			
			push 185			;Ylim
			
			add cx, 40
			push cx				;Xlim
			
			call drawBox
			
			pop dx cx bx ax
			ret
	drawButtons endp
	
	drawBoard	proc 
			push ax bx cx dx
			
			;first stick
			push 4				;color
			push 15				;Ystart
			push 40				;Xstart
			push 160			;Ylim
			push 60				;Xlim
			call drawBox
			
			;second stick
			push 4				;color
			push 15				;Ystart
			push 150			;Xstart
			push 160			;Ylim
			push 170			;Xlim
			call drawBox
			
			;third stick
			push 4				;color
			push 15				;Ystart
			push 260			;Xstart
			push 160			;Ylim
			push 280			;Xlim
			call drawBox
			
			;draw from array
			
			xor ax, ax			;set to 0
			xor bx, bx
			xor cx, cx
			xor dx, dx
			xor di, di
			xor si, si
			mov x, 0
			mov y, 0
			
	d7:		cmp colLim[di], 0	;check if stick has rings
			jnz d11
			jmp d8
	d11:	
			
	d6:		mov si, x			;color by disk num + offset
			mov bx, y
			mov al, board[si][bx]
			xor ah, ah
			add ax, 8
			push ax				;color
			
			mov cx, 140			;find Ystart by taking initial value and decricing by x position
			mov dx, x
			inc dx
	d0:		dec dx
			cmp dx, 0
			jz d1
			sub cx, 20
			jmp d0
	d1:		push cx				;Ystart
			
			mov cx, 50			;find the stick x position
			mov dx, di
			inc dx
	d4:		dec dx
			cmp dx, 0
			jz d3
			add cx, 110
			jmp d4
			
	d3:		sub cx, 45			;decries what was found above by half the size of the disk
			mov dx, 0
			mov al, num
			mov si, x
			mov bx, y
			sub al, board[si][bx]
			xor ah, ah
			inc al
	d10:	dec ax
			cmp ax, 0
			jz d5
			add dx, 5
			jmp d10
			
			
	d5:		pop ax				;get Ystart
			push ax
			
			add cx, dx
			push cx				;Xstart
			
			add ax, 15			;Ystart + y size of disk
			push ax				;Ylim
			
			add cx, 90			;Xstart + size of disk
			sub cx, dx
			sub cx, dx
			push cx				;Xlim
			
			call drawBox
			
			inc x				;move to next disk
			xor ax, ax
			mov al, colLim[di]
			cmp x, ax
			jz d12
			jmp d6
	d12:	
			
	d8:		inc di				;check num of disk
			cmp di, 3
			jz d9
			mov x, 0
			add y, 7			;move to next stick
			jmp d7
	d9:		
			pop dx cx bx ax
			ret
	drawBoard endp
	
	undrawBoard	proc 
			push ax bx cx dx
			
			xor ax, ax			;set to 0
			xor bx, bx
			xor cx, cx
			xor dx, dx
			xor di, di
			xor si, si
			mov x, 0
			mov y, 0
			
	d27:	cmp colLim[di], 0	;check if stick has rings
			jnz d211
			jmp d28
	d211:	
	d26:	push 0				;color
			
			mov cx, 140			;find Ystart by takeing initial value and decricing by x position
			mov dx, x
			inc dx
	d20:	dec dx
			cmp dx, 0
			jz d21
			sub cx, 20
			jmp d20
	d21:	push cx				;Ystart
			
			mov cx, 50			;find the stick x position
			mov dx, di
			inc dx
	d24:	dec dx
			cmp dx, 0
			jz d23
			add cx, 110
			jmp d24
			
	d23:	sub cx, 45			;decries what was found above by half the size of the disk
			mov dx, 0
			mov al, num
			mov si, x
			mov bx, y
			sub al, board[si][bx]
			xor ah, ah
			inc al
	d210:	dec ax
			cmp ax, 0
			jz d25
			add dx, 5
			jmp d210
			
	d25:	pop ax				;get Ystart
			push ax
			
			add cx, dx
			push cx				;Xstart
			
			add ax, 15			;Ystart + y size of disk
			push ax				;Ylim
			
			add cx, 90			;Xstart + size of disk
			sub cx, dx
			sub cx, dx
			push cx				;Xlim
			
			call drawBox
			
			inc x				;move to next disk
			xor ax, ax
			mov al, colLim[di]
			cmp x, ax
			jz d212
			jmp d26
	d212:	
	d28:	inc di				;check num of disk
			cmp di, 3
			jz d29
			mov x, 0
			add y, 7			;move to next stick
			jmp d27
	d29:		
			pop dx cx bx ax
			ret
	undrawBoard endp