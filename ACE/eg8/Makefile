# Template makefie for single project

BIN=eg8
FILES=eg8.cpp
OBJS=eg8.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib
GTAGS=ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

eg8.o:eg8.cpp
	g++ $(DBGFLAGS) -c eg8.cpp $(IFLAGS)

gtags:
	$(GTAGS)

clean:
	rm $(BIN) $(OBJS)
