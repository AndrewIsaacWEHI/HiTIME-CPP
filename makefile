CC=gcc
CXX=g++
RM=rm -f

SRCS=hitime.cpp
OBJS=$(subst .cpp,.o,$(SRCS))

all: hitime.out

hitime.out: $(OBJS)
	$(CXX) -o hitime.out $(OBJS)

hitime.o: hitime.cpp

clean:
	$(RM) $(OBJS)

dist-clean: clean
	$(RM) hitime.out