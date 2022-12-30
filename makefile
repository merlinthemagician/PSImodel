#	Makefile -- Sat Apr  5 14:50:06 MET DST 1997
#	Copyright (c) 1992, 1997 Axel T. Schreiner

include $(HOME)/c/include/make/c.h
#include /Users/isiekmann/c/include/make/c.h
#include /people/isie002/include/make/c.h

D =	"PSI model"

T = psi.o psi$x psiDet$x

all:	$T

INC=/sw/include/
INC2=/opt/local/include/

psi.o:	psi.c psi.h
		$(CC) $(CFLAGS) -c -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2)
psi$x:	psi.c psi.h
			$(CC) $(CFLAGS) -DTEST -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2) $(GSL)

psiDet$x:	psi.c psi.h
		$(CC) $(CFLAGS) -DTEST -DDET -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2) $(GSL)
