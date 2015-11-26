# import pyserial library
import serial

# open the serial connection without timeout (blocking);
# the baudrate parameter is not mandatory but it's strongly
# recommended to include it
mote = serial.Serial('/dev/ttyUSB0', 38400)

# example: read a string from the serial port
# mote.read()

for i in range(0,10):
	mote.write('\x00\xff\xff\x00\x00\x01\x00\x09\x05')
	print mote.read(10)
