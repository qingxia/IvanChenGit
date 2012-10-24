BIN=HelloGit
FILES=HelloGit.c
OBJS=HelloGit.o
DBGFLAGS=-g

$(BIN):$(OBJS)
	gcc -o $(BIN) $(OBJS)

HelloGit.o:HelloGit.c
	gcc $(DBGFLAGS) -c HelloGit.c

clean:
	rm $(BIN) $(OBJS)
