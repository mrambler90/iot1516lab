#include "Timer.h"
#include "RadioChat.h"

module RadioChatC {
	uses {
		// general wiring
		interface Boot;
		interface Leds;

		// radio wiring
		interface SplitControl as RadioControl;
		interface AMSend as RadioSend;
		interface Packet as RadioPacket;
		interface Receive as RadioReceive;

		// serial wiring
		interface SplitControl as SerialControl;
		interface Packet as SerialPacket;
		interface Receive as SerialReceive;
		interface AMSend as SerialSend;

		interface PacketLink;

	}
}
implementation {

	bool radio_locked = FALSE;
	bool serial_locked = FALSE;

	message_t radio_packet;
	radio_chat_t *serial_pkt;

	message_t serial_packet;
	radio_chat_t *radio_pkt;

	event void Boot.booted() {
		call SerialControl.start();
		call RadioControl.start();
	}

	/*
		Event triggered when the mote radio receives a message
		from the sink node.

		It relays the message to the serial client.
	*/
	event message_t* RadioReceive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		if (radio_locked) { return bufPtr; }
		else {
			serial_pkt = (radio_chat_t*)call SerialPacket.getPayload(&serial_packet, sizeof(radio_chat_t));
			radio_pkt = (radio_chat_t*)call RadioPacket.getPayload(&radio_packet, sizeof(radio_chat_t));
			if (serial_pkt == NULL || radio_pkt == NULL) { return bufPtr; }

			// if the packet can't be relayed because it's too big, then return
			if (call SerialPacket.maxPayloadLength() < sizeof(radio_chat_t)) { return bufPtr; }

			// fill the serial payload
			serial_pkt->nodeID = TOS_NODE_ID;
			strncpy(serial_pkt->message, radio_pkt->message, strlen(serial_pkt->message));
			if (call SerialSend.send(AM_BROADCAST_ADDR, &serial_packet, sizeof(radio_chat_t)) == SUCCESS) {
				radio_locked = TRUE; call Leds.led0Toggle();
			}
		}

		return bufPtr;
	}

	/*
		Event triggered when the mote radio receives a message
		from the serial client.

		It relays the packet to the sink node through the radio.
	*/
	event message_t* SerialReceive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		if (serial_locked) { return bufPtr; }
		else {
			serial_pkt = (radio_chat_t*)call SerialPacket.getPayload(&serial_packet, sizeof(radio_chat_t));
			radio_pkt = (radio_chat_t*)call RadioPacket.getPayload(&radio_pkt, sizeof(radio_chat_t));
			if (serial_pkt == NULL || radio_pkt == NULL) { return bufPtr; }

			// if the packet can't be relayed because it's too big, then return
			if (call RadioPacket.maxPayloadLength() < sizeof(radio_chat_t)) { return bufPtr; }

			// fill the radio payload
			radio_pkt->nodeID = TOS_NODE_ID;
			strncpy(radio_pkt->message, serial_pkt->message, strlen(serial_pkt->message));
			call PacketLink.setRetries(&radio_packet, 50);
			call PacketLink.setRetryDelay(&radio_packet, 100);
			if (call RadioSend.send(DESTID, &radio_packet, sizeof(radio_chat_t)) == SUCCESS) {
				serial_locked = TRUE;
			}
		}

		return bufPtr;
	}

	/*
		Event triggered when the mote radio starts sending
		data to the serial client. It just unlocks the radio component.
	*/
	event void RadioSend.sendDone(message_t* bufPtr, error_t error) {
		if (&radio_packet == bufPtr) { radio_locked = FALSE; }
	}

	/*
		Event triggered when the mote radio starts sending
		data to the serial client. It just unlocks the serial component.
	*/
	event void SerialSend.sendDone(message_t* bufPtr, error_t error) {
		if (&serial_packet == bufPtr) { serial_locked = FALSE; }
	}

	event void RadioControl.startDone(error_t err) {
		if (err == SUCCESS) { radio_locked = FALSE; }
		else { call RadioControl.start(); }
	}

	event void RadioControl.stopDone(error_t err) {}

	event void SerialControl.startDone(error_t err) {
		if (err == SUCCESS) { serial_locked = FALSE; }
		else { call SerialControl.start(); }
	}

	event void SerialControl.stopDone(error_t err) {}
}
