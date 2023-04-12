;
; Created: 7/16/2022 7:59:36 PM
; Author : Anuj Sevak
;

.INCLUDE "M32DEF.INC"

// INITIALIZE STACK
LDI R16, HIGH(RAMEND)
OUT SPH, R16
LDI R16, LOW(RAMEND)
OUT SPL, R16

SER R22
OUT DDRD, R22	; SET PORT B AS OUTPUT
OUT PORTD, R22	; TURN OFF LEDS INITIALLY

.DEF delayLowByte=R20
.DEF delayHighByte=R21

TRAFFICLIGHTS:	CBI PORTD, 0			; MAIN ROAD GREEN
				CBI PORTD, 7			; SIDE ROAD RED
				LDI delayLowByte, LOW(0x676A)
				LDI delayHighByte, HIGH(0x676A)
				CALL DELAY				; 40s DELAY
				SBI PORTD, 0			; MAIN ROAD CLEAR GREEN
				CBI PORTD, 1			; MAIN ROAD AMBER
				CBI PORTD, 6			; SIDE ROAD AMBER
				LDI delayLowByte, LOW(0xF85F)
				LDI delayHighByte, HIGH(0xF85F)
				CALL DELAY				; 2s DELAY
				SER R22
				OUT PORTD, R22			; CLEAR ALL LIGHTS
				CBI PORTD, 2			; MAIN ROAD RED
				CBI PORTD, 5			; SIDE ROAD GREEN
				LDI delayLowByte, LOW(0xB3B5)
				LDI delayHighByte, HIGH(0xB3B5)
				CALL DELAY				; 20s DELAY
				SBI PORTD, 5			; SIDE ROAD CLEAR GREEN
				CBI PORTD, 6			; SIDE ROAD AMBER
				CBI PORTD, 1			; MAIN ROAD AMBER
				LDI delayLowByte, LOW(0xF85F)
				LDI delayHighByte, HIGH(0xF85F)
				CALL DELAY				; 2s DELAY
				SER R22
				OUT PORTD, R22			; CLEAR ALL LIGHTS
				JMP TRAFFICLIGHTS		; CONTINUE FOREVER

DELAY:	OUT TCNT1H, delayHighByte		; LOAD TIMER1 HIGH FROM delayHighByte
		OUT TCNT1L, delayLowByte		; LOAD TIMER1 LOW FROM delayLowByte
		CLR R22
		OUT TCCR1A, R22
		LDI R22, 0b00000101
		OUT TCCR1B, R22					; Timer1, Normal mode, prescaling clk/1024
WAIT:	IN R16, TIFR					; read TIFR
		SBRS R16, TOV1					; if TOV1 is set, then DELAY IS OVER
		RJMP WAIT
		CLR R22
		OUT TCCR1A, R22
		OUT TCCR1B, R22					; stop Timer1
		LDI R22, 1<<TOV1
		OUT TIFR, R22					; clear TOV1 flag BY SETTING IT TO 1
		RET