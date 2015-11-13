#include "Timer.h"
#include "BlinkRadio.h"

module BlinkRadioC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
}
implementation
{

  // nx_ is a common endian-ness and word format
  // just to avoid problems in different platforms
  // we must use it in every piece of code if possible

  // Active Message allows multiplexing (nice)

  uint32_t counter = 0;

  bool busy = FALSE;  // signal to get whether the radio is busy or not
  message_t pkt;      // the packet buffer




  event void Boot.booted()
  {
    call AMControl.start();             // start the radio module
  }


  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {   // the radio is turned on
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {                  // otherwise, retry turning the radio on
      call AMControl.start();
    }
  }
  event void AMControl.stopDone(error_t err) {
  }



  event void Timer0.fired()
  {

    // radio transmission, if MY former trasmission is not completed yet
    if (!busy) {
      // preparing the packet: retrieving the payload from the pkt packet,
      // so that we can modify it (we don't reinstance the packet structure again)
      BlinkToRadioMsg *packet = (BlinkToRadioMsg *)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
      
      // writing the data in the message
      packet->nodeid = TOS_NODE_ID;
      packet->counter = counter;

      // packet sending: the radio may be busy for other processes, or it may fail someway else!
      // the message is broadcasted, so everybody can read it
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }


  event void AMSend.sendDone(message_t *msg, error_t err) {
    if (&pkt == msg && err == SUCCESS) {
      busy = FALSE;
      printf("Message %d sent correctly!", (int)msg->data);
      call Leds.set(++counter);
    }
    else {
      printf("Error in sending packet: %d.", (int)err);
    }
  }

}