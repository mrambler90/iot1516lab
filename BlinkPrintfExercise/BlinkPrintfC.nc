#include "Timer.h"
#include "printf.h"

module BlinkPrintfC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;
}
implementation
{

  uint32_t counter = 0;

  event void Boot.booted()
  {
    call Timer0.startPeriodic( 50 );
  }

  event void Timer0.fired()
  {
    counter++;
    printf("Timer triggered! I'm at clock %d!", counter);
    if (counter % 2 == 1)
      call Leds.led0On();
    else
      call Leds.led0Off();

    if (counter % 4 >= 2)
      call Leds.led1On();
    else
      call Leds.led1Off();

    if (counter % 8 >= 4)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

}
