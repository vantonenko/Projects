#pragma once
#include <mutex>
#include "windows.h"

using namespace std;

class ThreadsSample
{
	const static int ThreadsCount;
	const static int TimeQuantLimit;

	static mutex mtx;

	static void threadBody(void *params);

	static DWORD *threadsMaxTimeWaitingForQuant;
public:
	static void run();
};

