#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration BlinkRadioAppC {
}
implementation {
	components MainC, BlinkRadioC, LedsC, PrintfC, SerialStartC;
	components ActiveMessageC;

	components new AMSenderC(AM_BLINKTORADIO);
	components new AMReceiverC(AM_BLINKTORADIO);
	components new TimerMilliC() as Timer0;

	BlinkRadioC -> MainC.Boot;
	BlinkRadioC.AMControl -> ActiveMessageC;
	BlinkRadioC.AMSend -> AMSenderC;
	BlinkRadioC.Packet -> AMSenderC;
	BlinkRadioC.Timer0 -> Timer0;
	BlinkRadioC.Leds -> LedsC;
	BlinkRadioC.Receive -> AMReceiverC;
	BlinkRadioC.AMPacket -> AMSenderC;
}
