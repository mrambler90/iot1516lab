#ifndef RADIO_CHAT_H
#define RADIO_CHAT_H

typedef nx_struct radio_chat {
	nx_uint16_t nodeID;
	nx_uint8_t message[60];
} radio_chat_t;

enum {
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 500,
	AM_RADIO_CHAT = 0x99
};

#endif
