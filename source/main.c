#include <avr/io.h>
#ifdef _SIMULATE_
#include "simAVRHeader.h"
#endif

enum States{Start, Open, Closed, FinishClose, WaitZero, WaitComplete, FinishComplete, Up, Down} state;
unsigned char tempA = 0x00;
unsigned char floor;
unsigned char goingDown;

void Tick() {
	switch(state) {
		case Start:
			state = Open;
			break;
		case Open:
			if((PINA & 0x40) == 0x00) { state = Open; }
			else { state = FinishClose; }
			break;
		case FinishClose:
			if(PINA == 0x00) { state = Closed; }
                        break;
		case Closed:
			tempA = PINA & 0x1F;
			if(floor == tempA) {
				PORTB = 0x20;
				state = Closed;
			}
			else if((tempA == 0x01)) {
				PORTB = tempA | 0xA0;
				goingDown = 0x00;
				state = WaitZero;
			}
			else if((tempA == 0x02) && tempA < floor) {
				PORTB = tempA | 0xA0;
				goingDown = 0x00;
				state = WaitZero;
			}
			else if((tempA == 0x02) && tempA > floor) {
				PORTB = tempA | 0x60;
				goingDown = 0x01;
				state = WaitZero;
			}
			else if((tempA == 0x04) && tempA < floor) {
                                PORTB = tempA | 0xA0;
				goingDown = 0x00;
                                state = WaitZero;
			}
                        else if((tempA == 0x04) && tempA > floor) {
                                PORTB = tempA | 0x60;
				goingDown = 0x01;
                                state = WaitZero;
			}
			else if((tempA == 0x08) && tempA < floor) {
                                PORTB = tempA | 0xA0;
				goingDown = 0x00;
                                state = WaitZero;
			}
                        else if((tempA == 0x08) && tempA > floor) {
                                PORTB = tempA | 0x60;
				goingDown = 0x01;
                                state = WaitZero;
			}
			else if(tempA == 0x10) {
				PORTB = tempA | 0x60;
				goingDown = 0x01;
				state = WaitZero;
			}
			else {
				PORTB = 0x20;
				state = Closed;
			}
			break;
		case WaitZero:
			if(PINA == 0x00) { state = WaitComplete; }
			break;
		case WaitComplete:
			if((PINA & 0x80) == 0x80) { state = FinishComplete; }
			break;
		case FinishComplete:
			if(((PINA & 0x80) == 0x00) && (goingDown == 0x00)) { state = Down; }
			else if(((PINA & 0x80) == 0x00) && (goingDown == 0x01)) { state = Up; }
			break;
		case Up:
			floor = floor << 1;
			if(floor == tempA) {
			        PORTB = 0x00;	
				state = Open;
			}
			else { state = WaitComplete; }
			break;
		case Down:
			floor = floor >> 1;
                        if(floor == tempA) {
				PORTB = 0x00;
				state = Open;
			}
                        else { state = WaitComplete; }
                        break;

	}
}

int main(void) {
	DDRA = 0x00; PORTA = 0xFF;
        DDRB = 0xFF; PORTB = 0x00;
	state = Start;
	floor = 0x01;
	while(1) { Tick(); }
	return 1;
}
