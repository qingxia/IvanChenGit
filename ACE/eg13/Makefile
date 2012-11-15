# Template makefie for single project

BIN=Reactor_Logging_Server
OBJS=Reactor_Logging_Server.o Logging_Handler.o Logging_Acceptor.o Logging_Acceptor_Ex.o Logging_Event_Handler.o Logging_Event_Handler_Ex.o
DBGFLAGS=-g
IFLAGS=-I$(ACE_ROOT)
LIBS=-lACE
LDFLAGS=-L$(ACE_ROOT)/lib
GTAGS=ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

$(BIN):$(OBJS)
	g++ -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

Reactor_Logging_Server.o:Reactor_Logging_Server.cpp Reactor_Logging_Server.h Logging_Acceptor_Ex.h
	g++ $(DBGFLAGS) -c Reactor_Logging_Server.cpp $(IFLAGS)

Logging_Acceptor.o:Logging_Acceptor.cpp Logging_Acceptor.h Logging_Event_Handler.h
	g++ $(DBGFLAGS) -c Logging_Acceptor.cpp $(IFLAGS) 

Logging_Acceptor_Ex.o:Logging_Acceptor_Ex.cpp Logging_Acceptor_Ex.h 
	g++ $(DBGFLAGS) -c Logging_Acceptor_Ex.cpp $(IFLAGS) 

Logging_Event_Handler.o:Logging_Event_Handler.cpp Logging_Event_Handler.h 
	g++ $(DBGFLAGS) -c Logging_Event_Handler.cpp $(IFLAGS) 

Logging_Event_Handler_Ex.o:Logging_Event_Handler_Ex.cpp Logging_Event_Handler_Ex.h 
	g++ $(DBGFLAGS) -c Logging_Event_Handler_Ex.cpp $(IFLAGS) 

Logging_Handler.o:Logging_Handler.cpp Logging_Handler.h 
	g++ $(DBGFLAGS) -c Logging_Handler.cpp $(IFLAGS) 

gtags:
	$(GTAGS)

clean:
	rm $(BIN) $(OBJS)
