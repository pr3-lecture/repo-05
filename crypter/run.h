#ifndef RUN_H
#define RUN_H

#include "crypto.h"

char* readLineFromConsole();

char* readFile(char* path);

char* getFilename(char* path);

void cleanUp(char* filename, KEY key, char* input, char* output);

int exitWithError(char* msg);

#endif
