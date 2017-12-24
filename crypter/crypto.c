#include "crypto.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ENCRYPT_MODUS 0
#define DECRYPT_MODUS 1

int hasIllegalCharacters(const char* chars, const char* legalChars, int onFound)
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
    const char* keyPos = key.chars;
    char* outPos = out;
    int pos = -1;

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
    int inputCheck = -1;
    int keyCheck = -1;

    if(!strlen(key.chars))
    {
        return E_KEY_TOO_SHORT;
    }

    inputCheck = hasIllegalCharacters(input, MESSAGE_CHARACTERS, E_MESSAGE_ILLEGAL_CHAR);

    if(inputCheck)
    {
        return inputCheck;
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
    int inputCheck = -1;
    int keyCheck = -1;

    if(!strlen(key.chars))
    {
        return E_KEY_TOO_SHORT;
    }

    inputCheck = hasIllegalCharacters(cypherText, MESSAGE_CHARACTERS, E_CYPHER_ILLEGAL_CHAR);

    if(inputCheck)
    {
        return inputCheck;
    }

    keyCheck = hasIllegalCharacters(key.chars, KEY_CHARACTERS, E_KEY_ILLEGAL_CHAR);

    if(keyCheck)
    {
        return keyCheck;
    }

    crypt(key, cypherText, output, DECRYPT_MODUS);

    return 0;
}
