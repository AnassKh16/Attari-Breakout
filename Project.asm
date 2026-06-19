org 0x0100
jmp start

; ASCII Art Title
; ATTARI in 3D LaTeX style
title1: db ' ________  _________  _________  ________  ________  ___',0
title2: db '|\   __  \|\___   ___\\___   ___\\   __  \|\   __  \|\  \',0
title3: db '\ \  \|\  \|___ \  \_\|___ \  \_\ \  \|\  \ \  \|\  \ \  \',0
title4: db ' \ \   __  \   \ \  \     \ \  \ \ \   __  \ \   _  _\ \  \',0
title5: db '  \ \  \ \  \   \ \  \     \ \  \ \ \  \ \  \ \  \\  \\ \  \',0
title6: db '   \ \__\ \__\   \ \__\     \ \__\ \ \__\ \__\ \__\\ _\\ \__\',0
title7: db '    \|__|\|__|    \|__|      \|__|  \|__|\|__|\|__|\|__|\|__|',0
title8: db '',0
; BREAKOUT in hollow outlined style
title9: db '  ____                _                 _   ',0
title10: db ' | __ ) _ __ ___  __ _| | _____  _   _| |_ ',0
title11: db ' |  _ \|  __/ _ \/ _` | |/ / _ \| | | | __|',0
title12: db ' | |_) | | |  __/ (_| |   < (_) | |_| | |_ ',0
title13: db ' |____/|_|  \___|\__,_|_|\_\___/ \__,_|\__|',0
title14: db '                                            ',0

; Menu options
option1: db '1. Play Game',0
option2: db '2. Instructions',0
option3: db '3. Customization',0
option4: db '4. Exit',0


; Customization menu text
customTitle: db '===== CUSTOMIZATION =====',0
ballColorText: db 'Ball Color:',0
paddleColorText: db 'Paddle Color:',0
colorWhite: db '  White',0
colorGrey: db '  Grey',0
colorBlue: db '  Blue',0
colorRed: db '  Red',0
customInst1: db 'Use UP/DOWN arrows to navigate',0
customInst2: db 'Press ENTER to select',0
customInst3: db 'Press ESC to return',0

; Customization variables
ballColor: db 0x0F      ; Default white
paddleColor: db 0x1F    ; Default blue on white
customMenuSelection: db 0  ; 0=ball color, 1=paddle color
ballColorOption: db 0      ; 0=white, 1=grey, 2=blue, 3=red
paddleColorOption: db 0    ; 0=white, 1=grey, 2=blue, 3=red
ballColorSelected: db 0    ; 0=not selected, 1=selected
paddleColorSelected: db 0  ; 0=not selected, 1=selected

; Instructions text
instTitle: db '===== INSTRUCTIONS =====',0
instLine1: db 'Break all bricks to win!',0
instLine2: db 'Complete within 10 minutes!',0
instLine3: db '',0
instLine4: db 'Controls:',0
instLine5: db ' LEFT/RIGHT Arrows to Move',0
instLine6: db ' P - Pause/Unpause',0
instLine7: db ' ESC - Exit to Menu',0
instLine8: db '',0
instLine9: db 'Brick System:',0
instLine10: db ' Red (4 hits) = 15 pts',0
instLine11: db ' Cyan (3 hits) = 10 pts',0
instLine12: db ' Yellow (2 hits) = 5 pts',0
instLine13: db ' Green (1 hit) = 2 pts',0
instLine14: db ' Each hit = +1 pt bonus',0
instLine15: db '',0
instLine16: db 'Powerups:',0
instLine17: db '  L - Large Paddle (30s)',0
instLine18: db '  B - Bomb Ball',0
instLine19: db '  S - Shield (30s)',0
instLine20: db '  H - Extra Life',0
instLine21: db '',0
instLine22: db 'Curses (avoid!):',0
instLine23: db '  M - Multi Balls (30s)',0
instLine24: db '  F - Speed Up (30s)',0
instLine25: db '  D - Lose a Life',0
instBack: db 'Press ESC to return to menu',0
highScore: dw 0
highScoreText: db 'High Score: ',0
newHighScoreText: db 'NEW HIGH SCORE!',0


; Game variables
currentScreen: db 0
score: dw 0
lives: db 3
ballX: db 40
ballY: db 20
ballDX: db 1
ballDY: db -1
paddleX: db 35
paddleSize: db 10
gameOver: db 0

; Timer variables
timeMinutes: db 10
timeSeconds: db 0
timerCounter: dw 0

; Brick hit counts - stores current hits for each brick (0 = destroyed)
bricks: times 40 db 0

; Powerup brick flags (1 = has powerup, 0 = no powerup)
powerupBricks: times 40 db 0

curseBricks: times 40 db 0      ; Which bricks have curses (0=none, 5=multiply ball, 6=speed up, 7=deduct life)
multiplyBallTimer: dw 0          ; Timer for multiply ball curse
speedUpTimer: dw 0               ; Timer for speed up curse
normalBallSpeed: db 20           ; Store original ball speed (delayCounter threshold)
activeBall2X: db 0               ; Second ball X position
activeBall2Y: db 0               ; Second ball Y position
activeBall2DX: db 0              ; Second ball X direction
activeBall2DY: db 0              ; Second ball Y direction
activeBall2Active: db 0          ; Is second ball active?
oldBall2X: db 0
oldBall2Y: db 0
; Repeat for ball 3 and ball 4 (same pattern)
activeBall3X: db 0
activeBall3Y: db 0
activeBall3DX: db 0
activeBall3DY: db 0
activeBall3Active: db 0
oldBall3X: db 0
oldBall3Y: db 0
activeBall4X: db 0
activeBall4Y: db 0
activeBall4DX: db 0
activeBall4DY: db 0
activeBall4Active: db 0
oldBall4X: db 0
oldBall4Y: db 0

; Active powerups
activePowerupType: db 0    ; 0=none, 1=large paddle, 2=bomb ball, 3=shield, 4=heart
activePowerupX: db 0
activePowerupY: db 0
activePowerupFalling: db 0
powerupMoveCounter: db 0

; Bomb ball variables
bombBallActive: db 0
bombBallX: db 0
bombBallY: db 0
bombBallDY: db -1
bombBallMoveCounter: db 0

; Powerup timers (in game loops)
largePaddleTimer: dw 0
shieldTimer: dw 0
shieldFlashCounter: db 0

delayCounter: db 0
oldBallX: db 40
oldBallY: db 20
oldBombBallX: db 0
oldBombBallY: db 0
oldPaddleX: db 35

; Score and Lives display
scoreText: db 'Score: ',0
livesText: db 'Lives: ',0
timerText: db 'Time: ',0
colonText: db ':',0
gameOverText: db 'GAME OVER! Final Score: ',0
timeUpText: db 'TIME UP! Final Score: ',0
winText: db 'YOU WIN! Final Score: ',0
pressEsc: db 'Press ESC to return to menu',0
pausedText: db 'PAUSED - Press P to Resume',0
gamePaused: db 0    ; 0=not paused, 1=paused

; ==================== SOUND EFFECTS ====================

; Basic tone player (add this first)
playTone:
    ; AX = frequency in Hz, CX = duration (lower = shorter)
    push ax
    push bx
    push cx
    push dx
    
    mov bx, ax      ; Save frequency
    
    ; Calculate divisor for timer
    mov dx, 0x0012
    mov ax, 0x34DD
    div bx
    mov bx, ax
    
    ; Program PIT
    mov al, 0xB6
    out 0x43, al
    mov al, bl
    out 0x42, al
    mov al, bh
    out 0x42, al
    
    ; Turn on speaker
    in al, 0x61
    or al, 0x03
    out 0x61, al
    
    ; Delay for duration
delaySound:
    push cx
    mov cx, 0x0FFF
innerDelay:
    loop innerDelay
    pop cx
    loop delaySound
    
    ; Turn off speaker
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; 1. PADDLE HIT - Quick bounce sound
playPaddleHitSound:
    mov ax, 800
    mov cx, 1
    call playTone
    mov ax, 1000
    mov cx, 1
    call playTone
    ret

; 2. BRICK HIT (not destroyed) - Medium tap
playBrickHitSound:
    mov ax, 1200
    mov cx, 1
    call playTone
    mov ax, 1000
    mov cx, 1
    call playTone
    ret

; 3. BRICK DESTROYED - Satisfying pop
playBrickDestroySound:
    mov ax, 1500
    mov cx, 2
    call playTone
    mov ax, 2000
    mov cx, 2
    call playTone
    mov ax, 1800
    mov cx, 1
    call playTone
    ret

; 4. POWERUP OBTAINED - Happy ascending
playPowerupSound:
    mov ax, 600
    mov cx, 1
    call playTone
    mov ax, 800
    mov cx, 1
    call playTone
    mov ax, 1000
    mov cx, 1
    call playTone
    mov ax, 1400
    mov cx, 3
    call playTone
    ret

; 5. CURSE OBTAINED - Ominous descending
playCurseSound:
    mov ax, 1000
    mov cx, 2
    call playTone
    mov ax, 700
    mov cx, 2
    call playTone
    mov ax, 400
    mov cx, 3
    call playTone
    mov ax, 200
    mov cx, 4
    call playTone
    ret

; 6. BOMB BALL EXPLOSION - Big explosion
playExplosionSound:
    mov ax, 150
    mov cx, 1
    call playTone
    mov ax, 100
    mov cx, 2
    call playTone
    mov ax, 80
    mov cx, 2
    call playTone
    mov ax, 60
    mov cx, 3
    call playTone
    mov ax, 100
    mov cx, 1
    call playTone
    ret

; 7. GAME OVER - Sad descending
playGameOverSound:
    mov ax, 1000
    mov cx, 3
    call playTone
    mov ax, 800
    mov cx, 3
    call playTone
    mov ax, 600
    mov cx, 3
    call playTone
    mov ax, 400
    mov cx, 4
    call playTone
    mov ax, 200
    mov cx, 6
    call playTone
    ret

; 8. WIN GAME - Victory fanfare
playWinSound:
    mov ax, 800
    mov cx, 2
    call playTone
    mov ax, 1000
    mov cx, 2
    call playTone
    mov ax, 1200
    mov cx, 2
    call playTone
    mov ax, 1500
    mov cx, 3
    call playTone
    mov ax, 2000
    mov cx, 4
    call playTone
    mov ax, 2500
    mov cx, 5
    call playTone
    ret

; 9. GAME START - Arcade startup
playGameStartSound:
    mov ax, 500
    mov cx, 2
    call playTone
    mov ax, 700
    mov cx, 2
    call playTone
    mov ax, 900
    mov cx, 2
    call playTone
    mov ax, 1200
    mov cx, 3
    call playTone
    mov ax, 1500
    mov cx, 2
    call playTone
    mov ax, 1800
    mov cx, 4
    call playTone
    ret
	
clearScreen:
    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov cx, 2000
    mov ax, 0x0020
clearLoop:
    stosw
    loop clearLoop
    ret

printString:
    push bx
    mov bl, ah
    mov ax, 0xB800
    mov es, ax
printLoop:
    lodsb
    cmp al, 0
    je endPrint
    mov ah, bl
    stosw
    jmp printLoop
endPrint:
    pop bx
    ret

drawMainMenu:
    call clearScreen
    
    ; Draw ATTARI (3D LaTeX style in WHITE) - Moved left
    mov si, title1
    mov di, 490      ; Moved left from 542
    mov ah, 0x0F
    call printString
    
    mov si, title2
    mov di, 650
    call printString
    
    mov si, title3
    mov di, 810
    call printString
    
    mov si, title4
    mov di, 970
    call printString
    
    mov si, title5
    mov di, 1130
    call printString
    
    mov si, title6
    mov di, 1290
    call printString
    
    mov si, title7
    mov di, 1450
    call printString
    
    ; Draw BREAKOUT (hollow outlined style in YELLOW) - Moved left
    mov si, title9
    mov di, 1650
    mov ah, 0x0E     ; Yellow
    call printString
    
    mov si, title10
    mov di, 1810
    mov ah, 0x0E     ; Yellow
    call printString
    
    mov si, title11
    mov di, 1970
    mov ah, 0x0E     ; Yellow
    call printString
    
    mov si, title12
    mov di, 2130
    mov ah, 0x0E     ; Yellow
    call printString
    
    mov si, title13
    mov di, 2290
    mov ah, 0x0E     ; Yellow
    call printString
    
    mov si, title14
    mov di, 2450
    mov ah, 0x0E     ; Yellow
    call printString
    
    ; Menu options (centered)
    mov si, option1
    mov di, 2948
    mov ah, 0x0F
    call printString

    mov si, option2
    mov di, 3108
    call printString

    mov si, option3
    mov di, 3268
    call printString

    mov si, option4         
    mov di, 3428
    call printString

    ret
	
drawInstructions:
    call clearScreen
    
    ; Draw title (centered at top)
    mov si, instTitle
    mov di, 868
    mov ah, 0x0E
    call printString
    
    ; Line 1 & 2 (centered goals)
    mov si, instLine1
    mov di, 1188
    mov ah, 0x0F
    call printString
    
    mov si, instLine2
    mov di, 1348
    call printString
    
    ; === LEFT COLUMN: Controls & Brick System ===
    
    ; Controls header (row 9, column 2)
    mov si, instLine4
    mov di, 1604
    mov ah, 0x0B
    call printString
    
    ; Control items
    mov si, instLine5
    mov di, 1764
    mov ah, 0x0F
    call printString
    
    mov si, instLine6
    mov di, 1924
    call printString
    
    mov si, instLine7
    mov di, 2084
    call printString
    
    ; Brick System header (row 13, column 2)
    mov si, instLine9
    mov di, 2404
    mov ah, 0x0E
    call printString
    
    ; Brick items
    mov si, instLine10
    mov di, 2564
    mov ah, 0x0F
    call printString
    
    mov si, instLine11
    mov di, 2724
    call printString
    
    mov si, instLine12
    mov di, 2884
    call printString
    
    mov si, instLine13
    mov di, 3044
    call printString
    
    mov si, instLine14
    mov di, 3204
    call printString
    
    ; === MIDDLE COLUMN: Powerups ===
    
    ; Powerups header (row 9, column 29)
    mov si, instLine16
    mov di, 1658
    mov ah, 0x0A
    call printString
    
    ; Powerup items
    mov si, instLine17
    mov di, 1818
    mov ah, 0x0F
    call printString
    
    mov si, instLine18
    mov di, 1978
    call printString
    
    mov si, instLine19
    mov di, 2138
    call printString
    
    mov si, instLine20
    mov di, 2298
    call printString
    
    ; === RIGHT COLUMN: Curses ===
    
    ; Curses header (row 9, column 54)
    mov si, instLine22
    mov di, 1712
    mov ah, 0x0C
    call printString
    
    ; Curse items
    mov si, instLine23
    mov di, 1872
    mov ah, 0x0F
    call printString
    
    mov si, instLine24
    mov di, 2032
    call printString
    
    mov si, instLine25
    mov di, 2192
    call printString
    
    ; Bottom instruction (centered at row 22)
    mov si, instBack
    mov di, 3574
    mov ah, 0x0A
    call printString
    
    ret
	
drawCustomizationMenu:
    call clearScreen
    
    ; Draw title
    mov si, customTitle
    mov di, 868
    mov ah, 0x0E
    call printString
    
    ; Draw "Ball Color:" header
    mov si, ballColorText
    mov di, 1348
    mov ah, 0x0F
    call printString
    
    ; Draw ball color options with highlighting
    mov di, 1508
    mov si, colorWhite
    mov ah, 0x0F  ; Default white
    
    ; Check if navigating on this option
    cmp byte [customMenuSelection], 0
    jne skipBallNav1
    cmp byte [ballColorOption], 0
    jne skipBallNav1
    mov ah, 0x0E  ; Yellow text for navigation
    
skipBallNav1:
    ; Check if this option is SELECTED
    cmp byte [ballColorSelected], 1
    jne skipBallHighlight1
    cmp byte [ballColorOption], 0
    jne skipBallHighlight1
    mov ah, 0xE0  ; Yellow background when selected
    
skipBallHighlight1:
    call printString
	
    mov di, 1668
    mov si, colorGrey
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 0
    jne skipBallNav2
    cmp byte [ballColorOption], 1
    jne skipBallNav2
    mov ah, 0x0E
    
skipBallNav2:
    cmp byte [ballColorSelected], 1
    jne skipBallHighlight2
    cmp byte [ballColorOption], 1
    jne skipBallHighlight2
    mov ah, 0xE0
    
skipBallHighlight2:
    call printString
	
    mov di, 1828
    mov si, colorBlue
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 0
    jne skipBallNav3
    cmp byte [ballColorOption], 2
    jne skipBallNav3
    mov ah, 0x0E
    
skipBallNav3:
    cmp byte [ballColorSelected], 1
    jne skipBallHighlight3
    cmp byte [ballColorOption], 2
    jne skipBallHighlight3
    mov ah, 0xE0
    
skipBallHighlight3:
    call printString
	
    mov di, 1988
    mov si, colorRed
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 0
    jne skipBallNav4
    cmp byte [ballColorOption], 3
    jne skipBallNav4
    mov ah, 0x0E
    
skipBallNav4:
    cmp byte [ballColorSelected], 1
    jne skipBallHighlight4
    cmp byte [ballColorOption], 3
    jne skipBallHighlight4
    mov ah, 0xE0
    
skipBallHighlight4:
    call printString
    
    ; Draw "Paddle Color:" header
    mov si, paddleColorText
    mov di, 2148
    mov ah, 0x0F
    call printString
    
    ; Draw paddle color options with highlighting
    mov di, 2308
    mov si, colorWhite
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 1
    jne skipPaddleNav1
    cmp byte [paddleColorOption], 0
    jne skipPaddleNav1
    mov ah, 0x0E
    
skipPaddleNav1:
    cmp byte [paddleColorSelected], 1
    jne skipPaddleHighlight1
    cmp byte [paddleColorOption], 0
    jne skipPaddleHighlight1
    mov ah, 0xE0
    
skipPaddleHighlight1:
    call printString
	
    mov di, 2468
    mov si, colorGrey
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 1
    jne skipPaddleNav2
    cmp byte [paddleColorOption], 1
    jne skipPaddleNav2
    mov ah, 0x0E
    
skipPaddleNav2:
    cmp byte [paddleColorSelected], 1
    jne skipPaddleHighlight2
    cmp byte [paddleColorOption], 1
    jne skipPaddleHighlight2
    mov ah, 0xE0
    
skipPaddleHighlight2:
    call printString
	
    mov di, 2628
    mov si, colorBlue
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 1
    jne skipPaddleNav3
    cmp byte [paddleColorOption], 2
    jne skipPaddleNav3
    mov ah, 0x0E
    
skipPaddleNav3:
    cmp byte [paddleColorSelected], 1
    jne skipPaddleHighlight3
    cmp byte [paddleColorOption], 2
    jne skipPaddleHighlight3
    mov ah, 0xE0
    
skipPaddleHighlight3:
    call printString
	
    mov di, 2788
    mov si, colorRed
    mov ah, 0x0F
    
    cmp byte [customMenuSelection], 1
    jne skipPaddleNav4
    cmp byte [paddleColorOption], 3
    jne skipPaddleNav4
    mov ah, 0x0E
    
skipPaddleNav4:
    cmp byte [paddleColorSelected], 1
    jne skipPaddleHighlight4
    cmp byte [paddleColorOption], 3
    jne skipPaddleHighlight4
    mov ah, 0xE0
    
skipPaddleHighlight4:
    call printString
    
    ; Draw instructions
    mov di, 3108
    mov si, customInst1
    mov ah, 0x0A
    call printString
    
    mov di, 3268
    mov si, customInst2
    call printString
    
    mov di, 3428
    mov si, customInst3
    call printString
    
    ret
	
applyBallColor:
    ; Convert option to actual color code
    mov al, [ballColorOption]
    cmp al, 0
    je setBallWhite
    cmp al, 1
    je setBallGrey
    cmp al, 2
    je setBallBlue
    jmp setBallRed
    
setBallWhite:
    mov byte [ballColor], 0x0F
    ret
setBallGrey:
    mov byte [ballColor], 0x07
    ret
setBallBlue:
    mov byte [ballColor], 0x09
    ret
setBallRed:
    mov byte [ballColor], 0x0C
    ret

applyPaddleColor:
    ; Convert option to paddle color
    mov al, [paddleColorOption]
    cmp al, 0
    je setPaddleWhite
    cmp al, 1
    je setPaddleGrey
    cmp al, 2
    je setPaddleBlue
    jmp setPaddleRed
    
setPaddleWhite:
    mov byte [paddleColor], 0x1F
    ret
setPaddleGrey:
    mov byte [paddleColor], 0x17
    ret
setPaddleBlue:
    mov byte [paddleColor], 0x19
    ret
setPaddleRed:
    mov byte [paddleColor], 0x1C
    ret
	
initGame:
    mov word [score], 0
    mov byte [lives], 3
    mov byte [ballX], 40
    mov byte [ballY], 15
    mov byte [ballDX], 1
    mov byte [ballDY], -1
    mov byte [paddleX], 35
    mov byte [paddleSize], 10
    mov byte [gameOver], 0
    mov byte [delayCounter], 0
    mov byte [oldBallX], 40
    mov byte [oldBallY], 15
    mov byte [oldPaddleX], 35
    
    ; Initialize timer to 10 minutes
    mov byte [timeMinutes], 10
    mov byte [timeSeconds], 0
    mov word [timerCounter], 0
    
    ; Initialize powerup variables
    mov byte [activePowerupFalling], 0
    mov word [largePaddleTimer], 0
    mov word [shieldTimer], 0
    mov byte [shieldFlashCounter], 0
    mov byte [powerupMoveCounter], 0
    mov byte [bombBallActive], 0
    mov byte [bombBallMoveCounter], 0
    mov byte [activeBall2Active], 0
    mov byte [activeBall3Active], 0
    mov byte [activeBall4Active], 0
    mov word [multiplyBallTimer], 0
    mov word [speedUpTimer], 0
	mov byte [gamePaused], 0
    
    ; Initialize bricks with their max hit counts
    ; Row 1 (0-9): 4 hits - HARDEST
    mov di, bricks
    mov cx, 10
    mov al, 4
initRow1:
    mov [di], al
    inc di
    loop initRow1
    
    ; Row 2 (10-19): 3 hits
    mov cx, 10
    mov al, 3
initRow2:
    mov [di], al
    inc di
    loop initRow2
    
    ; Row 3 (20-29): 2 hits
    mov cx, 10
    mov al, 2
initRow3:
    mov [di], al
    inc di
    loop initRow3
    
    ; Row 4 (30-39): 1 hit - EASIEST
    mov cx, 10
    mov al, 1
initRow4:
    mov [di], al
    inc di
    loop initRow4
    
    ; Randomly assign powerups to 15 bricks with distribution:
    ; L (Large Paddle): 5 bricks (not on edges)
    ; S (Shield): 5 bricks  
    ; B (Bomb): 3 bricks
    ; H (Heart): 2 bricks
	
; Clear all powerup flags first
    mov di, powerupBricks
    mov cx, 40
    xor al, al
clearPowerupFlags:
    mov [di], al
    inc di
    loop clearPowerupFlags
    
    ; Now assign exactly 15 powerups randomly
    xor bx, bx  ; Counter for assigned powerups
    
assignPowerups:
    cmp bx, 15
    jge powerupsComplete
    
    ; Get random brick index (0-39)
    mov ah, 0x00
    int 0x1A        ; Get timer
    and dx, 0x003F  ; Mask to 0-63
    cmp dx, 40
    jge assignPowerups  ; Retry if >= 40
    
    ; Check if this brick already has a powerup
    mov si, powerupBricks
    add si, dx
    cmp byte [si], 0
    jne assignPowerups  ; Already has powerup, try again
    
    ; Determine powerup type based on count
    cmp bx, 2
    jl assignHeart2
    cmp bx, 5
    jl assignBomb2
    cmp bx, 10
    jl assignShield2
    
    ; Assign Large Paddle (check for edge)
    push ax
    mov ax, dx
    push dx
    xor dx, dx
    mov cx, 10
    div cx
    ; DX = column (0-9)
    cmp dx, 0
    je edgeRetry
    cmp dx, 9
    je edgeRetry
    
    ; Not on edge - OK to assign L
    pop dx
    pop ax
    mov byte [si], 1
    inc bx
    jmp assignPowerups
    
edgeRetry:
    pop dx
    pop ax
    jmp assignPowerups  ; Retry on different brick
    
assignHeart2:
    mov byte [si], 4
    inc bx
    jmp assignPowerups
    
assignBomb2:
    mov byte [si], 2
    inc bx
    jmp assignPowerups
    
assignShield2:
    mov byte [si], 3
    inc bx
    jmp assignPowerups
    
powerupsComplete:

; Clear all curse flags first
    mov di, curseBricks
    mov cx, 40
    xor al, al
clearCurseFlags:
    mov [di], al
    inc di
    loop clearCurseFlags
    
    ; Assign exactly 7 curses randomly (1 deduct life, 3 multiply, 3 speed up)
    xor bx, bx
    
assignCurses:
    cmp bx, 7
    jge cursesComplete
    
    ; Get random brick index (0-39)
    mov ah, 0x00
    int 0x1A
    and dx, 0x003F
    cmp dx, 40
    jge assignCurses
    
    ; Check if this brick already has curse or powerup
    mov si, curseBricks
    add si, dx
    cmp byte [si], 0
    jne assignCurses
    
    ; Also check powerups
    push si
    mov si, powerupBricks
    add si, dx
    cmp byte [si], 0
    pop si
    jne assignCurses  ; Skip if has powerup
    
    ; Assign curse type based on count
    cmp bx, 1
    jl assignDeductLife
    cmp bx, 4
    jl assignMultiply
    ; Otherwise assign speed up
    mov byte [si], 6
    inc bx
    jmp assignCurses
    
assignDeductLife:
    mov byte [si], 7
    inc bx
    jmp assignCurses
    
assignMultiply:
    mov byte [si], 5
    inc bx
    jmp assignCurses
    
cursesComplete:
    ret
	
drawBorder:
    mov ax, 0xB800
    mov es, ax
    
    ; Top border (row 1)
    mov di, 160
    mov cx, 80
    mov ax, 0x7FDB
topBorder:
    stosw
    loop topBorder
    
    ; Bottom border (row 24) - check if shield is active
    mov di, 3840
    mov cx, 80
    cmp word [shieldTimer], 0
    je normalBottomBorder
    mov ax, 0x6EDB  ; Yellow on brown (matches timer)
    jmp drawBottomBorder
normalBottomBorder:
    mov ax, 0x7FDB  ; White border normally
drawBottomBorder:
    stosw
    loop drawBottomBorder
    
    ; Side borders (rows 2-23)
    mov cx, 22
    mov di, 320
sideBorders:
    mov word [es:di], 0x7FDB
    mov word [es:di+158], 0x7FDB
    add di, 160
    loop sideBorders
    ret

updateBottomBorder:
    mov ax, 0xB800
    mov es, ax
    
    ; Update only bottom border (row 24)
    mov di, 3840
    mov cx, 80
    cmp word [shieldTimer], 0
    je normalBottomUpdate
    
    ; Shield active - flash between yellow and white (slower)
    inc byte [shieldFlashCounter]
    cmp byte [shieldFlashCounter], 50
    jl useYellow
    cmp byte [shieldFlashCounter], 100
    jl useWhite
    mov byte [shieldFlashCounter], 0
useYellow:
    mov ax, 0x6EDB  ; Yellow on brown (matches timer color exactly)
    jmp drawBottomUpdate
useWhite:
    mov ax, 0x7FDB  ; White
    jmp drawBottomUpdate
    
normalBottomUpdate:
    mov ax, 0x7FDB  ; White border normally
drawBottomUpdate:
    stosw
    loop drawBottomUpdate
    ret

; Draw bricks based on hit count
drawBricks:
    mov ax, 0xB800
    mov es, ax
    mov si, bricks
    
    ; Row 1 - Red (row 3) - 4 hits max
    mov di, 480
    mov cx, 10
    call drawBrickRowWithHits
    
    ; Row 2 - Brown (row 4) - 3 hits max
    mov di, 640
    mov cx, 10
    call drawBrickRowWithHits
    
    ; Row 3 - Yellow (row 5) - 2 hits max
    mov di, 800
    mov cx, 10
    call drawBrickRowWithHits
    
    ; Row 4 - Green (row 6) - 1 hit max
    mov di, 960
    mov cx, 10
    call drawBrickRowWithHits
    ret

drawBrickRowWithHits:
    push cx
drawBrickLoopHits:
    lodsb
    cmp al, 0
    jne brickHasHits
    jmp skipBrickHit
brickHasHits:
    
    ; Determine color based on hit count remaining
    mov dl, al
    
    ; Get row number by checking SI position
    push si
    mov ax, si
    sub ax, bricks
    dec ax
    pop si
    
    ; Determine base color for row
    cmp ax, 10
    jge notRow1
    jmp row1Color
notRow1:
    cmp ax, 20
    jge notRow2
    jmp row2Color
notRow2:
    cmp ax, 30
    jge notRow3
    jmp row3Color
notRow3:
    
    ; Row 4 color logic (1 hit brick - GREEN - EASIEST)
    mov ah, 0x22  ; Green
    jmp drawBrickBlock
    
row1Color:
    ; Row 1 - RED - 4 hits - HARDEST
    cmp dl, 4
    je r1_full
    cmp dl, 3
    je r1_high
    cmp dl, 2
    je r1_med
    mov ah, 0x40  ; Red darkest
    jmp drawBrickBlock
r1_med:
    mov ah, 0x44  ; Red medium
    jmp drawBrickBlock
r1_high:
    mov ah, 0x4C  ; Red bright
    jmp drawBrickBlock
r1_full:
    mov ah, 0x4C  ; Red full
    jmp drawBrickBlock
    
row2Color:
    ; Row 2 - CYAN - 3 hits
    cmp dl, 3
    je r2_full
    cmp dl, 2
    je r2_med
    mov ah, 0x30  ; Cyan damaged
    jmp drawBrickBlock
r2_med:
    mov ah, 0x33  ; Cyan medium
    jmp drawBrickBlock
r2_full:
    mov ah, 0x3B  ; Cyan full
    jmp drawBrickBlock
    
row3Color:
    ; Row 3 - YELLOW - 2 hits
    cmp dl, 2
    je r3_full
    mov ah, 0x60  ; Yellow 1 hit left (brown background to avoid flashing)
    jmp drawBrickBlock
r3_full:
    mov ah, 0x66  ; Yellow full (brown background to avoid flashing)
    
drawBrickBlock:
    mov al, 0xDB
    mov [es:di], ax
    mov [es:di+2], ax
    mov [es:di+4], ax
    mov [es:di+6], ax
    mov [es:di+8], ax
    mov [es:di+10], ax
    mov [es:di+12], ax
    mov [es:di+14], ax
    
skipBrickHit:
    add di, 16
    dec cx
    jnz drawBrickLoopHits
    pop cx
    ret

eraseOldPaddle:
    mov ax, 0xB800
    mov es, ax
    mov di, 3680
    xor ax, ax
    mov al, [oldPaddleX]
    shl ax, 1
    add di, ax
    
    mov ah, 0x00
    mov al, ' '
    mov cl, [paddleSize]
    xor ch, ch
eraseOldPaddleLoop:
    mov [es:di], ax
    add di, 2
    loop eraseOldPaddleLoop
    ret

drawPaddle:
    call eraseOldPaddle
    
    mov ax, 0xB800
    mov es, ax
    mov di, 3680
    xor ax, ax
    mov al, [paddleX]
    shl ax, 1
    add di, ax
    
    mov ah, 0x1F
    mov al, 0xDB
    mov cl, [paddleSize]
    xor ch, ch
    
    ; Track current column position
    mov bl, [paddleX]
    
drawPaddleLoop:
    ; Check if current column is within safe boundaries
    ; Left border is at column 1, right border is at column 78
    ; Safe drawing area is columns 2-77
    cmp bl, 1
    jle skipThisPaddleChar
    cmp bl, 78
    jge skipThisPaddleChar
    
    ; Draw paddle character
    mov ah, [paddleColor]
    mov al, 0xDB
    mov [es:di], ax
    
skipThisPaddleChar:
    add di, 2
    inc bl
    loop drawPaddleLoop
    
    mov al, [paddleX]
    mov [oldPaddleX], al
    ret

eraseOldBall:
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [oldBallY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [oldBallX]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    ret

eraseOldBall2:
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [oldBall2Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [oldBall2X]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    ret
	
eraseOldBall3:
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [oldBall3Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [oldBall3X]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    ret
	
eraseOldBall4:
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [oldBall4Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [oldBall4X]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    ret

drawBall:
    call eraseOldBall
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [ballY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [ballX]
    shl ax, 1
    add di, ax
    
    mov ah, [ballColor]  ; Use custom color
    mov al, 'O'
    mov [es:di], ax
    
    mov al, [ballX]
    mov [oldBallX], al
    mov al, [ballY]
    mov [oldBallY], al
    ret
	
drawBall2:
    cmp byte [activeBall2Active], 0
    je skipDrawBall2    ; Don't draw if inactive
    call eraseOldBall2
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [activeBall2Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [activeBall2X]
    shl ax, 1
    add di, ax
    
    mov ah, [ballColor]
    mov al, 'O'
    mov [es:di], ax
    
    mov al, [activeBall2X]
    mov [oldBall2X], al
    mov al, [activeBall2Y]
    mov [oldBall2Y], al

skipDrawBall2:
    ret
	
drawBall3:
    cmp byte [activeBall3Active], 0
    je skipDrawBall3    ; Don't draw if inactive
    call eraseOldBall3
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [activeBall3Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [activeBall3X]
    shl ax, 1
    add di, ax
    
    mov ah, [ballColor]
    mov al, 'O'
    mov [es:di], ax
    
    mov al, [activeBall3X]
    mov [oldBall3X], al
    mov al, [activeBall3Y]
    mov [oldBall3Y], al
	
skipDrawBall3:
    ret
	
drawBall4:
    cmp byte [activeBall4Active], 0
    je skipDrawBall4   ; Don't draw if inactive
    call eraseOldBall4
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [activeBall4Y]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [activeBall4X]
    shl ax, 1
    add di, ax
    
    mov ah, [ballColor]
    mov al, 'O'
    mov [es:di], ax
    
    mov al, [activeBall4X]
    mov [oldBall4X], al
    mov al, [activeBall4Y]
    mov [oldBall4Y], al
	
skipDrawBall4:
    ret
	
drawPowerup:
    cmp byte [activePowerupFalling], 0
    je noPowerupToDraw
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [activePowerupY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [activePowerupX]
    shl ax, 1
    add di, ax
    
    ; Draw powerup symbol based on type
    mov al, [activePowerupType]
    cmp al, 1
    je drawLargePaddleSymbol
    cmp al, 2
    je drawBombSymbol
    cmp al, 3
    je drawShieldSymbol
    cmp al, 4
    je drawHeartSymbol
	cmp al, 5
    je drawMultiplySymbol
    cmp al, 6
    je drawSpeedUpSymbol
    cmp al, 7
    je drawDeductLifeSymbol
    ; Default symbol
    mov ax, 0x0E50  ; 'P' in yellow
    jmp drawPowerupChar
drawLargePaddleSymbol:
    mov ax, 0x0A4C  ; 'L' in green (Large paddle)
    jmp drawPowerupChar
drawBombSymbol:
    mov ax, 0x0C42  ; 'B' in red (Bomb)
    jmp drawPowerupChar
drawShieldSymbol:
    mov ax, 0x0B53  ; 'S' in cyan (Shield)
    jmp drawPowerupChar
drawHeartSymbol:
    mov ax, 0x0D48  ; 'H' in magenta (Heart)
	jmp drawPowerupChar  
drawMultiplySymbol:
    mov ax, 0x4D4D  ; 'M' in red (Multiply - curse)
    jmp drawPowerupChar
drawSpeedUpSymbol:
    mov ax, 0x4D46  ; 'F' in red (Fast - curse)
    jmp drawPowerupChar
drawDeductLifeSymbol:
    mov ax, 0x4D44  ; 'D' in red (Death - curse)
drawPowerupChar:
    mov [es:di], ax
    
noPowerupToDraw:
    ret

erasePowerup:
    cmp byte [activePowerupFalling], 0
    je noPowerupToErase
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [activePowerupY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [activePowerupX]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    
noPowerupToErase:
    ret

drawStatus:
    mov ax, 0xB800
    mov es, ax
    
    ; Draw Score on left
    mov di, 164
    mov si, scoreText
    mov ah, 0x0F
    call printString
    
    mov ax, [score]
    call printNumber
    
    ; Draw Timer in center
    mov di, 232
    mov si, timerText
    mov ah, 0x0E
    call printString
    
    ; Print minutes (pad with space if single digit for alignment)
    xor ax, ax
    mov al, [timeMinutes]
    cmp al, 10
    jge printMinutesNormal
    
    ; Single digit - add space for alignment
    push ax
    mov al, ' '
    mov ah, 0x0E
    stosw
    pop ax
 
printMinutesNormal:
    call printNumber
    
    ; Print colon
    mov si, colonText
    mov ah, 0x0E
    call printString
    
    ; Print seconds (always 2 digits)
    xor ax, ax
    mov al, [timeSeconds]
    
    ; Calculate tens digit
    push ax
    mov bl, 10
    xor ah, ah
    div bl
    
    ; Print tens digit
    push ax
    add al, '0'
    mov ah, 0x0E
    stosw
    pop ax
    
    ; Print ones digit
    mov al, ah
    add al, '0'
    mov ah, 0x0E
    stosw
    pop ax
    
    ; Draw Lives on right
    mov di, 294
    mov si, livesText
    mov ah, 0x0F
    call printString
    
    xor ax, ax
    mov al, [lives]
    call printNumber
    ret

printNumber:
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10
    xor cx, cx
    
convertLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convertLoop
    
    mov ax, 0xB800
    mov es, ax
    
printDigits:
    pop ax
    add al, '0'
    mov ah, 0x0F
    stosw
    loop printDigits
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
drawPauseMessage:
    mov ax, 0xB800
    mov es, ax
    
    ; Draw top border (row 10)
    mov di, 1680    ; Adjust position for box
    mov cx, 34      ; Width of box
    mov ax, 0x0EDB  ; Yellow border
topPauseBorder:
    stosw
    loop topPauseBorder
    
    ; Draw sides and clear middle (row 11)
    mov di, 1840
    mov word [es:di], 0x0EDB     ; Left border
    mov word [es:di+66], 0x0EDB  ; Right border
    
    ; Clear middle area
    mov di, 1842
    mov cx, 32
    mov ax, 0x0020
clearPauseArea:
    stosw
    loop clearPauseArea
    
    ; Draw pause text (row 11, centered)
    mov di, 1844
    mov si, pausedText
    mov ah, 0x0E
    call printString
    
    ; Draw bottom border (row 12)
    mov di, 2000
    mov cx, 34
    mov ax, 0x0EDB
bottomPauseBorder:
    stosw
    loop bottomPauseBorder
    ret
	
checkWin:
    mov si, bricks
    mov cx, 40
checkWinLoop:
    lodsb
    cmp al, 0
    jne notWinYet
    loop checkWinLoop
    
    mov byte [gameOver], 2
    ret
    
notWinYet:
    ret

updatePowerupTimers:
    ; Update large paddle timer
    cmp word [largePaddleTimer], 0
    je checkShieldTimer
    dec word [largePaddleTimer]
    cmp word [largePaddleTimer], 0
    jne checkShieldTimer
    ; Timer expired - restore normal paddle and erase old paddle
    call eraseOldPaddle
    mov byte [paddleSize], 10
    
checkShieldTimer:
    ; Update shield timer
    cmp word [shieldTimer], 0
    je powerupTimersDone
    dec word [shieldTimer]
	
checkMultiplyTimer:
    cmp word [multiplyBallTimer], 0
    je checkSpeedUpTimer
    dec word [multiplyBallTimer]
    cmp word [multiplyBallTimer], 0
    jne checkSpeedUpTimer
    ; Timer expired - ERASE and deactivate all extra balls
    call eraseOldBall2
    mov byte [activeBall2Active], 0
    call eraseOldBall3
    mov byte [activeBall3Active], 0
    call eraseOldBall4
    mov byte [activeBall4Active], 0
    
checkSpeedUpTimer:
    cmp word [speedUpTimer], 0
    je powerupTimersDone
    dec word [speedUpTimer]
	
powerupTimersDone:
    ret

movePowerup:
    cmp byte [activePowerupFalling], 0
    je noPowerupToMove
    
    ; Only move powerup every 3rd call (slower than ball)
    inc byte [powerupMoveCounter]
    cmp byte [powerupMoveCounter], 2
    jl noPowerupToMove
    mov byte [powerupMoveCounter], 0
    
    call erasePowerup
    
    ; Move powerup down
    inc byte [activePowerupY]
    
    ; Check if reached paddle row
    cmp byte [activePowerupY], 23
    jne checkPowerupBottom
    
    ; Check if paddle caught it
    mov al, [activePowerupX]
    mov bl, [paddleX]
    cmp al, bl
    jl powerupMissed
    
    mov bl, [paddleX]
    add bl, [paddleSize]
    cmp al, bl
    jge powerupMissed
    
    ; Powerup caught! Activate it
    call activatePowerup
    mov byte [activePowerupFalling], 0
    jmp noPowerupToMove
    
checkPowerupBottom:
    ; Check if reached bottom
    cmp byte [activePowerupY], 24
    jl noPowerupToMove
    
powerupMissed:
    ; Powerup missed or went off screen
    mov byte [activePowerupFalling], 0
    
noPowerupToMove:
    ret

activatePowerup:
    mov al, [activePowerupType]
    cmp al, 1
    jne checkType2
    jmp activateLargePaddle
checkType2:
    cmp al, 2
    jne checkType3
    jmp activateBombBall
checkType3:
    cmp al, 3
    jne checkType4
    jmp activateShield
checkType4:
    cmp al, 4
    jne checkType5
    jmp activateHeart
checkType5:
    cmp al, 5
    jne checkType6
    jmp activateMultiply
checkType6:
    cmp al, 6
    jne checkType7
    jmp activateSpeedUp
checkType7:
    cmp al, 7
    jne powerupActivateDone
    jmp activateDeductLife
powerupActivateDone:
    ret
	
activateMultiply:
    call playCurseSound     
    ; Spawn additional ball based on how many are active
    cmp byte [activeBall2Active], 0
    je spawnBall2
    cmp byte [activeBall3Active], 0
    je spawnBall3
    cmp byte [activeBall4Active], 0
    je spawnBall4
    ret  ; All balls already active
    
spawnBall2:
    mov al, [ballX]
    mov [activeBall2X], al
    mov al, [ballY]
    mov [activeBall2Y], al
    mov byte [activeBall2DX], -1
    mov byte [activeBall2DY], -1
    mov byte [activeBall2Active], 1
    mov word [multiplyBallTimer], 5460  ; 30 seconds
    ret
    
spawnBall3:
    mov al, [ballX]
    mov [activeBall3X], al
    mov al, [ballY]
    mov [activeBall3Y], al
    mov byte [activeBall3DX], 1
    mov byte [activeBall3DY], -1
    mov byte [activeBall3Active], 1
    ret
    
spawnBall4:
    mov al, [ballX]
    mov [activeBall4X], al
    mov al, [ballY]
    mov [activeBall4Y], al
    mov byte [activeBall4DX], 0
    mov byte [activeBall4DY], -1
    mov byte [activeBall4Active], 1
    ret
    
activateSpeedUp:
    call playCurseSound   
    ; Reduce delay counter threshold to speed up ball
    mov byte [normalBallSpeed], 20  ; Save current
    mov word [speedUpTimer], 5460   ; 30 seconds
    ret
    
activateDeductLife:
    call playCurseSound   
    ; Instantly lose a life
    dec byte [lives]
    cmp byte [lives], 0
    jne lifeStillRemaining
    mov byte [gameOver], 1
lifeStillRemaining:
    ret
	
activateLargePaddle:
    call playPowerupSound     
    ; Set paddle to large size
    mov byte [paddleSize], 15
    ; Set timer to 30 seconds (30 seconds * 182 loops/sec = 5460)
    mov word [largePaddleTimer], 5460
    ret
    
activateBombBall:
    call playPowerupSound     
    ; Spawn bomb ball at paddle center, shooting upward
    mov al, [paddleX]
    mov bl, [paddleSize]
    shr bl, 1  ; Divide by 2 to get center
    add al, bl
    mov [bombBallX], al
    mov byte [bombBallY], 22  ; Just above paddle
    mov byte [bombBallDY], -1  ; Move upward
    mov byte [bombBallActive], 1
	mov al, [bombBallX]
    mov [oldBombBallX], al
    mov al, [bombBallY]
    mov [oldBombBallY], al
    ret
    
activateShield:
    call playPowerupSound  
    ; Set shield timer to 30 seconds
    mov word [shieldTimer], 5460
    ret
    
activateHeart:
    call playPowerupSound  
    ; Add one life (max 9)
    cmp byte [lives], 9
    jge heartMaxLives
    inc byte [lives]
heartMaxLives:
    ret

drawBombBall:
    cmp byte [bombBallActive], 0
    je noBombBallToDraw
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [bombBallY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [bombBallX]
    shl ax, 1
    add di, ax
    
    mov ax, 0x4C4F  ; Red 'O' to match ball style
    mov [es:di], ax
    
noBombBallToDraw:
    mov al, [bombBallX]
    mov [oldBombBallX], al
    mov al, [bombBallY]
    mov [oldBombBallY], al
    ret

eraseBombBall:
    cmp byte [bombBallActive], 0
    je noBombBallToErase
    
    mov ax, 0xB800
    mov es, ax
    xor ax, ax
    mov al, [oldBombBallY]
    mov bx, 160
    mul bx
    mov di, ax
    xor ax, ax
    mov al, [oldBombBallX]
    shl ax, 1
    add di, ax
    mov word [es:di], 0x0020
    
noBombBallToErase:
    ret

moveBombBall:
    cmp byte [bombBallActive], 0
    je noBombBallToMove
    
    call eraseBombBall
    
    ; Move bomb ball at same speed as regular ball
    mov al, [bombBallDY]
    add [bombBallY], al
    
    ; Save old position AFTER moving
    mov al, [bombBallX]
    mov [oldBombBallX], al
    mov al, [bombBallY]
    sub al, [bombBallDY]  ; Get the old Y position
    mov [oldBombBallY], al
    
    ; Check if hit top boundary
    cmp byte [bombBallY], 2
    jle bombBallDisappear
    
    ; Check if hit bricks area
    mov al, [bombBallY]
    cmp al, 3
    jl bombBallContinue
    cmp al, 7
    jge bombBallContinue
    
    ; In brick area - check for collision
    call checkBombBrickCollision
    cmp al, 1
    je bombExplode
    jmp bombBallContinue
	
bombExplode:
    call playExplosionSound   
    call explodeBombBall
    mov byte [bombBallActive], 0
    ret
    
bombBallDisappear:
    mov byte [bombBallActive], 0
    ret
    
bombBallContinue:
    ret
    
noBombBallToMove:
    ret
    cmp byte [bombBallActive], 0
    je noBombBallUpdate
    
    call eraseBombBall
    
    ; Move bomb ball (upward)
    mov al, [bombBallDY]
    add [bombBallY], al
    
    ; Check if hit top boundary
    cmp byte [bombBallY], 2
    jle bombBallDisappear
    
    ; Check if hit bricks area
    mov al, [bombBallY]
    cmp al, 3
    jl bombBallContinue
    cmp al, 7
    jge bombBallContinue
    
    ; In brick area - check for collision
    call checkBombBrickCollision
    cmp al, 1
    je bombExplode
    jmp bombBallContinue
   
noBombBallUpdate:
    ret

checkBombBrickCollision:
    ; Check if bomb hit a brick, return AL=1 if collision
    mov al, [bombBallY]
    cmp al, 3
    jl noBombCollision
    cmp al, 7
    jge noBombCollision
    
    ; Calculate brick index
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [bombBallX]
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    cmp al, 10
    jge noBombCollision
    
    add bx, ax
    mov si, bricks
    add si, bx
    
    cmp byte [si], 0
    je noBombCollision
    
    ; Collision detected!
    mov al, 1
    ret
    
noBombCollision:
    mov al, 0
    ret

explodeBombBall:
    ; Damage bricks in 3x3 area around bomb
    mov al, [bombBallY]
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [bombBallX]
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    add bx, ax  ; BX = center brick index
    
    ; Damage center brick and surrounding bricks
    call damageBrickAt
    
    ; Damage brick above (if exists)
    cmp bx, 10
    jl noAboveBrick
    push bx
    sub bx, 10
    call damageBrickAt
    pop bx
noAboveBrick:
    
    ; Damage brick below (if exists)
    cmp bx, 30
    jge noBelowBrick
    push bx
    add bx, 10
    call damageBrickAt
    pop bx
noBelowBrick:
    
    ; Damage brick left (if exists)
    push bx
    mov ax, bx
    xor dx, dx
    mov cx, 10
    div cx
    cmp dx, 0
    je noLeftBrick
    pop bx
    push bx
    dec bx
    call damageBrickAt
    pop bx
    jmp testRightBrick
noLeftBrick:
    pop bx
    
testRightBrick:
    ; Damage brick right (if exists)
    push bx
    mov ax, bx
    xor dx, dx
    mov cx, 10
    div cx
    cmp dx, 9
    je noRightBrick
    pop bx
    inc bx
    call damageBrickAt
    ret
noRightBrick:
    pop bx
    ret

damageBrickAt:
    ; Damage brick at index BX (decrease hit count)
    cmp bx, 40
    jge invalidBrickIndex
    
    mov si, bricks
    add si, bx
    cmp byte [si], 0
    je invalidBrickIndex
    
    dec byte [si]
    
    ; Award points if destroyed
    cmp byte [si], 0
    jne invalidBrickIndex
    
    ; Award points based on row
    cmp bx, 10
    jl bombRow1Points
    cmp bx, 20
    jl bombRow2Points
    cmp bx, 30
    jl bombRow3Points
    add word [score], 2
    ret
bombRow1Points:
    add word [score], 15
    ret
bombRow2Points:
    add word [score], 10
    ret
bombRow3Points:
    add word [score], 5
    
invalidBrickIndex:
    ret

updateTimer:
    ; Increment timer counter (approximately 18.2 ticks per second)
    inc word [timerCounter]
    cmp word [timerCounter], 182
    jl timerDone
    
    ; Reset counter and decrement seconds (now updates every 10 game loops = ~0.5 seconds real time)
    mov word [timerCounter], 0
    
    ; Check if seconds > 0
    cmp byte [timeSeconds], 0
    jne decrementSeconds
    
    ; Seconds is 0, check if minutes > 0
    cmp byte [timeMinutes], 0
    je timeExpired
    
    ; Decrement minutes and reset seconds to 59
    dec byte [timeMinutes]
    mov byte [timeSeconds], 59
    jmp timerDone
    
decrementSeconds:
    dec byte [timeSeconds]
    jmp timerDone
    
timeExpired:
    ; Time ran out - game over
    mov byte [gameOver], 3
    
timerDone:
    ret

moveBall:
    mov al, [ballDX]
    add [ballX], al
    mov al, [ballDY]
    add [ballY], al
    
    ; Left/right walls - handle bounds properly
    cmp byte [ballX], 2
    jle hitLeftWall
    cmp byte [ballX], 77
    jge hitRightWall
    jmp checkY
    
hitLeftWall:
    mov byte [ballX], 3      ; Force ball back in bounds
    neg byte [ballDX]
    jmp checkY
    
hitRightWall:
    mov byte [ballX], 76     ; Force ball back in bounds
    neg byte [ballDX]
    jmp checkY
    
reverseDX:
    neg byte [ballDX]
    
checkY:
    ; Top wall
    cmp byte [ballY], 2
    jg notTopWall
    jmp reverseDY
notTopWall:
    
    ; Check paddle collision (row 23)
    cmp byte [ballY], 22
    jge checkPaddleArea    
    jmp checkBricksCall   
	
checkPaddleArea:
    cmp byte [ballY], 22
    jne checkIfAtBottom    ; Not at paddle row yet
    
    ; ballY == 22, check if paddle hit
checkPaddleHit:
    mov al, [ballX]
    mov bl, [paddleX]
    cmp al, bl
    jl ballMissedPaddle    ; Ball is left of paddle - let it continue down
    
    mov bl, [paddleX]
    add bl, [paddleSize]
    cmp al, bl
    jge ballMissedPaddle   ; Ball is right of paddle - let it continue down 
    
    ; Ball hit paddle - bounce!
    jmp continuePaddleBounce
    
checkIfAtBottom:
    cmp byte [ballY], 23
    jge ballMissed         ; At bottom boundary (row 23 or 24) - missed!
    
ballMissedPaddle:
    jmp checkBricksCall    ; Still moving, check bricks
    
continuePaddleBounce:
    
; Ball hit the paddle - calculate bounce angle based on hit position
    neg byte [ballDY]
    call playPaddleHitSound    
    ; Calculate relative hit position (0 = leftmost of paddle)
    mov al, [ballX]
    sub al, [paddleX]  ; AL = hit position relative to paddle start
    
    ; Determine paddle size and calculate zones
    mov cl, [paddleSize]
    
    ; Zone 0-2: Extreme left - bounce hard left
    cmp al, 2
    jle bounceHardLeft
    
    ; Zone 3-4: Soft left - 45 degree left
    cmp al, 4
    jle bounceSoftLeft
    
   ; Calculate center zone dynamically
    mov bl, cl
    shr bl, 1  ; BL = paddleSize / 2 (center point)
    
    ; Check if EXACTLY at center (straight up) - narrower zone
    cmp al, bl
    je bounceStraight      ; Only exact center goes straight
    
    ; Zone 6-7 (or right before extreme right): Soft right - 45 degree right
    mov bl, cl 
    sub bl, 4
    cmp al, bl
    jge bounceSoftRight
    
    ; Zone 8-10 (extreme right): Bounce hard right
    mov bl, cl
    sub bl, 2
    cmp al, bl
    jge bounceHardRight
    
    ; Default: slight angle
    jmp bounceSoftRight
    
bounceHardLeft:
    mov byte [ballDX], -2  ; Fast left
    jmp paddleBounceEnd
    
bounceSoftLeft:
    mov byte [ballDX], -1  ; 45 degree left
    jmp paddleBounceEnd
    
bounceStraight:
    mov byte [ballDX], 0   ; Straight up
    jmp paddleBounceEnd
    
bounceSoftRight:
    mov byte [ballDX], 1   ; 45 degree right
    jmp paddleBounceEnd
    
bounceHardRight:
    mov byte [ballDX], 2   ; Fast right
    
paddleBounceEnd:
    call checkBricks
    ret
    
reverseDY:
    neg byte [ballDY]
    call checkBricks
    ret

ballMissed:
    ; Check if shield is active
    cmp word [shieldTimer], 0
    je noShieldActive
    
    ; Shield active - just bounce, no life lost
    neg byte [ballDY]
    call checkBricks
    ret
    
noShieldActive:
    ; Ball missed paddle - bounce off bottom boundary and lose a life
    neg byte [ballDY]
    dec byte [lives]
    
    ; Check if game over
    cmp byte [lives], 0
    jne checkBricksCall
    mov byte [gameOver], 1
    
checkBricksCall:
    call checkBricks
    ret

checkBricks:
    mov al, [ballY]
    cmp al, 3
    jge checkBricksUpper
    jmp doneBricksJmpFar
checkBricksUpper:
    cmp al, 7
    jl checkBricksInRange
    jmp doneBricksJmpFar
checkBricksInRange:
    
    ; Calculate brick index
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [ballX]
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    cmp al, 10
    jl checkBricksIndexOK
    jmp doneBricksJmpFar
checkBricksIndexOK:
    
    add bx, ax
    mov si, bricks
    add si, bx
    
    cmp byte [si], 0
    jne brickNotEmpty
    jmp doneBricksJmpFar
brickNotEmpty:
    
    ; Hit the brick - decrease hit count
    dec byte [si]
    
    ; Check if brick was destroyed
    cmp byte [si], 0
    je brickDestroyed
    jmp brickStillAliveJmp
    
brickDestroyed:
    call playBrickDestroySound 
    ; Brick destroyed - check if it has powerup
    push bx
    mov si, powerupBricks
    add si, bx
    cmp byte [si], 0
    je noDropPowerup
    
    ; Drop powerup if none is falling
    cmp byte [activePowerupFalling], 0
    jne noDropPowerup
    
    ; Calculate powerup drop position
    mov al, [ballX]
    mov [activePowerupX], al
    mov al, [ballY]
    mov [activePowerupY], al
    
    ; Get powerup type from brick
    mov al, [si]
    mov [activePowerupType], al
    mov byte [activePowerupFalling], 1
    
noDropPowerup:

; Check if brick has curse
    mov si, curseBricks
    add si, bx
    cmp byte [si], 0
    je noDropCurse
    
    ; Drop curse if none is falling
    cmp byte [activePowerupFalling], 0
    jne noDropCurse
    
    ; Drop curse (reuse powerup system but with types 5, 6, 7)
    mov al, [si]
    mov [activePowerupType], al
    mov byte [si], 0
    mov al, [ballX]
    mov [activePowerupX], al
    mov al, [ballY]
    mov [activePowerupY], al
    mov byte [activePowerupFalling], 1
    
noDropCurse:
    pop bx
	
    ; Award points based on which row
    cmp bx, 10
    jge notRow1Points
    jmp row1PointsJmp
notRow1Points:
    cmp bx, 20
    jge notRow2Points
    jmp row2PointsJmp
notRow2Points:
    cmp bx, 30
    jge notRow3Points
    jmp row3PointsJmp
notRow3Points:
    
    ; Row 4 - Green - EASIEST - 1 hit
    add word [score], 2
    jmp brickHitJmp
    
row1PointsJmp:
    ; Row 1 - Red - HARDEST - 4 hits
    add word [score], 15
    jmp brickHitJmp
    
row2PointsJmp:
    ; Row 2 - Brown - 3 hits
    add word [score], 10
    jmp brickHitJmp
    
row3PointsJmp:
    ; Row 3 - Yellow - 2 hits
    add word [score], 5
    
brickHitJmp:
    neg byte [ballDY]
    jmp doneBricksJmpFar
    
brickStillAliveJmp:
    ; Award 1 point for hitting but not destroying
    add word [score], 1
	 call playBrickHitSound  
    neg byte [ballDY]
    
doneBricksJmpFar:
    ret
	
;For ball 2
moveBall2:
    ; Check if ball 2 is active
    cmp byte [activeBall2Active], 0
    jne ball2IsActive
    jmp skipBall2Movement
	
ball2IsActive:
    mov al, [activeBall2DX]        ; Change: ballDX -> activeBall2DX
    add [activeBall2X], al         ; Change: ballX -> activeBall2X
    mov al, [activeBall2DY]        ; Change: ballDY -> activeBall2DY
    add [activeBall2Y], al         ; Change: ballY -> activeBall2Y
    
    ; Left/right walls - handle bounds properly
    cmp byte [activeBall2X], 2     ; Change: ballX -> activeBall2X
    jle hitLeftWall2
    cmp byte [activeBall2X], 77    ; Change: ballX -> activeBall2X
    jge hitRightWall2
    jmp checkY2
    
hitLeftWall2:
    mov byte [activeBall2X], 3     ; Change: ballX -> activeBall2X
    neg byte [activeBall2DX]       ; Change: ballDX -> activeBall2DX
    jmp checkY2
    
hitRightWall2:
    mov byte [activeBall2X], 76    ; Change: ballX -> activeBall2X
    neg byte [activeBall2DX]       ; Change: ballDX -> activeBall2DX
    jmp checkY2
    
reverseDX2:
    neg byte [activeBall2DX]       ; Change: ballDX -> activeBall2DX
    
checkY2:
    ; Top wall
    cmp byte [activeBall2Y], 2     ; Change: ballY -> activeBall2Y
    jg notTopWall2
    jmp reverseDY2
notTopWall2:
    
    ; Check paddle collision (row 23)
    cmp byte [activeBall2Y], 22    ; Change: ballY -> activeBall2Y
    jge checkPaddleArea2    
    jmp checkBricksCall2   
	
checkPaddleArea2:
    cmp byte [activeBall2Y], 22    ; Change: ballY -> activeBall2Y
    jne checkIfAtBottom2
    
checkPaddleHit2:
    mov al, [activeBall2X]         ; Change: ballX -> activeBall2X
    mov bl, [paddleX]
    cmp al, bl
    jl ballMissedPaddle2
    
    mov bl, [paddleX]
    add bl, [paddleSize]
    cmp al, bl
    jge ballMissedPaddle2
    
    jmp continuePaddleBounce2
    
checkIfAtBottom2:
    cmp byte [activeBall2Y], 23    ; Change: ballY -> activeBall2Y
    jge ballMissed2
    
ballMissedPaddle2:
    jmp checkBricksCall2
    
continuePaddleBounce2:
    neg byte [activeBall2DY]       ; Change: ballDY -> activeBall2DY
    
    mov al, [activeBall2X]         ; Change: ballX -> activeBall2X
    sub al, [paddleX]
    
    mov cl, [paddleSize]
    
    cmp al, 2
    jle bounceHardLeft2
    
    cmp al, 4
    jle bounceSoftLeft2
    
    mov bl, cl
    shr bl, 1
    
    cmp al, bl
    je bounceStraight2
    
    mov bl, cl 
    sub bl, 4
    cmp al, bl
    jge bounceSoftRight2
    
    mov bl, cl
    sub bl, 2
    cmp al, bl
    jge bounceHardRight2
    
    jmp bounceSoftRight2
    
bounceHardLeft2:
    mov byte [activeBall2DX], -2   ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd2
    
bounceSoftLeft2:
    mov byte [activeBall2DX], -1   ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd2
    
bounceStraight2:
    mov byte [activeBall2DX], 0    ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd2
    
bounceSoftRight2:
    mov byte [activeBall2DX], 1    ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd2
    
bounceHardRight2:
    mov byte [activeBall2DX], 2    ; Change: ballDX -> activeBall2DX
    
paddleBounceEnd2:
    call checkBricks2              ; Change: checkBricks -> checkBricks2
    ret
    
reverseDY2:
    neg byte [activeBall2DY]       ; Change: ballDY -> activeBall2DY
    call checkBricks2              ; Change: checkBricks -> checkBricks2
    ret

ballMissed2:
    ; Check if shield is active
    cmp word [shieldTimer], 0
    je noShieldActive2
    
    neg byte [activeBall2DY]       ; Change: ballDY -> activeBall2DY
    call checkBricks2              ; Change: checkBricks -> checkBricks2
    ret
    
noShieldActive2:
    ; Ball 2 missed - FIRST erase it, THEN deactivate and lose life
    call eraseOldBall2             ; Erase at OLD position (before deactivation)
    mov byte [activeBall2Active], 0 ; Deactivate it
    dec byte [lives]               ; Lose a life
    
    ; Check if game over
    cmp byte [lives], 0
    jne ball2MissComplete
    mov byte [gameOver], 1
    
ball2MissComplete:
    ret
    
checkBricksCall2:
    call checkBricks2              ; Change: checkBricks -> checkBricks2
    ret

skipBall2Movement:
    ret
	
checkBricks2:
    mov al, [activeBall2Y]         ; Change: ballY -> activeBall2Y
    cmp al, 3
    jge checkBricksUpper2
    jmp doneBricksJmpFar2
checkBricksUpper2:
    cmp al, 7
    jl checkBricksInRange2
    jmp doneBricksJmpFar2
checkBricksInRange2:
    
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [activeBall2X]         ; Change: ballX -> activeBall2X
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    cmp al, 10
    jl checkBricksIndexOK2
    jmp doneBricksJmpFar2
checkBricksIndexOK2:
    
    add bx, ax
    mov si, bricks
    add si, bx
    
    cmp byte [si], 0
    jne brickNotEmpty2
    jmp doneBricksJmpFar2
brickNotEmpty2:
    
    dec byte [si]
    
    cmp byte [si], 0
    je brickDestroyed2
    jmp brickStillAliveJmp2
    
brickDestroyed2:
      call playBrickDestroySound 
    ; Same powerup/curse drop logic as ball 1
    ; (Copy the entire brickDestroyed section from original checkBricks)
    
    push bx
    mov si, powerupBricks
    add si, bx
    cmp byte [si], 0
    je noDropPowerup2
    
    cmp byte [activePowerupFalling], 0
    jne noDropPowerup2
    
    mov al, [activeBall2X]         ; Change: ballX -> activeBall2X
    mov [activePowerupX], al
    mov al, [activeBall2Y]         ; Change: ballY -> activeBall2Y
    mov [activePowerupY], al
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [activePowerupFalling], 1
    
noDropPowerup2:
    
    ; Check curse drop (same as ball 1)
    mov si, curseBricks
    add si, bx
    cmp byte [si], 0
    je noDropCurse2
    
    cmp byte [activePowerupFalling], 0
    jne noDropCurse2
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [si], 0
    mov al, [activeBall2X]         ; Change: ballX -> activeBall2X
    mov [activePowerupX], al
    mov al, [activeBall2Y]         ; Change: ballY -> activeBall2Y
    mov [activePowerupY], al
    mov byte [activePowerupFalling], 1
    
noDropCurse2:
    pop bx
    
    ; Award points (same logic as ball 1)
    cmp bx, 10
    jge notRow1Points2
    jmp row1PointsJmp2
notRow1Points2:
    cmp bx, 20
    jge notRow2Points2
    jmp row2PointsJmp2
notRow2Points2:
    cmp bx, 30
    jge notRow3Points2
    jmp row3PointsJmp2
notRow3Points2:
    
    add word [score], 2
    jmp brickHitJmp2
    
row1PointsJmp2:
    add word [score], 15
    jmp brickHitJmp2
    
row2PointsJmp2:
    add word [score], 10
    jmp brickHitJmp2
    
row3PointsJmp2:
    add word [score], 5
    
brickHitJmp2:
    neg byte [activeBall2DY]       ; Change: ballDY -> activeBall2DY
    jmp doneBricksJmpFar2
    
brickStillAliveJmp2:
    add word [score], 1
    neg byte [activeBall2DY]       ; Change: ballDY -> activeBall2DY
    
doneBricksJmpFar2:
    ret
	
;For ball 3
moveBall3:
    ; Check if ball 3 is active
    cmp byte [activeBall3Active], 0
    jne ball3IsActive
    jmp skipBall3Movement
	
ball3IsActive:
    mov al, [activeBall3DX]        ; Change: ballDX -> activeBall2DX
    add [activeBall3X], al         ; Change: ballX -> activeBall2X
    mov al, [activeBall3DY]        ; Change: ballDY -> activeBall2DY
    add [activeBall3Y], al         ; Change: ballY -> activeBall2Y
    
    ; Left/right walls - handle bounds properly
    cmp byte [activeBall3X], 2     ; Change: ballX -> activeBall2X
    jle hitLeftWall3
    cmp byte [activeBall3X], 77    ; Change: ballX -> activeBall2X
    jge hitRightWall3
    jmp checkY3
    
hitLeftWall3:
    mov byte [activeBall3X], 3     ; Change: ballX -> activeBall2X
    neg byte [activeBall3DX]       ; Change: ballDX -> activeBall2DX
    jmp checkY3
    
hitRightWall3:
    mov byte [activeBall3X], 76    ; Change: ballX -> activeBall2X
    neg byte [activeBall3DX]       ; Change: ballDX -> activeBall2DX
    jmp checkY3
    
reverseDX3:
    neg byte [activeBall3DX]       ; Change: ballDX -> activeBall2DX
    
checkY3:
    ; Top wall
    cmp byte [activeBall3Y], 2     ; Change: ballY -> activeBall2Y
    jg notTopWall3
    jmp reverseDY3
notTopWall3:
    
    ; Check paddle collision (row 23)
    cmp byte [activeBall3Y], 22    ; Change: ballY -> activeBall2Y
    jge checkPaddleArea3   
    jmp checkBricksCall3  
	
checkPaddleArea3:
    cmp byte [activeBall3Y], 22    ; Change: ballY -> activeBall2Y
    jne checkIfAtBottom3
    
checkPaddleHit3:
    mov al, [activeBall3X]         ; Change: ballX -> activeBall2X
    mov bl, [paddleX]
    cmp al, bl
    jl ballMissedPaddle3
    
    mov bl, [paddleX]
    add bl, [paddleSize]
    cmp al, bl
    jge ballMissedPaddle3
    
    jmp continuePaddleBounce3
    
checkIfAtBottom3:
    cmp byte [activeBall3Y], 23    ; Change: ballY -> activeBall2Y
    jge ballMissed3
    
ballMissedPaddle3:
    jmp checkBricksCall3
    
continuePaddleBounce3:
    neg byte [activeBall3DY]       ; Change: ballDY -> activeBall2DY
    
    mov al, [activeBall3X]         ; Change: ballX -> activeBall2X
    sub al, [paddleX]
    
    mov cl, [paddleSize]
    
    cmp al, 2
    jle bounceHardLeft3
    
    cmp al, 4
    jle bounceSoftLeft3
    
    mov bl, cl
    shr bl, 1
    
    cmp al, bl
    je bounceStraight3
    
    mov bl, cl 
    sub bl, 4
    cmp al, bl
    jge bounceSoftRight3
    
    mov bl, cl
    sub bl, 2
    cmp al, bl
    jge bounceHardRight3
    
    jmp bounceSoftRight3
    
bounceHardLeft3:
    mov byte [activeBall3DX], -2   ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd3
    
bounceSoftLeft3:
    mov byte [activeBall3DX], -1   ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd3
    
bounceStraight3:
    mov byte [activeBall3DX], 0    ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd3
    
bounceSoftRight3:
    mov byte [activeBall3DX], 1    ; Change: ballDX -> activeBall2DX
    jmp paddleBounceEnd3
    
bounceHardRight3:
    mov byte [activeBall3DX], 2    ; Change: ballDX -> activeBall2DX
    
paddleBounceEnd3:
    call checkBricks3              ; Change: checkBricks -> checkBricks2
    ret
    
reverseDY3:
    neg byte [activeBall3DY]       ; Change: ballDY -> activeBall2DY
    call checkBricks3              ; Change: checkBricks -> checkBricks2
    ret

ballMissed3:
    ; Check if shield is active
    cmp word [shieldTimer], 0
    je noShieldActive3
    
    neg byte [activeBall3DY]       ; Change: ballDY -> activeBall2DY
    call checkBricks3              ; Change: checkBricks -> checkBricks2
    ret
    
noShieldActive3:
    ; Ball 3 missed - FIRST erase it, THEN deactivate and lose life
    call eraseOldBall3             ; Erase at OLD position (before deactivation)
    mov byte [activeBall3Active], 0 ; Deactivate it
    dec byte [lives]               ; Lose a life
    
    ; Check if game over
    cmp byte [lives], 0
    jne ball3MissComplete
    mov byte [gameOver], 1
    
ball3MissComplete:
    ret
    
checkBricksCall3:
    call checkBricks3              ; Change: checkBricks -> checkBricks2
    ret

skipBall3Movement:
    ret
	
checkBricks3:
    mov al, [activeBall3Y]         ; Change: ballY -> activeBall2Y
    cmp al, 3
    jge checkBricksUpper3
    jmp doneBricksJmpFar3
checkBricksUpper3:
    cmp al, 7
    jl checkBricksInRange3
    jmp doneBricksJmpFar3
checkBricksInRange3:
    
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [activeBall3X]         ; Change: ballX -> activeBall2X
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    cmp al, 10
    jl checkBricksIndexOK3
    jmp doneBricksJmpFar3
checkBricksIndexOK3:
    
    add bx, ax
    mov si, bricks
    add si, bx
    
    cmp byte [si], 0
    jne brickNotEmpty3
    jmp doneBricksJmpFar3
brickNotEmpty3:
    
    dec byte [si]
    
    cmp byte [si], 0
    je brickDestroyed3
    jmp brickStillAliveJmp3
    
brickDestroyed3:
    call playBrickDestroySound 
    ; Same powerup/curse drop logic as ball 1
    ; (Copy the entire brickDestroyed section from original checkBricks)
    
    push bx
    mov si, powerupBricks
    add si, bx
    cmp byte [si], 0
    je noDropPowerup3
    
    cmp byte [activePowerupFalling], 0
    jne noDropPowerup3
    
    mov al, [activeBall3X]         ; Change: ballX -> activeBall2X
    mov [activePowerupX], al
    mov al, [activeBall3Y]         ; Change: ballY -> activeBall2Y
    mov [activePowerupY], al
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [activePowerupFalling], 1
    
noDropPowerup3:
    
    ; Check curse drop (same as ball 1)
    mov si, curseBricks
    add si, bx
    cmp byte [si], 0
    je noDropCurse3
    
    cmp byte [activePowerupFalling], 0
    jne noDropCurse3
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [si], 0
    mov al, [activeBall3X]         ; Change: ballX -> activeBall2X
    mov [activePowerupX], al
    mov al, [activeBall3Y]         ; Change: ballY -> activeBall2Y
    mov [activePowerupY], al
    mov byte [activePowerupFalling], 1
    
noDropCurse3:
    pop bx
    
    ; Award points (same logic as ball 1)
    cmp bx, 10
    jge notRow1Points3
    jmp row1PointsJmp3
notRow1Points3:
    cmp bx, 20
    jge notRow2Points3
    jmp row2PointsJmp3
notRow2Points3:
    cmp bx, 30
    jge notRow3Points3
    jmp row3PointsJmp3
notRow3Points3:
    
    add word [score], 2
    jmp brickHitJmp3
    
row1PointsJmp3:
    add word [score], 15
    jmp brickHitJmp3
    
row2PointsJmp3:
    add word [score], 10
    jmp brickHitJmp3
    
row3PointsJmp3:
    add word [score], 5
    
brickHitJmp3:
    neg byte [activeBall3DY]       ; Change: ballDY -> activeBall2DY
    jmp doneBricksJmpFar3
    
brickStillAliveJmp3:
    add word [score], 1
    neg byte [activeBall3DY]       ; Change: ballDY -> activeBall2DY
    
doneBricksJmpFar3:
    ret

;For ball 4
moveBall4:
    ; Check if ball 4 is active
    cmp byte [activeBall4Active], 0
    jne ball4IsActive
    jmp skipBall4Movement
	
ball4IsActive:
    mov al, [activeBall4DX]
    add [activeBall4X], al
    mov al, [activeBall4DY]
    add [activeBall4Y], al
    
    ; Left/right walls - handle bounds properly
    cmp byte [activeBall4X], 2
    jle hitLeftWall4
    cmp byte [activeBall4X], 77
    jge hitRightWall4
    jmp checkY4
    
hitLeftWall4:
    mov byte [activeBall4X], 3
    neg byte [activeBall4DX]
    jmp checkY4
    
hitRightWall4:
    mov byte [activeBall4X], 76
    neg byte [activeBall4DX]
    jmp checkY4
    
reverseDX4:
    neg byte [activeBall4DX]
    
checkY4:
    ; Top wall
    cmp byte [activeBall4Y], 2
    jg notTopWall4
    jmp reverseDY4
notTopWall4:
    
    ; Check paddle collision (row 23)
    cmp byte [activeBall4Y], 22
    jge checkPaddleArea4   
    jmp checkBricksCall4  
	
checkPaddleArea4:
    cmp byte [activeBall4Y], 22
    jne checkIfAtBottom4
    
checkPaddleHit4:
    mov al, [activeBall4X]
    mov bl, [paddleX]
    cmp al, bl
    jl ballMissedPaddle4
    
    mov bl, [paddleX]
    add bl, [paddleSize]
    cmp al, bl
    jge ballMissedPaddle4
    
    jmp continuePaddleBounce4
    
checkIfAtBottom4:
    cmp byte [activeBall4Y], 23
    jge ballMissed4
    
ballMissedPaddle4:
    jmp checkBricksCall4
    
continuePaddleBounce4:
    neg byte [activeBall4DY]
    
    mov al, [activeBall4X]
    sub al, [paddleX]
    
    mov cl, [paddleSize]
    
    cmp al, 2
    jle bounceHardLeft4
    
    cmp al, 4
    jle bounceSoftLeft4
    
    mov bl, cl
    shr bl, 1
    
    cmp al, bl
    je bounceStraight4
    
    mov bl, cl 
    sub bl, 4
    cmp al, bl
    jge bounceSoftRight4
    
    mov bl, cl
    sub bl, 2
    cmp al, bl
    jge bounceHardRight4
    
    jmp bounceSoftRight4
    
bounceHardLeft4:
    mov byte [activeBall4DX], -2
    jmp paddleBounceEnd4
    
bounceSoftLeft4:
    mov byte [activeBall4DX], -1
    jmp paddleBounceEnd4
    
bounceStraight4:
    mov byte [activeBall4DX], 0
    jmp paddleBounceEnd4
    
bounceSoftRight4:
    mov byte [activeBall4DX], 1
    jmp paddleBounceEnd4
    
bounceHardRight4:
    mov byte [activeBall4DX], 2
    
paddleBounceEnd4:
    call checkBricks4
    ret
    
reverseDY4:
    neg byte [activeBall4DY]
    call checkBricks4
    ret

ballMissed4:
    ; Check if shield is active
    cmp word [shieldTimer], 0
    je noShieldActive4
    
    neg byte [activeBall4DY]
    call checkBricks4
    ret
    
noShieldActive4:
    ; Ball 4 missed - FIRST erase it, THEN deactivate and lose life
    call eraseOldBall4             ; Erase at OLD position (before deactivation)
    mov byte [activeBall4Active], 0 ; Deactivate it
    dec byte [lives]               ; Lose a life
    
    ; Check if game over
    cmp byte [lives], 0
    jne ball4MissComplete
    mov byte [gameOver], 1
    
ball4MissComplete:
    ret
    
checkBricksCall4:
    call checkBricks4
    ret

skipBall4Movement:
    ret
	
checkBricks4:
    mov al, [activeBall4Y]
    cmp al, 3
    jge checkBricksUpper4
    jmp doneBricksJmpFar4
checkBricksUpper4:
    cmp al, 7
    jl checkBricksInRange4
    jmp doneBricksJmpFar4
checkBricksInRange4:
    
    sub al, 3
    mov bl, 10
    mul bl
    mov bx, ax
    
    mov al, [activeBall4X]
    xor ah, ah
    mov cl, 8
    div cl
    xor ah, ah
    
    cmp al, 10
    jl checkBricksIndexOK4
    jmp doneBricksJmpFar4
checkBricksIndexOK4:
    
    add bx, ax
    mov si, bricks
    add si, bx
    
    cmp byte [si], 0
    jne brickNotEmpty4
    jmp doneBricksJmpFar4
brickNotEmpty4:
    
    dec byte [si]
    
    cmp byte [si], 0
    je brickDestroyed4
    jmp brickStillAliveJmp4
    
brickDestroyed4:
    call playBrickDestroySound 
    ; Same powerup/curse drop logic as ball 1
    
    push bx
    mov si, powerupBricks
    add si, bx
    cmp byte [si], 0
    je noDropPowerup4
    
    cmp byte [activePowerupFalling], 0
    jne noDropPowerup4
    
    mov al, [activeBall4X]
    mov [activePowerupX], al
    mov al, [activeBall4Y]
    mov [activePowerupY], al
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [activePowerupFalling], 1
    
noDropPowerup4:
    
    ; Check curse drop (same as ball 1)
    mov si, curseBricks
    add si, bx
    cmp byte [si], 0
    je noDropCurse4
    
    cmp byte [activePowerupFalling], 0
    jne noDropCurse4
    
    mov al, [si]
    mov [activePowerupType], al
    mov byte [si], 0
    mov al, [activeBall4X]
    mov [activePowerupX], al
    mov al, [activeBall4Y]
    mov [activePowerupY], al
    mov byte [activePowerupFalling], 1
    
noDropCurse4:
    pop bx
    
    ; Award points (same logic as ball 1)
    cmp bx, 10
    jge notRow1Points4
    jmp row1PointsJmp4
notRow1Points4:
    cmp bx, 20
    jge notRow2Points4
    jmp row2PointsJmp4
notRow2Points4:
    cmp bx, 30
    jge notRow3Points4
    jmp row3PointsJmp4
notRow3Points4:
    
    add word [score], 2
    jmp brickHitJmp4
    
row1PointsJmp4:
    add word [score], 15
    jmp brickHitJmp4
    
row2PointsJmp4:
    add word [score], 10
    jmp brickHitJmp4
    
row3PointsJmp4:
    add word [score], 5
    
brickHitJmp4:
    neg byte [activeBall4DY]
    jmp doneBricksJmpFar4
    
brickStillAliveJmp4:
    add word [score], 1
    neg byte [activeBall4DY]
    
doneBricksJmpFar4:
    ret


playGame:
    call initGame
    
    call clearScreen
	call playGameStartSound   
    call drawBorder
    
gameLoop:
    call updateBottomBorder
    call drawBricks
    call drawStatus
    call drawPaddle
    call drawBall
	call drawBall2
    call drawBall3
    call drawBall4
    call drawBombBall
    call drawPowerup
    
    cmp byte [gameOver], 0
    jne endGameCheck
    call checkWin
    call updateTimer
    call updatePowerupTimers
    

endGameCheck:
    cmp byte [gameOver], 0
    je continueGameLoop     
    jmp showEndScreen      

continueGameLoop:          
    
    inc byte [delayCounter]
 ; Check if speed curse is active
    cmp word [speedUpTimer], 0
    je normalSpeed
    cmp byte [delayCounter], 15  ; Faster when cursed
    jl skipBallMove
    jmp resetDelay
normalSpeed:
    cmp byte [delayCounter], 20
    jl skipBallMove
resetDelay:
    mov byte [delayCounter], 0
    call moveBall
	call moveBall2
    call moveBall3
    call moveBall4
    call movePowerup
    call moveBombBall
    
skipBallMove:
    mov cx, 0x3600
delayLoop:
    loop delayLoop
    
    mov ah, 0x01
    int 0x16
    jz gameLoop
    
    mov ah, 0x00
    int 0x16
    
    cmp ah, 0x01    ; ESC key
    jne checkPauseKey   
    jmp exitGame        

checkPauseKey:
    cmp ah, 0x19    ; P key scancode
    jne checkLeftKey
    
    ; Toggle pause state
    xor byte [gamePaused], 1    ; Toggle between 0 and 1
    
    ; If now paused, show pause message
    cmp byte [gamePaused], 1
    jne gameLoop    ; Not paused anymore, continue
    
    ; Draw pause message
    call drawPauseMessage
    
pauseWaitLoop:
    ; Wait for P key to unpause
    mov ah, 0x00
    int 0x16
    
   cmp ah, 0x01    ; ESC - exit even when paused
   jne checkPKeyInPause
   jmp exitGame

checkPKeyInPause:
    cmp ah, 0x19    ; P key
    jne pauseWaitLoop
    
    ; Unpause
    mov byte [gamePaused], 0
    
    ; ADD THIS: Clear the pause popup area completely
    mov ax, 0xB800
    mov es, ax
    mov di, 1680    ; Start of popup area (row 10)
    mov cx, 34
    mov ax, 0x0020  ; Black space
clearPauseRow1:
    stosw
    loop clearPauseRow1
    
    mov di, 1840    ; Row 11
    mov cx, 34
clearPauseRow2:
    stosw
    loop clearPauseRow2
    
    mov di, 2000    ; Row 12
    mov cx, 34
clearPauseRow3:
    stosw
    loop clearPauseRow3
    
    ; Now redraw everything
    call drawBorder
    call drawBricks
    call drawPaddle
    call drawBall
    call drawBall2
    call drawBall3
    call drawBall4
    call drawBombBall
    call drawPowerup
    call drawStatus
    
    jmp gameLoop    ; Resume game
	
checkLeftKey:            
    cmp ah, 0x4B
    je moveLeft
    
    cmp ah, 0x4D
    je moveRight
    
    jmp gameLoop
    
moveLeft:
    mov al, [paddleX]
    sub al, 2              ; Calculate new position
    cmp al, 2              ; Check if it would go past boundary
    jge doMoveLeft         ; If >= 2, safe to move
    mov byte [paddleX], 2  ; Otherwise, clamp to boundary
    jmp gameLoop
doMoveLeft:
    mov [paddleX], al      ; Apply the movement
    jmp gameLoop
    
moveRight:
    mov al, [paddleX]
    add al, [paddleSize]
    cmp al, 79
    jge gameLoop
    inc byte [paddleX]
    inc byte [paddleX]  ; Move 2 positions instead of 1
    mov al, [paddleX]
    add al, [paddleSize]
    cmp al, 79
    jl gameLoop
    mov al, 79
    sub al, [paddleSize]
    mov [paddleX], al  ; Ensure we don't go past boundary
    jmp gameLoop

showEndScreen:
    call clearScreen
    
    ; Check if current score beats high score
    mov ax, [score]
    cmp ax, [highScore]
    jle notNewHighScore
    
    ; New high score!
    mov [highScore], ax
    
    ; Display "NEW HIGH SCORE!" message
    mov di, 1440
    mov si, newHighScoreText
    mov ah, 0x0A  ; Bright green
    call printString
    
notNewHighScore:
    mov di, 1600
    
    cmp byte [gameOver], 1
    je showGameOverMsg
    
    cmp byte [gameOver], 3
    je showTimeUpMsg
    
    call playWinSound        
    ; Game over = 2 (Win)
    mov si, winText
    mov ah, 0x0E
    call printString
    jmp showFinalScore
    
showTimeUpMsg:
    mov si, timeUpText
    mov ah, 0x0C
    call printString
    jmp showFinalScore
    
showGameOverMsg:
    call playGameOverSound    
    mov si, gameOverText
    mov ah, 0x0C
    call printString
    
showFinalScore:
    mov ax, [score]
    call printNumber
    
    ; Display high score below current score
    mov di, 1760
    mov si, highScoreText
    mov ah, 0x0E
    call printString
    
    mov ax, [highScore]
    call printNumber
    
    mov di, 1920
    mov si, pressEsc
    mov ah, 0x0F
    call printString
    
waitEndKey:
    mov ah, 0x00
    int 0x16
    cmp ah, 0x01
    je exitGame            
    jmp waitEndKey        
    
exitGame:
    ret

start:
    mov ah, 0x01
    mov ch, 0x20
    mov cl, 0x00
    int 0x10
    
    mov byte [currentScreen], 0
    
mainLoop:
    cmp byte [currentScreen], 0
    je showMenu
    cmp byte [currentScreen], 1
    je showInst
    cmp byte [currentScreen], 2
    jne checkScreen3
    jmp startGame

checkScreen3:
	cmp byte [currentScreen], 3
    je showCustom
    
showMenu:
    call drawMainMenu
    
    mov ah, 0x00
    int 0x16
    
   cmp al, '1'
   je selectGame
   cmp al, '2'
   je selectInst
   cmp al, '3'
   je selectCustom
   cmp al, '4'
   jne notExitOption
   jmp exitProgram

notExitOption:
   jmp mainLoop
    
selectGame:
    mov byte [currentScreen], 2
    jmp mainLoop
    
selectInst:
    mov byte [currentScreen], 1
    jmp mainLoop
	
selectCustom:
    mov byte [ballColorSelected], 0
    mov byte [paddleColorSelected], 0
    mov byte [customMenuSelection], 0
    mov byte [currentScreen], 3
    jmp mainLoop
	
showInst:
    call drawInstructions

    
waitInstKey:
    mov ah, 0x00
    int 0x16
    cmp ah, 0x01
    je backToMenu
    jmp waitInstKey
    
backToMenu:
    mov byte [currentScreen], 0
    jmp mainLoop

showCustom:
    call drawCustomizationMenu
    
waitCustomKey:
    mov ah, 0x00
    int 0x16
    
   ; ESC - back to menu
   cmp ah, 0x01
   jne checkUpArrow
   jmp backToMenuFromCustom

checkUpArrow:
    
    ; UP arrow (0x48)
    cmp ah, 0x48
    je customMoveUp
    
    ; DOWN arrow (0x50)
    cmp ah, 0x50
    je customMoveDown
    
    ; ENTER (0x1C)
    cmp ah, 0x1C
    jne skipEnterKey
    jmp customSelect
    
skipEnterKey:
    
    jmp waitCustomKey
    
customMoveUp:
    ; Check which section we're in first
    cmp byte [customMenuSelection], 0
    je ballSectionUp
    
    ; We're in paddle section - check if paddle is selected
    cmp byte [paddleColorSelected], 1
    je waitCustomKey
    
    ; Paddle not selected yet - allow UP navigation
    dec byte [paddleColorOption]
    cmp byte [paddleColorOption], 0xFF  ; Underflow check
    jne redrawCustom
    mov byte [paddleColorOption], 3  ; Wrap to red
    jmp redrawCustom
    
ballSectionUp:
    ; Block if ball color already selected
    cmp byte [ballColorSelected], 1
    je waitCustomKey
    
    ; Currently on ball - move up through ball options
    dec byte [ballColorOption]
    cmp byte [ballColorOption], 0xFF  ; Underflow check
    jne redrawCustom
    mov byte [ballColorOption], 3  ; Wrap to red
    jmp redrawCustom
    
customMoveDown:
    ; Block if paddle color already selected
    cmp byte [paddleColorSelected], 1
    je waitCustomKey
    
    cmp byte [customMenuSelection], 0
    je moveDownBall
    ; Currently on paddle - move down through paddle options
    inc byte [paddleColorOption]
    cmp byte [paddleColorOption], 4
    jl redrawCustom
    mov byte [paddleColorOption], 0  ; Wrap to white
    jmp redrawCustom
    
moveDownBall:
    ; Currently on ball - check if moving to paddle or cycling
    inc byte [ballColorOption]
    cmp byte [ballColorOption], 4
    jl redrawCustom
    
    ; Ball color overflowed - check if it's selected before moving to paddle
    cmp byte [ballColorSelected], 1
    je allowMoveToPaddle
    
    ; Not selected yet - just wrap to white
    mov byte [ballColorOption], 0  ; Wrap to white
    jmp redrawCustom
    
allowMoveToPaddle:
    mov byte [ballColorOption], 0  ; Reset to white when moving
    mov byte [customMenuSelection], 1  ; Move to paddle
    
redrawCustom:
    call drawCustomizationMenu
    jmp waitCustomKey
    
customSelect:
    ; Apply selected color based on current selection
    cmp byte [customMenuSelection], 0
    je selectBallColor
    
   ; On paddle - apply paddle color
    call applyPaddleColor
    mov byte [paddleColorSelected], 1    ; Lock paddle selection
    call drawCustomizationMenu
    jmp waitCustomKey
    
selectBallColor:
    call applyBallColor
    mov byte [ballColorSelected], 1      ; Lock ball selection
    mov byte [customMenuSelection], 1    ; Move to paddle
    call drawCustomizationMenu
    jmp waitCustomKey
    
backToMenuFromCustom:
    mov byte [ballColorSelected], 0
    mov byte [paddleColorSelected], 0
    mov byte [customMenuSelection], 0
    mov byte [currentScreen], 0
    jmp mainLoop

startGame:
    call playGame
    mov byte [currentScreen], 0
    jmp mainLoop
    
exitProgram:
    ; Restore cursor
    mov ah, 0x01
    mov ch, 0x06
    mov cl, 0x07
    int 0x10
    
    ; Clear screen before exit
    call clearScreen
    
    ; Terminate program properly
    mov ax, 0x4C00
    int 0x21