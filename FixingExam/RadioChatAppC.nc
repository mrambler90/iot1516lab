#include "RadioChat.h"
#define NEW_PRINTF_SEMANTICS

configuration RadioChatAppC {}
implementation {

	// used components
	components RadioChatC as App, LedsC, MainC;
	components PrintfC, SerialStartC;
	components SerialActiveMessageC as SAM;
	components ActiveMessageC as AM;
	components PacketLinkC;

	components new AMSenderC(AM_RADIO_CHAT);
	components new AMReceiverC(AM_RADIO_CHAT);

	// general wiring
	App.Boot -> MainC.Boot;
	App.Leds -> LedsC;
	App.PacketLink -> PacketLinkC;

	// radio communication wiring
	App.RadioControl -> AM;
	App.RadioSend -> AMSenderC;
	App.RadioPacket -> AMSenderC;
	App.RadioReceive -> AMReceiverC;

	// serial communication wiring
	App.SerialControl -> SAM;
	App.SerialPacket -> SAM;
	App.SerialReceive -> SAM.Receive[AM_RADIO_CHAT];
	App.SerialSend -> SAM.AMSend[AM_RADIO_CHAT];

}
