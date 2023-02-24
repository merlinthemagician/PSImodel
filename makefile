# Makefile
#
CC      = gcc#
CFLAGS	=-Wall -pedantic#

rm	= rm -f#				delete file

all:	_
clean::		;@ $(MAKE) T='$T' _clean
_clean:	_	;  $(rm) *.o $T a.out core *.tmp *.ps *.bak
run::	_
_:		;@ echo -------------------- $D --------------------


D =	"PSI model"

T = psi.o psi$x psiDet$x

all:	$T

INCLUDE=.

INC=/sw/include/
INC2=/opt/local/include/

GSL = `gsl-config --cflags` `gsl-config --libs` -lm

psi.o:	psi.c psi.h
		$(CC) $(CFLAGS) -c -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2)

psi$x:	psi.c psi.h
			$(CC) $(CFLAGS) -DTEST -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2) $(GSL)

psiDet$x:	psi.c psi.h
		$(CC) $(CFLAGS) -DTEST -DDET -o $@ psi.c -I$(INCLUDE) -I$(INC) -I$(INC2) $(GSL)
