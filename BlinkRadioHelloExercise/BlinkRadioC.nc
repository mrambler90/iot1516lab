#include "Timer.h"
#include "BlinkRadio.h"

module BlinkRadioC @safe() {
	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as AMControl;
}
implementation {

	uint32_t counter = 0;

	bool busy = FALSE;	  	// signal to get whether the radio is busy or not
	message_t pkt;		  	// the packet buffer
	char* hello = "HELLO";  // the string HELLO to be sent in the packet payload

	event void Boot.booted() {
		call AMControl.start();	 // start the radio module
	}


	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			// the radio is turned on
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
			printf("Timer started\n"); printfflush();
		}
		else {
			// otherwise, retry turning the radio on
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {}

	event void Timer0.fired() {
		// radio transmission, if MY former trasmission is not completed yet
		if (!busy) {
			// preparing the packet: retrieving the payload from the pkt packet,
			// so that we can modify it (we don't reinstance the packet structure again)
			BlinkToRadioMsg *packet = (BlinkToRadioMsg *)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));

			// writing the data in the message
			packet->nodeid = TOS_NODE_ID;
			strncpy((char *)packet->message, hello, strlen(hello));

			if (call AMSend.send(DESTID, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				busy = TRUE;
			}
			else {
				printf("HELLO Message to %u not sent!", DESTID); printfflush();
			}
		}
	}


	event void AMSend.sendDone(message_t *msg, error_t err) {
		if (&pkt == msg && err == SUCCESS) {
			BlinkToRadioMsg *packet = (BlinkToRadioMsg *)(call Packet.getPayload(msg, sizeof(BlinkToRadioMsg)));
			busy = FALSE;

			printf("Message %s sent correctly to %u!\n", (char*)packet->message, call AMPacket.destination(msg));
			call Leds.set(++counter);
		}
		else {
			printf("Error in sending packet: %d.\n", (int)err);
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg* pointer = (BlinkToRadioMsg*)payload;
			am_addr_t dstID = call AMPacket.destination(msg);
			am_addr_t srcID = call AMPacket.source(msg);

			if (dstID == TOS_NODE_ID) {
				if (strcmp("HELLO", (char*)pointer->message) == 0) {
					printf("Correct HELLO message received from %u.\n", srcID); printfflush();
				}
				else {
					printf("Wrong message received: %s.\n", (char*)pointer->message); printfflush();
				}
			else {
				printf("This packet %s is not for me, but it's from %u to %u!\n", (char*)pointer->message, srcID, dstID);
			}
		}

		return msg;
	}

}
