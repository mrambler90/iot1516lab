#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration BlinkPrintfAppC
{
}
implementation
{
  components MainC, BlinkPrintfC, LedsC, PrintfC, SerialStartC;
  components new TimerMilliC() as Timer0;

  BlinkPrintfC -> MainC.Boot;

  BlinkPrintfC.Timer0 -> Timer0;
  BlinkPrintfC.Leds -> LedsC;
}
