#pragma once

#include <string>

#include "StringHash.h"
#include "InMemoryBuffer.h"

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {

        InMemoryBuffer<unsigned char> buf = GetFileContent(path);

        if (buf.Size() == 0) return "";

        return StringHash::CalculateHash(buf);
    }

private:
    static InMemoryBuffer<unsigned char> GetFileContent(const std::string &path) {
        FILE *fh = fopen(path.c_str(), "r");

        if (fh == nullptr) return InMemoryBuffer<unsigned char>(0);

        fseek(fh, 0L, SEEK_END);
        
        long fileSize = ftell(fh);
        fseek(fh, 0L, SEEK_SET);

        InMemoryBuffer<unsigned char> buf(fileSize);
        
        fread(buf, fileSize, 1, fh);
        fclose(fh);

        return buf;
    }
};