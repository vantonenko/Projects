#pragma once

#include <fstream>
#include <sstream>
#include <cerrno>

#include <string>
#include "StringHash.h"

class FileHash {
public:
    static std::string CalculateHash(const std::string &path) {
        const std::string &content = GetFileContent(path);

        return StringHash::CalculateHash(content);
    }
private:
    static const std::string GetFileContent(const std::string &path) {
        std::ifstream in(path, std::ios::in | std::ios::binary);
        if (in)
        {
            std::ostringstream contents;
            contents << in.rdbuf();
            in.close();
            return contents.str();
        }

        throw(errno);
    }
};