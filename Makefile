#
# Copyright, 1985, Massachusetts Institute of Technology.
#	catclock - makefile for the X window system clock.
#
#	Written by:	Tony Della Fera, DEC
#			11-Sep-84
SRCS = catclock.c alarm.c
OBJS = catclock.o alarm.o

WITH_TEMPO_TRACKER ?= 0

XLIB      = -lX11
MOTIFLIBS = -lXm -lXt
EXTENSIONLIB = -lXext
SYSLIBS   = -lm
# LDLIBS = $(shell pkg-config --libs gtk+-3.0)
GTK3 = `pkg-config --cflags --libs gtk+-3.0`
LIBS      = -L/opt/local/lib $(MOTIFLIBS) $(EXTENSIONLIB) $(XLIB) $(SYSLIBS)
ifeq ($(WITH_TEMPO_TRACKER), 1)
	LIBS += -lpulse -lpulse-simple -lpthread -laubio
endif
#LIBS      = $(MOTIFLIBS) $(EXTENSIONLIB) $(XLIB) $(SYSLIBS)

LOCALINCS = -I.
MOTIFINCS = -I/opt/local/include -I/opt/local/include/X11
#MOTIFINCS = -I/usr/include
INCS      = $(LOCALINCS) $(MOTIFINCS)

#DEFINES     = -DHAS_GNU_EMACS
CDEBUGFLAGS = -g
CFLAGS      = $(DEFINES) $(INCS) $(CDEBUGFLAGS)

DESTINATION = /udir/pjs/bin

PROG  = catclock
DEBUG = debug

DEPEND = makedepend

.SUFFIXES: .o .c

.c.o:
	$(CC) -c $(INCS) $(CFLAGS) $*.c

all: $(PROG)

$(PROG): $(SRCS) Makefile
	$(CC) -o $(PROG) $(GTK3) -DWITH_TEMPO_TRACKER=$(WITH_TEMPO_TRACKER) $(CFLAGS) $(SRCS) $(GTK3) $(LIBS)
	strip $(PROG)

$(DEBUG): $(OBJS) Makefile
	$(CC) -o $(DEBUG) $(OBJS) $(LIBS)

install: $(PROG)
	install -c -s $(PROG) $(DESTINATION)

lint:
	lint $(INCS) $(SRCS) > lint_errs

clean: 
	rm -f *~ *.bak core *.o \#*\# $(PROG) $(DEBUG) lint_errs 
	rm -rf catclock.dSYM

depend:
	$(DEPEND) $(INCS) $(SRCS)


# DO NOT DELETE THIS LINE -- make depend depends on it.
