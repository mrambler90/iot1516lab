#include "Timer.h"
#include "BlinkRadio.h"

module BlinkRadiofC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;
}
implementation
{

  // nx_ is a common endian-ness and word format
  // just to avoid problems in different platforms
  // we must use it in every piece of code if possible

  // Active Message allows multiplexing (nice)

  uint32_t counter = 0;

  event void Boot.booted()
  {
    call Timer0.startPeriodic( 50 );
  }

  event void Timer0.fired()
  {
    call Leds.set(++counter);
    
  }

}
