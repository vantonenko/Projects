#pragma once

#include <string>
#include <openssl/md5.h>

#include "InMemoryBuffer.h"

class StringHash {
public:
    static std::string CalculateHash(const InMemoryBuffer<unsigned char> &data) {
        unsigned char digest[MD5_DIGEST_LENGTH];

        MD5(data, data.Size(), (unsigned char*)&digest);
        
        char mdString[MD5_DIGEST_LENGTH * 2 + 1];
 
        for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
            sprintf(&mdString[i * 2], "%02x", (unsigned int)digest[i]);
        }

        return mdString;
    }
};