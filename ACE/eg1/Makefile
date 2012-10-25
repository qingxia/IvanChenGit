BIN=eg1
FILES=eg1.cpp
OBJS=eg1.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

eg1.o:eg1.cpp
	g++ $(DBGFLAGS) -c eg1.cpp $(IFLAGS)

clean:
	rm $(BIN) $(OBJS)
