BIN=eg2
FILES=eg2.cpp
OBJS=eg2.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

eg2.o:eg2.cpp
	g++ $(DBGFLAGS) -c eg2.cpp $(IFLAGS)

clean:
	rm $(BIN) $(OBJS)

eg1:eg1.o
	g++ -o eg1 eg1.o $(LIBS) $(LDFLAGS)

eg1.o:eg1.cpp
	g++ $(DBGFLAGS) -c eg1.cpp $(IFLAGS)
