# Template makefie for single project

BIN=Logging_Server
FILES=Logging_Server.cpp Logging_Handler.cpp Reactive_Logging_Server.cpp
OBJS=Logging_Server.o Logging_Handler.o Reactive_Logging_Server.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib
GTAGS=ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

Logging_Server.o:Logging_Server.cpp Logging_Server.h
	g++ $(DBGFLAGS) -c Logging_Server.cpp $(IFLAGS)

Logging_Handler.o:Logging_Handler.cpp Logging_Handler.h
	g++ $(DBGFLAGS) -c Logging_Handler.cpp $(IFLAGS)

Reactive_Logging_Server.o:Reactive_Logging_Server.cpp Reactive_Logging_Server.h
	g++ $(DBGFLAGS) -c Reactive_Logging_Server.cpp $(IFLAGS)

gtags:
	$(GTAGS)

clean:
	rm $(BIN) $(OBJS)
