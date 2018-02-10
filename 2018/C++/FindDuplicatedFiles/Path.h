#pragma once

#include <string>

class Path {
private:
    const static char pathSeparatorChar = '/';

public:
    std::string static Combine(const std::string &base, const std::string &relative) {
        std::string result = base;
        
        if (result[result.length() - 1] != pathSeparatorChar) {
            result += pathSeparatorChar;
        }

        result += relative;

        return result;
    }
};