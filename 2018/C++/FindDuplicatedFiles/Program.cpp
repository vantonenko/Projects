// complie & run - clang++ -std=c++14 -stdlib=libc++ Program.cpp -lcrypto -O3; ./a.out
// complie, run & analyise memory faults - clang++ -std=c++14 -stdlib=libc++ Program.cpp -lcrypto -O3 -fsanitize=address -fno-omit-frame-pointer; ./a.out

#include <iostream>

#include <string>
#include <vector>
#include <map>

#include "Directory.h"
#include "FileHash.h"
#include "VectorUtilities.h"
#include "ConsoleProgressBar.h"
#include "Parallel.h"
#include "StopWatch.h"

using namespace std;

struct FileEntry {
    string filePath;
    string fileHash;
};

int main() {
    const string path = "./../..";

    cout << "Getting a list of files in '" << path << "' directory..." << endl;

    vector<string> files;
    Directory::EnumDirectoryItems(path, [&files](const string &filePath) {
        files.push_back(filePath);
    });

    cout << "There are " << files.size() << " files." << endl;

    cout << "Calculating hashes..." << endl;

    ConsoleProgressBar progressBar(files.size());
    vector<FileEntry> entries;
    mutex updateMutex;

    StopWatchResult swResult;
    {
        StopWatch stopWatch(&swResult);
        
        Parallel::ForEach<std::vector<string>::const_iterator, string>(
            files.begin(), 
            files.end(), 
            [&entries, &progressBar, &updateMutex](const string &path) {
                FileEntry entry;
                entry.filePath = path;
                entry.fileHash = FileHash::CalculateHash(path);
                
                lock_guard<mutex> lock(updateMutex);
                entries.push_back(entry);
                progressBar.ReportDoneItem();
            });
    }

    cout << "Checking if there are any duplicated files..." << endl;

    map<string, vector<FileEntry>> groups = 
        VectorUtilities::GroupBy<string, FileEntry>(
            entries, 
            [](const FileEntry &entry) {
                return entry.fileHash; 
            });
    
    int count = 0;
    for (auto group : groups) {
        if (group.second.size() > 1) {
            if (group.first == "") {
                cout << "Unable to open files:" << endl;
            } else {
                cout << "#" << ++count << ": " << endl;
            }

            for (auto item : group.second) {
                cout << "\t'" << item.filePath << "'" << endl;
            }
        }
    }

    cout << "Time spent for calculating hashes: " << swResult.milliseconds << " ms." << endl;
}