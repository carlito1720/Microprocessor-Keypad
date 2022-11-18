#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex ; external LCD subroutines
extrn	keyboard_setup, find_column, find_row, combine, find_key ; external keyboard subroutines
	
psect	udata_acs   ; reserve data space in access ram
counter:	ds 1    ; reserve one byte for a counter variable
delay_count:	ds 1    ; reserve one byte for counter in the delay routine
letter_input:	ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

  
	
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	call	keyboard_setup	; setup ADC
	goto	start
	; keep going until finished
	
loop2:
    call    find_column
    call    find_row
    call    combine
    call    find_key
    movwf   letter_input, A
   

Letters:
	db	letter_input,0x0a
					; message, plus carriage return
	letters_l   EQU	2	; length of data
	align	2
    
    
start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(Letters)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(Letters)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(Letters)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	letters_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	after	 

after:
	movlw	letters_l	; output message to UART
	lfsr	2, myArray
	call	UART_Transmit_Message

	movlw	letters_l-1	; output message to LCD
				; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message
	goto	loop2
	

	
	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst