#include "stdafx.h"
#include "ThreadsSample.h"

#include "windows.h"
#include <process.h>
#include <iostream>
#include <vector>
#include <mutex>

using namespace std;

const int ThreadsSample::ThreadsCount = 32;
const int ThreadsSample::TimeQuantLimit = 200;

mutex ThreadsSample::mtx;

DWORD *ThreadsSample::threadsMaxTimeWaitingForQuant = new DWORD[ThreadsCount]();

void ThreadsSample::threadBody(void *params) {
	int threadNumber = (int)params;

	mtx.lock();
	cout << "Thread #" << threadNumber << " has started." << endl;
	mtx.unlock();

	DWORD prevTickCount = GetTickCount();
	for (;;) {
		DWORD nextTickCount = GetTickCount();
		DWORD diffTickCount = nextTickCount - prevTickCount;

		if (diffTickCount > TimeQuantLimit) {
			DWORD oldValue = threadsMaxTimeWaitingForQuant[threadNumber];
			if (diffTickCount > oldValue) {
				threadsMaxTimeWaitingForQuant[threadNumber] = diffTickCount;
			}
		}

		prevTickCount = nextTickCount;
	}
}

void ThreadsSample::run()
{
	vector<HANDLE> handles;

	for (int i = 0; i < ThreadsCount; i++) {
		HANDLE hThread = (HANDLE)_beginthread(&ThreadsSample::threadBody, 0, (void*)i);
		handles.push_back(hThread);
	}

	for (;;) {
		cout << "Any key to get the latest statistics." << endl;
		cin.get();
		for (int i = 0; i < ThreadsCount; i++) {
			DWORD time = threadsMaxTimeWaitingForQuant[i];

			if (time > 0) {
				cout << "Thread #" << i << " waited for the next quant for longer than " << TimeQuantLimit << " mls. " << "Actual waiting time: " << threadsMaxTimeWaitingForQuant[i] << " mls." << endl;
			}
		}
	}
}
