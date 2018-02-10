#pragma once

#include <map>
#include <vector>

class VectorUtilities {
public:
    template <class TKey, class TEntry>
    static std::map<TKey, std::vector<TEntry>> GroupBy(std::vector<TEntry> items, TKey (*keyFunc)(const TEntry&)) {
        std::map<TKey, std::vector<TEntry>> result;

        for (auto item : items) {
            TKey key = keyFunc(item);

            if (result.find(key) == result.end()) {
                result.insert(std::pair<TKey, std::vector<TEntry>>(key, std::vector<TEntry>()));
            }

            result[key].push_back(item);
        }

        return result;
    }
};