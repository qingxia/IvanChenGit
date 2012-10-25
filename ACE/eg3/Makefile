# Template makefie for single project

BIN=eg3
FILES=eg3.cpp
OBJS=eg3.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

eg3.o:eg3.cpp
	g++ $(DBGFLAGS) -c eg3.cpp $(IFLAGS)

clean:
	rm $(BIN) $(OBJS)
