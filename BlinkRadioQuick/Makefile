COMPONENT=BlinkRadioAppC

# import the mote-to-serial printf library
# and setting its buffer size
CFLAGS += -I$(TINYOS_OS_DIR)/tos/lib/printf
CFLAGS += -DPRINTF_BUFFER=42

# writing the command-line parameter DEST=X value X
# into the constant DESTID
CFLAGS += -DDESTID=$(DEST)

# import the path for the tinyos Make rules
include $(MAKERULES)
