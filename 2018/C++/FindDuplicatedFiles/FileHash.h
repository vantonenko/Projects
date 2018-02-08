#pragma once

#include <fstream>
#include <sstream>
#include <cerrno>

#include <string>
#include "StringHash.h"

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {
        
        FILE *fh = fopen(path.c_str(), "r");
        fseek(fh, 0L, SEEK_END);
        
        long fileSize = ftell(fh);
        fseek(fh, 0L, SEEK_SET);
        
        unsigned char *buf = new unsigned char[fileSize];
        fread(buf, fileSize, 1, fh);
        fclose(fh);

        std::string result = StringHash::CalculateHash(buf, fileSize);

        delete[] buf;

        return result;
    }
};