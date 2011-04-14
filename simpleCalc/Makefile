CC = gcc
LIBOPT = -lfl

simpleCalc: Makefile
	bison -d simpleCalc.y
	flex -L -osimpleCalc.c simpleCalc.l
	$(CC) -o simpleCalc simpleCalc.c simpleCalc.tab.c $(LIBOPT)

clean:
	rm -f simpleCalc.c simpleCalc.tab.c simpleCalc.tab.h simpleCalc