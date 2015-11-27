#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 250
};

typedef nx_struct BlinkToRadioMsg {
	nx_uint16_t nodeid;
	nx_uint8_t message[10];
} BlinkToRadioMsg;

/*
	unused function: converts an ASCII string into
	an unsigned-8-bit array
*/
void ascii2int8(char* str, nx_uint8_t* dst, nx_uint16_t len) {
	int i = 0;

	for (i = 0; i < (strlen(str) < len ? strlen(str) : len - 1); i++) {
		dst[i] = (nx_uint8_t)(str[i]);
	}
	dst[i] = 0;
}

#endif
