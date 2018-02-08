#pragma once

#include <fstream>
#include <sstream>
#include <cerrno>
#include <string>
#include <memory>

#include "StringHash.h"

template<class TItem>
class InMemoryBuffer {
private:
    std::unique_ptr<TItem[]> _buffer;
    long _size;
public:
    InMemoryBuffer(long size) : _size(size), _buffer(new TItem[size]) { }

    long Size() const { return _size; }
    operator TItem* () const { return _buffer.get(); } 
};

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {

        InMemoryBuffer<unsigned char> buf = GetFileContent(path);

        return StringHash::CalculateHash(buf, buf.Size());
    }
private:
    static InMemoryBuffer<unsigned char> GetFileContent(const std::string &path) {
        FILE *fh = fopen(path.c_str(), "r");
        fseek(fh, 0L, SEEK_END);
        
        long fileSize = ftell(fh);
        fseek(fh, 0L, SEEK_SET);

        InMemoryBuffer<unsigned char> buf(fileSize);
        
        fread(buf, fileSize, 1, fh);
        fclose(fh);

        return buf;
    }
};