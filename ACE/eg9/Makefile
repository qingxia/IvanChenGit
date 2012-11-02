# Template makefie for single project

BIN=eg9
FILES=eg9.cpp
OBJS=eg9.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib
GTAGS=ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

eg9.o:eg9.cpp
	g++ $(DBGFLAGS) -c eg9.cpp $(IFLAGS)

gtags:
	$(GTAGS)

clean:
	rm $(BIN) $(OBJS)
