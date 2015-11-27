Implementing a radio chat from mote 37 to the sink node 0.

make telosb install.37

Node ID 13 -> CC2420_DEF_CHANNEL = 12
AM_RADIO_MSG_ID = 0x99
structure:
		node id = 37
		message size 60

Attention! We need to set an higher upper bound.

For AMSender, we need to use AM_RADIO_MSG_ID = 0x99.
