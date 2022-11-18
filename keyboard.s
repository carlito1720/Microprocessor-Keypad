#include <xc.inc>

global  keyboard_setup, find_column, find_row, combine, find_key

psect	udata_acs 
column:	    ds 1
row:	    ds 1
result:	    ds 1
   
psect	adc_code, class=CODE
    
keyboard_setup:
    movlb   15
    bsf	    REPU
    movlb   0
    clrf    LATE,A

find_column:
    movlw   0xF0
    movwf   TRISE, A
    movf    PORTE, A
    movwf   column, A
    
find_row:
    movlw   0x0F
    movwf   TRISE, A
    movf    PORTE, A
    movwf   row, A
    
combine:
    movf    row, A
    iorwf   column, A
    movwf   result, A
    movlw   11111111B
    xorwf   result, A
    movwf   result, A
 
kind_key:
    movlw   0x00
    cpfseq  result, A
    bra	    next1
    retlw   0x00
next1:
    movlw   01110111B
    cpfseq  result, A
    bra	    next2
    retlw   '1'
next2:
    movlw   10110111B
    cpfseq  result, A
    bra	    next3
    retlw   '2'
next3:
    movlw   11010111B
    cpfseq  result, A
    bra	    next4
    retlw   '3'
next4:
    movlw   11100111B
    cpfseq  result, A
    bra	    next5
    retlw   'F'
next5:
    movlw   01111011B
    cpfseq  result, A
    bra	    next6
    retlw   '4'
next6:
    movlw   10111011B
    cpfseq  result, A
    bra	    next7
    retlw   '5'
next7:
    movlw   11011011B
    cpfseq  result, A
    bra	    next8
    retlw   '6'
next8:
    movlw   11101011B
    cpfseq  result, A
    bra	    next9
    retlw   'E'
next9:
    movlw   01111101B
    cpfseq  result, A
    bra	    nextA
    retlw   '7'   
nextA:
    movlw   10111101B
    cpfseq  result, A
    bra	    nextB
    retlw   '8' 
nextB:
    movlw   11011101B
    cpfseq  result, A
    bra	    nextC
    retlw   '9' 
nextC:
    movlw   11101101B
    cpfseq  result, A
    bra	    nextD
    retlw   'D' 
nextD:
    movlw   01111110B
    cpfseq  result, A
    bra	    nextA
    retlw   'A' 
nextE:
    movlw   10111110B
    cpfseq  result, A
    bra	    nextF
    retlw   '0' 
nextF:
    movlw   11011110B
    cpfseq  result, A
    bra	    nextG
    retlw   'B'
nextG:
    movlw   11101110B
    cpfseq  result, A
    bra	    next
    retlw   'B' 
next:
    retlw   0x00
    
    