#define NEW_PRINTF_SEMANTICS

configuration BlinkRadioAppC
{
}
implementation
{
  components MainC, BlinkRadioC, LedsC;
  components new TimerMilliC() as Timer0;

  BlinkRadioC -> MainC.Boot;

  BlinkRadioC.Timer0 -> Timer0;
  BlinkRadioC.Leds -> LedsC;
}
