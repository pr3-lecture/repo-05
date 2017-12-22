#include "crypto.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ENCRYPT_MODUS 0
#define DECRYPT_MODUS 1

char* copyString(const char* input, size_t length)
{
    char* destination = (char*) malloc((length + 1) * sizeof(char));

    if(!destination)
    {
        return NULL;
    }

    if(!strncpy(destination, input, length))
    {
        return NULL;
    }
    destination[length] = '\0';

    return destination;
}

char* readLineFromConsole()
{
    const int readSize = 255;
    char* destination;

    destination = (char*) malloc(readSize * sizeof(char));

    if(!destination)
    {
        return NULL;
    }

    destination = fgets(destination, readSize - 1, stdin);
    if(destination)
    {
        char *pos;
        if ((pos=strchr(destination, '\n')) != NULL)
        {
            *pos = '\0';
        }
        else
        {
            destination[readSize] = '\0';
        }
    }

    return destination;
}

char* readFile(char* path)
{
    size_t readCount;
    char* buffer;
    FILE* file;

    file = fopen(path, "r");

    if(!file)
    {
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    fseek(file, 0, SEEK_SET);

    buffer = (char*) malloc((fileSize + 1) * sizeof(char));

    if(!buffer)
    {
        fclose(file);
        return NULL;
    }

    readCount = fread(buffer, 1, fileSize, file);
    fclose(file);

    if(readCount != fileSize)
    {
        return NULL;
    }

    return buffer;
}

char* getFilename(char* path)
{
    size_t size = 0;
    char* p;
    char* name;

    if(!path) {
        return 0;
    }


    p = &path[strlen(path)];
    for(; *p != '\\'; p--)
    {
        ++size;
        if(!p)
        {
            return 0;
        }
    }

    name = (char*) malloc(size * sizeof(char));
    strncpy(name, p+1, size);
    name[strlen(path) - size] = '\0';

    return name;
}

int hasIllegalCharacters(const char* chars, const char* legalChars ,int onFound)
{
    const size_t sizeWord = strlen(chars);
    size_t i;

    for(i = 0; i < sizeWord; ++i)
    {
        if(!strchr(legalChars, chars[i]))
        {
            return onFound;
        }
    }

    return 0;
}

void crypt(KEY key, const char* in, char* out, int modus)
{
    const char* inPos;
    const char* keyPos;
    char* outPos;
    int pos;

    keyPos = key.chars;
    outPos = out;

    for(inPos = in; *inPos; ++inPos)
    {
        if(!*keyPos)
        {
            keyPos = key.chars;
        }

        if(modus == ENCRYPT_MODUS)
        {
            pos = ((strchr(MESSAGE_CHARACTERS, *inPos) - (MESSAGE_CHARACTERS)) + 1) ^
                  ((strchr(KEY_CHARACTERS, *keyPos) - (KEY_CHARACTERS)) + 1);
            *outPos = CYPHER_CHARACTERS[pos];
        }
        else
        {
            pos = ((strchr(CYPHER_CHARACTERS, *inPos) - (CYPHER_CHARACTERS))) ^
                  ((strchr(KEY_CHARACTERS, *keyPos) - (KEY_CHARACTERS)) + 1);
            *outPos = MESSAGE_CHARACTERS[pos - 1];
        }

        ++outPos;
        ++keyPos;
    }
}

int encrypt(KEY key, const char* input, char* output)
{
    int inputCheck;
    int keyCheck;

    inputCheck = hasIllegalCharacters(input, MESSAGE_CHARACTERS, E_MESSAGE_ILLEGAL_CHAR);

    if(inputCheck)
    {
        return inputCheck;
    }

    if(!strlen(key.chars))
    {
        return E_KEY_TOO_SHORT;
    }

    keyCheck = hasIllegalCharacters(key.chars, KEY_CHARACTERS, E_KEY_ILLEGAL_CHAR);

    if(keyCheck)
    {
        return keyCheck;
    }

    crypt(key, input, output, ENCRYPT_MODUS);

    return 0;
}

int decrypt(KEY key, const char* cypherText, char* output)
{
    int inputCheck;
    int keyCheck;

    inputCheck = hasIllegalCharacters(cypherText, MESSAGE_CHARACTERS, E_CYPHER_ILLEGAL_CHAR);

    if(inputCheck)
    {
        return inputCheck;
    }

    if(!strlen(key.chars))
    {
        return E_KEY_TOO_SHORT;
    }

    keyCheck = hasIllegalCharacters(key.chars, KEY_CHARACTERS, E_KEY_ILLEGAL_CHAR);

    if(keyCheck)
    {
        return keyCheck;
    }

    crypt(key, cypherText, output, DECRYPT_MODUS);

    return 0;
}

void clear(char* filename, KEY key)
{
    if(filename)
    {
        free(filename);
    }
    if(key.chars)
    {
        free(key.chars);
    }
}

int main(int argc, char** argv)
{
    int (*crypt) (KEY, const char*, char*);
    char* filename;
    KEY key;
    char* input;
    char* output;
    int result;

    filename = getFilename(argv[0]);

    if(!filename)
    {
        fprintf(stderr, "Error: Your system is not supported\n");
        clear(filename, key);
        return EXIT_FAILURE;
    }
    else if(strcmp(filename, "encrypt.exe") == 0)
    {
        crypt = encrypt;
    }
    else if(strcmp(filename, "decrypt.exe") == 0)
    {
        crypt = decrypt;
    }
    else
    {
        fprintf(stderr, "Error: Your system is not supported\n");
        clear(filename, key);
        return EXIT_FAILURE;
    }

    if(argc == 2 || argc == 3)
    {
        key.chars = copyString(argv[1], strlen(argv[1]));

        if(key.chars == NULL)
        {
            fprintf(stderr, "Error: Failed to allocate memory\n");
            clear(filename, key);
            return EXIT_FAILURE;
        }

        if(argc == 2)
        {
            input = readLineFromConsole();
        }
        else
        {
            input = readFile(argv[2]);
        }

        if(!input)
        {
            fprintf(stderr, "Error: An input error occured\n");
            clear(filename, key);
            return EXIT_FAILURE;
        }

        output = (char*) malloc((strlen(input) + 1) * sizeof(char));

        if(!output)
        {
            fprintf(stderr, "Error: Failed to allocate memory\n");
            clear(filename, key);
            return EXIT_FAILURE;
        }
        output[strlen(input)] = '\0';

        result = (*crypt) (key, input, output);
        printf("%s\n", output);
        printf("%d\n", result);

        free(input);
        free(output);
        input = NULL;
        output = NULL;
    }
    else
    {
        fprintf(stderr, "Usage: KEY [file name]\n");
    }
    clear(filename, key);

    return 0;
}
