#pragma once

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
            while ((item = readdir(dirp)) != NULL)
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