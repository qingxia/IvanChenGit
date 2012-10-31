# Template makefie for single project

BIN=Logging_Client
FILES=Logging_Client.cpp
OBJS=Logging_Client.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib
GTAGS=ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

Logging_Client.o:Logging_Client.cpp
	g++ $(DBGFLAGS) -c Logging_Client.cpp $(IFLAGS)

gtags:
	$(GTAGS)

clean:
	rm $(BIN) $(OBJS)
