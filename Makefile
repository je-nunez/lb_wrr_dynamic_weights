CC = gcc
CFLAGS = -g -fpic -Wall

.SILENT:  help


help:
	echo "Makefile help"
	echo -e "Possible make targets:\n"
	echo "    make compile"
	echo -e "         Compile the program.\n"
	echo "    make clean"
	echo -e "         Remove compiled and binary-object files.\n"


compile: dynamicRatioProcess.c
	$(CC) -o dynamicRatioProcess.o -c dynamicRatioProcess.c  \
                         $(CFLAGS) -Wno-unused-function
	$(CC) -shared -o dynamicRatioProcess.so dynamicRatioProcess.o
	@echo -e "\nRecall to add in the snmpd.conf config file:\n"
	@echo "   dlmod  dynamicRatioProcess  `pwd`/dynamicRatioProcess.so"
	@echo -e "\nas well as one or more:\n"
	@echo "   LbDWRRregexpCmdLine <extended-regular-expr-for-backend-processes>"
	@echo -e "\nin order to know, by their command-lines, which backend processes to report."

.PHONY : clean

clean:
	-rm -f dynamicRatioProcess.o dynamicRatioProcess.so

