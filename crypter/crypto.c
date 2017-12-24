#include "crypto.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ENCRYPT_MODUS 0
#define DECRYPT_MODUS 1

int crypt(KEY key, const char* in, char* out, int modus)
{
    const char* inPos;
    const char* keyPos = key.chars;
    char* outPos = out;
    int pos = -1;

    if(!strlen(key.chars))
    {
        return E_KEY_TOO_SHORT;
    }

    for(inPos = in; *inPos; ++inPos)
    {
        if(!*keyPos)
        {
            keyPos = key.chars;
        }

        if(!strchr(KEY_CHARACTERS, *keyPos))
        {
            return E_KEY_ILLEGAL_CHAR;
        }

        if(modus == ENCRYPT_MODUS)
        {
            if(!strchr(MESSAGE_CHARACTERS, *inPos))
            {
                return E_MESSAGE_ILLEGAL_CHAR;
            }

            pos = ((strchr(MESSAGE_CHARACTERS, *inPos) - (MESSAGE_CHARACTERS)) + 1) ^
                  ((strchr(KEY_CHARACTERS, *keyPos) - (KEY_CHARACTERS)) + 1);
            *outPos = CYPHER_CHARACTERS[pos];
        }
        else
        {
            if(!strchr(CYPHER_CHARACTERS, *inPos))
            {
                return E_CYPHER_ILLEGAL_CHAR;
            }

            pos = ((strchr(CYPHER_CHARACTERS, *inPos) - (CYPHER_CHARACTERS))) ^
                  ((strchr(KEY_CHARACTERS, *keyPos) - (KEY_CHARACTERS)) + 1);
            *outPos = MESSAGE_CHARACTERS[pos - 1];
        }

        ++outPos;
        ++keyPos;
    }

    return 0;
}

int encrypt(KEY key, const char* input, char* output)
{
    return crypt(key, input, output, ENCRYPT_MODUS);
}

int decrypt(KEY key, const char* cypherText, char* output)
{
    return crypt(key, cypherText, output, DECRYPT_MODUS);
}
