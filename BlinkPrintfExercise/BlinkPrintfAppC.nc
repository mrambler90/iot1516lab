#define NEW_PRINTF_SEMANTICS

configuration BlinkPrintfAppC
{
}
implementation
{
  components MainC, BlinkPrintfC, LedsC, PrintfC;
  components new TimerMilliC() as Timer0;

  BlinkPrintfC -> MainC.Boot;

  BlinkPrintfC.Timer0 -> Timer0;
  BlinkPrintfC.Leds -> LedsC;
}
