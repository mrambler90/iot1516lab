COMPONENT=RadioChatAppC
BUILD_EXTRA_DEPS += TestSerial.class
CLEAN_EXTRA = *.class TestSerialMsg.java

CFLAGS += -I$(TINYOS_OS_DIR)/tos/lib/printf
CFLAGS += -DPRINTF_BUFFER=6042
CFLAGS += -DCC2420_DEF_CHANNEL=12 -DTOSH_DATA_LENGTH=70
CFLAGS += -I$(TOSDIR)/lib/T2Hack
CFLAGS += -DPACKET_LINK

DEST=0U
CFLAGS += -DDESTID=$(DEST)

TestSerial.class: $(wildcard *.java) TestSerialMsg.java
	javac -target 1.4 -source 1.4 *.java

TestSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=TestSerialMsg RadioChat.h radio_chat -o $@


include $(MAKERULES)
