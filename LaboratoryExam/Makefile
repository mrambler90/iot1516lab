COMPONENT=RadioChatAppC
BUILD_EXTRA_DEPS += TestSerial.class
CLEAN_EXTRA = *.class TestSerialMsg.java

CFLAGS += -I$(TINYOS_OS_DIR)/tos/lib/printf
CFLAGS += -DPRINTF_BUFFER=42
CFLAGS += -DCC2420_DEF_CHANNEL=12
CFLAGS += -I$(TOSDIR)/lib/T2Hack

DEST=0U
CFLAGS += -DDESTID=$(DEST)

TestSerial.class: $(wildcard *.java) TestSerialMsg.java
	javac -target 1.4 -source 1.4 *.java

TestSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=TestSerialMsg RadioChat.h radio_chat -o $@


include $(MAKERULES)
