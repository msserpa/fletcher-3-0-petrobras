EXEC := appPower
LIBS := -Wall -Wextra -O2
CC   := gcc

all: $(EXEC)

$(EXEC): appPower.o
	$(CC) $^ -o $@ $(LIBS)

clean:
	rm -f *.o $(EXEC)