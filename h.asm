include dseg.h

sseg segment stack
    dw 800 dup(?)
sseg ends

cseg segment
assume  cs:cseg, ss:sseg, ds:dseg

    include drawB.h
    
    number2string proc 
    
        ;FILL BUF WITH DOLLARS
        push si
        mov  cx, 6
        six_dollars:      
        mov  bl, '$'
        mov  [ si ], bl
        inc  si
        loop six_dollars
        pop  si

        mov bx, 10              ;DIGITS ARE EXTRACTED DIVIDING BY 10
        mov cx, 0               ;COUNTER FOR EXTRACTED DIGITS
        mov num2str, ax
        
        cmp ax, 100
        jnc cy0
        inc cx
        
    cy0:cmp ax, 10
        jnc cycle1
        inc cx
        cycle1:       
        mov  dx, 0              ;NECESSARY TO DIVIDE BY BX
        div  bx                 ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER
        push dx                 ;PRESERVE DIGIT EXTRACTED FOR LATER
        inc  cx                 ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED
        cmp  ax, 0              ;IF NUMBER IS
        jne  cycle1             ;NOT ZERO, LOOP
        
        mov ax, [num2str]
        cmp ax, 100
        jnc cy1
        push 0
        cmp ax, 10
    cy1:jnc cycle2
        push 0
        ;NOW RETRIEVE PUSHED DIGITS
        cycle2:  
        pop  dx        
        add  dl, 48             ;CONVERT DIGIT TO CHARACTER
        mov  [si], dl
        inc  si
        loop cycle2  

        ret
    endp
    
    drawT       proc
        display_time:          
        ; CONVERT SECONDS TO STRING  
                    ; NUMBER TO CONVERT TO STRING
        mov  ax, seconds        ; SECONDS IN AX
        lea  si, buf            ; VARIABLE WHERE STRING WILL BE STORED
        call number2string      ; CALL PROCEDURE THAT CONVERTS NUMBER TO STRING
        ; MOVE CURSOR
        mov  dl, 6              ; X
        mov  dh, 4              ; Y
        mov  ah, 2
        mov  bh, 0
        int  10h  
        ; DISPLAY STRING
        mov  ah, 9
        lea  dx, buf
        int  21h
    re:
        ret
    drawT       endp
    
    win     proc
        mov ax, dseg            ;graphic settings
        mov ds, ax
        mov ah, 0
        mov al, 13h
        int 10h 
        
        LEA DX, winS1           ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H 
        
        MOV  DL, 0              ;SCREEN COLUMN.
        MOV  DH, 2              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        
        LEA DX, winS2           ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H 
        
        MOV  DL, 18             ;SCREEN COLUMN.
        MOV  DH, 2              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        
        mov  ax, moves          ; SECONDS IN AX
        lea  si, buf            ; VARIABLE WHERE STRING WILL BE STORED
        call number2string      ; CALL PROCEDURE THAT CONVERTS NUMBER TO STRING
        mov  ah, 9
        lea  dx, buf
        int  21h
        
        MOV  DL, 0              ;SCREEN COLUMN.
        MOV  DH, 4              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        
        LEA DX, winS3           ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H 
        call drawT
        
        MOV  DL, 0              ;SCREEN COLUMN.
        MOV  DH, 6              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        LEA DX, press           ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H
        
        mov ah, 8
    wl: int 21h
        cmp al, 27
        jnz wl
        jmp en
        ret
    win     endp
    
    movedisk    proc
    
            xor ax, ax
            xor bx, bx
            xor cx, cx
            mov bx, [from]
            mov al, colLim[bx]  ;x of board 'from'
            cmp ax, 0
            jz ent6
            dec ax
            inc bx
    ent1:   dec bx
            cmp bx, 0
            jz ent2
            add cx, 7           ;y of board 'from'
            jmp ent1
    
    ent2:   mov si, ax
            add si, cx          ;place of 'from' disk
            
            xor ax, ax
            xor bx, bx
            xor cx, cx
            mov bx, [to]
            mov al, colLim[bx]  ;x of board 'to'
            cmp ax, 0
            jnz ent3
            inc ax
    ent3:   dec ax
            inc bx
    ent4:   dec bx
            cmp bx, 0
            jz ent5
            add cx, 7           ;y of board 'to'
            jmp ent4
    
    ent5:   mov di, ax
            add di, cx          ;place of 'to' disk
            
            cmp board[di], 0
            jz ent7
            mov al, board[di]
            cmp board[si], al
            jnc ent6
            
    ent7:   mov al, board[si]
            cmp board[di], 0
            jz ent8
            inc di
    ent8:   
            mov board[di], al
            mov board[si], 0
            mov bx, [from]
            dec colLim[bx]
            mov bx, [to]
            inc colLim[bx]
            inc moves
    ent6:   ret
    movedisk    endp
    
    solver      proc
        
        pop di                  ;return pointer
        pop si ax bx cx dx      ;si= index, ax= spare, bx= to, cx= from, dx= num
        push di
        cmp dx, 1
        jnz s0
        mov solvermoves[si], cx ;if n= 1
        add si, 2
        mov solvermoves[si], bx
        add si, 2
        ret
    
    s0: dec dx
        push dx cx ax bx
        push dx cx ax bx si     ;num of disk, from, spare, to, index of 'moves' array
        call solver
        
        pop bx ax cx dx
        inc dx
        mov solvermoves[si], cx
        add si, 2
        mov solvermoves[si], bx
        add si, 2
        
        dec dx
        push dx ax bx cx
        push dx ax bx cx si     ;num of disk, from, spare, to, index of 'moves' array
        call solver
        
        pop cx bx ax dx
        inc dx

        ret
    solver      endp
    
    solve       proc
        
        xor ax, ax
        mov al, [num]
        push ax 0 2 1 0         ;num of disk, from, to, spare, index of 'moves' array
        call solver
        
        mov ax, dseg            ;graphic settings
        mov ds, ax
        mov ah, 0
        mov al, 13h
        int 10h
        
        mov  ah, 2ch            ; GET SYSTEM TIME
        int  21h                ; SECONDS RETURN IN DH minuts in cl
        inc dh
        mov  Rsec, dh
        
        push 0
    s2: call drawBoard
        mov al, [num]           ;if collim= num => press escape to exit
        cmp colLim[2], al
        jnz s1
        
    s10:mov  ah, 2ch            ; GET SYSTEM TIME
        int  21h                ; SECONDS RETURN IN DH minuts in cl
        cmp  dh, Rsec
        jnz s10
        
        mov ax, dseg            ;graphic settings
        mov ds, ax
        mov ah, 0
        mov al, 13h
        int 10h 
        
        LEA DX, press           ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H
        
        mov ah, 8
    wl0:int 21h
        cmp al, 27
        jnz wl0
        jmp en
        
    s1: mov  ah, 2ch            ; GET SYSTEM TIME
        int  21h                ; SECONDS RETURN IN DH minuts in cl
        cmp  dh, Rsec
        jnz s1
        inc Rsec
        cmp Rsec, 60
        jnz s3
        mov Rsec, 0
    s3: call undrawBoard
        
        pop bx
        mov ax, [solvermoves[bx]];change board
        mov from, ax
        add bx, 2
        mov ax, [solvermoves[bx]]
        mov to, ax
        add bx, 2
        push bx
        call movedisk
        jmp s2
        
        ret
    solve       endp
    
    star    proc
        ;find num of disks
        MOV  DL, 0              ;SCREEN COLUMN.
        MOV  DH, 0              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        
        LEA DX, start0          ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H
        
        mov ah, 8
    nu0:int 21h
        cmp al, 51
        jc  nu0
        cmp al, 55
        jnc nu0
        
        sub al, 48
        mov num, al
        
        MOV  DL, 0              ;SCREEN COLUMN.
        MOV  DH, 2              ;SCREEN ROW.
        MOV  AH, 2              ;SERVICE TO SET CURSOR POSITION.
        MOV  BH, 0              ;PAGE NUMBER.
        INT  10H                ;BIOS SCREEN SERVICES.
        
        ;set disks starting point
        mov cl, num
        mov bx, 0
setBo:  mov board[bx], cl
        dec cl
        inc bx
        cmp cl, 0
        jnz setBo
        mov colLim[0], bl
        
        LEA DX, start1          ; loading the effective address
        MOV AH, 09H             ; for string display
        INT 21H
        
        mov ah, 8
        int 21h
        cmp al, 121
        jnz nu3
        call solve
    nu3:
        mov ax, dseg            ;graphic settings
        mov ds, ax
        mov ah, 0
        mov al, 13h
        int 10h

        call drawBoard
        call drawButtons
        
        ret
    star    endp

    Start:  
            mov ax, dseg            ;read dseg
            mov ds, ax
            
            mov ax, dseg            ;graphic settings
            mov ds, ax
            mov ah, 0
            mov al, 13h
            int 10h
            
            call star
    game:
            mov ah, 1
            int 16h                 ;check if input was given
            jnz km
            jmp nd
    km:     mov ah, 0
            int 16h                 ;get the input
            cmp al, 27              ;escape
            jnz c0
            jmp en
    c0:
            cmp al, 'a'
            jnz c1
            mov lastB, 'a'
            jmp movB
    c1:     cmp al, 'd'
            jnz c2
            mov lastB, 'd'
            jmp movB
    c2:     cmp al, 13              ;enter
            jnz c3
            jmp ent
    c3:     jmp nd
            
    movB:   cmp lastB, 'a'
            jnz movB0
            dec highlight
            cmp highlight, 0
            jnz movB1
            mov highlight, 3
            jmp movB1
    movB0:  inc highlight
            cmp highlight, 4
            jnz movB1
            mov highlight, 1
    movB1:  call drawButtons
            jmp nd
    
    ent:    cmp pressed, 0
            jnz ent0
            mov ax, [highlight] ;if nothing selected and pressed enter
            mov pressed, ax
            call drawButtons
            jmp nd
    
    ent0:   call undrawBoard
            mov ax, [pressed]
            mov from, ax
            dec from
            mov ax, [highlight]
            mov to, ax
            dec to
            call movedisk
            
            mov pressed, 0
            call drawButtons
            call drawBoard
            
            mov al, [num]
            cmp colLim[2], al
            jnz nd
            call win
            
    nd:     mov cl, 50
    dly1:   mov bx, 600       ;delay
    dly0:   mov ax, bx
            dec bx
            jnz dly0
            dec cl
            jnz dly1
            
            ; GET SYSTEM TIME
            mov  ah, 2ch
            int  21h                ; SECONDS RETURN IN DH minuts in cl
        
            cmp  dh, Rsec
            jne rw
            jmp game
    rw:
            mov Rsec, dh
            inc  seconds
            
            jmp game
    en: 
            int 3
cseg    ends
end     Start