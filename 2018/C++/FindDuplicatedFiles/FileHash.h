#pragma once

#include <fstream>
#include <sstream>
#include <cerrno>

#include <string>
#include "StringHash.h"

template<class TItem>
class InMemoryBuffer {
private:
    long _size;
    TItem *_buff;

public:
    InMemoryBuffer(long size): _size(size) {
        _buff = new TItem[size];
    }
    
    ~InMemoryBuffer() {
        delete []_buff;
    }

    long GetSize() const { return _size; }
    TItem* GetBuffer() const { return _buff; }

    operator TItem* () const {
        return GetBuffer();
    }
};

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {
        
        FILE *fh = fopen(path.c_str(), "r");
        fseek(fh, 0L, SEEK_END);
        
        long fileSize = ftell(fh);
        fseek(fh, 0L, SEEK_SET);

        InMemoryBuffer<unsigned char> buf(fileSize);
        
        fread(buf, fileSize, 1, fh);
        fclose(fh);

        return StringHash::CalculateHash(buf, fileSize);
    }
};