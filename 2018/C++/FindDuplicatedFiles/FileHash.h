#pragma once

#include <string>
#include <memory>
#include <fstream>

#include <openssl/md5.h>

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {        
        const int buffSize = 1024 * 1024;
        
        FILE *fh = fopen(path.c_str(), "rb");
        if (fh == nullptr) return "";

        MD5_CTX mdContext;
        MD5_Init(&mdContext);
        
        auto ptr = std::make_unique<unsigned char[]>(buffSize);
        unsigned char *data = ptr.get();

        int bytes;
        while ((bytes = fread(data, 1, buffSize, fh)) != 0) {
            MD5_Update(&mdContext, data, bytes);
        }
        fclose (fh);
        
        unsigned char digest[MD5_DIGEST_LENGTH];
        MD5_Final(digest, &mdContext);
        
        char mdString[MD5_DIGEST_LENGTH * 2 + 1];
        for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
            sprintf(&mdString[i * 2], "%02x", (unsigned int)digest[i]);
        }

        return mdString;
    }
};