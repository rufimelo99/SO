CC = gcc

CFLAGS = -Wall

LD = gcc

LDFLAGS = -lm

TARGETS = server client client2

all: $(TARGETS)

comm-msg.o:	comm.h message.h

message.o:	message.h

client.o: comm.h

server.o: comm.h

client2.o: comm.h

$(TARGETS):		%:  %.o comm-msg.o message.o
		$(LD) -o $@ $^ $(LDFLAGS)

.PHONY: clean cleanall

clean:
		rm -f *.o *~

cleanall:	clean
		rm -f $(TARGETS)

