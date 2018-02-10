#pragma once

#include <time.h>

struct StopWatchResult {
    int milliseconds;

    StopWatchResult(): milliseconds(0) {}
};

class StopWatch {
    StopWatchResult *_result;
    timespec _ts_beg;

public:
    StopWatch(StopWatchResult *result): _result(result) {
        clock_gettime(CLOCK_MONOTONIC, &_ts_beg);
    }

    ~StopWatch() {
        timespec ts_end;
        clock_gettime(CLOCK_MONOTONIC, &ts_end);

        _result->milliseconds = 
            (ts_end.tv_sec - _ts_beg.tv_sec) * 1000 + 
            (ts_end.tv_nsec - _ts_beg.tv_nsec) / 1000000;
    }
};