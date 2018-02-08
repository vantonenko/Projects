#pragma once

#include <memory>

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