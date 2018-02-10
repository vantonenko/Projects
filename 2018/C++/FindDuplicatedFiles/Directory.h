#pragma once

#include <iostream>

#include <string>
#include <functional>

#include <dirent.h>

#include "Path.h"

class Directory {
public:
    static void EnumDirectoryItems(const std::string &path, std::function<void(std::string)> action, bool nested = true) {

        DIR *dirp = opendir(path.c_str());
        if (dirp)
        {
            struct dirent *item;
            while ((item = readdir(dirp)) != nullptr)
            {
                if (strcmp(item->d_name, "..") == 0 || strcmp(item->d_name, ".") == 0) continue;

                std::string nestedPath = Path::Combine(path, item->d_name);

                if (nested && item->d_type == DT_DIR) {
                    EnumDirectoryItems(nestedPath, action);
                } else {
                    action(nestedPath);
                }
            }

            closedir(dirp);
        }
    }
};

class DirectoryIterator {
private:
    std::string _path;
    
    struct dirent *_currentItem;
    DIR *_dirp;

    void MoveNext() {
        do {
            _currentItem = readdir(_dirp);
        } while (
            _currentItem != nullptr && 
            (strcmp(_currentItem->d_name, "..") == 0 || 
            strcmp(_currentItem->d_name, ".") == 0)); // skip "." and ".." items
    }

public:
    DirectoryIterator(const std::string &path): _path(path), _currentItem(nullptr) {
        _dirp = opendir(path.c_str());
        if (_dirp != nullptr) {
            MoveNext();
        }
    }

    DirectoryIterator(): _currentItem(nullptr), _dirp(nullptr) {}

    ~DirectoryIterator() {
        if (_dirp) {
            closedir(_dirp);
        }
    }

    DirectoryIterator& operator++() {
        MoveNext();

        return *this;
    }

    const std::string operator*() const {
        std::string nestedPath = Path::Combine(_path, _currentItem->d_name);
        return nestedPath;
    }

    bool operator!=(const DirectoryIterator &it) const {
        return _currentItem != it._currentItem;
    }
    
    bool operator==(const DirectoryIterator &it) const {
        return _currentItem == it._currentItem;
    }
};

class DirectoryRange {
    std::string _path;

public:
    DirectoryRange(const std::string &path): _path(path) { }

    DirectoryIterator begin() const { 
        return DirectoryIterator(_path);
    }

    DirectoryIterator end() const {
        return DirectoryIterator();
    } 
};

void DirectoryIteratorSample() {
    const std::string &path = ".";

    for (auto p: DirectoryRange(path)) {
        std::cout << p << std::endl;
    }
}