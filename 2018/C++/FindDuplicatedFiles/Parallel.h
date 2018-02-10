#pragma once

#include <thread>

class Parallel {
public:
    template<class TIterator, class TItem>
    static void ForEach(TIterator begin, TIterator end, std::function<void(TItem&)> action) {
        TIterator it = begin;

        const size_t nCores = std::thread::hardware_concurrency();
        std::vector<std::thread> threads(nCores);
        
        std::mutex iteratorMutex;
        for (auto i = 0; i < nCores; i++) {
            threads[i] = std::thread([&iteratorMutex, &it, &end, &action](){
                while (true)
                {
                    TItem workItem;
                    {
                        std::lock_guard<std::mutex> lock(iteratorMutex);
                        if (it == end) break;
                        workItem = *(it++);
                    }

                    action(workItem);
                };
            });
        }

        std::for_each(threads.begin(), threads.end(), [](std::thread &t){
            t.join();
        });
    }
};