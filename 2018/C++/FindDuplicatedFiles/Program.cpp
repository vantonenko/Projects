// clang++ -std=c++14 -stdlib=libc++ Program.cpp -lcrypto -O3; ./a.out

#include <iostream>

#include <string>
#include <vector>
#include <map>

#include <time.h>

#include "Directory.h"
#include "FileHash.h"
#include "VectorUtilities.h"
#include "ConsoleProgressBar.h"

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

    timespec ts_beg, ts_end;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts_beg);

    ConsoleProgressBar progressBar(files.size());
    vector<FileEntry> entries;
    for (auto path : files) {
        FileEntry entry;
        entry.filePath = path;
        entry.fileHash = FileHash::CalculateHash(path);
        
        entries.push_back(entry);
        progressBar.ReportDoneItem();
    }

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts_end);

    cout << "Checking if there are any duplicated files..." << endl;

    map<string, vector<FileEntry>> groups = 
        VectorUtilities<string, FileEntry>::GroupBy(
            entries, 
            [](const FileEntry &entry) {
                return entry.fileHash; 
            });
    
    int count = 0;
    for (auto group : groups) {
        if (group.second.size() > 1) {
            cout << "#" << ++count << ": " << endl;
            for (auto item : group.second) {
                cout << "\t'" << item.filePath << "'" << endl;
            }
        }
    }

    cout << 
        "Time spent for calculating hashes: " << 
        (ts_end.tv_sec - ts_beg.tv_sec) * 1000 + (ts_end.tv_nsec - ts_beg.tv_nsec) / 1000000 << 
        " ms." << endl;
}