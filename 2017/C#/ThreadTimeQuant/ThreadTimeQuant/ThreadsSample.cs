using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace ThreadTimeQuant
{
    internal class ThreadsSample
    {
        private const int ThreadsCount = 8;
        private const double TimeQuantLimit = 1000;

        private Dictionary<string, int> _threadMap;
        private readonly double[] _threadStatistics = new double[ThreadsCount];


        public void Run()
        {
            _threadMap = Enumerable.Range(0, ThreadsCount).ToDictionary(i => $"Thread {(char) ('A' + i)}", i => i);

            IEnumerable<Thread> threads = _threadMap
                    .Select(kvp => new Thread(ThreadBody)
                    {
                        IsBackground = true,
                        Name = kvp.Key
                    });

            foreach (Thread thread in threads) { thread.Start(); }

            for (;;)
            {
                Console.WriteLine("Press eny key to get the current statistics...");

                Console.ReadKey();

                foreach (KeyValuePair<string, int> pair in _threadMap)
                {
                    if (_threadStatistics[pair.Value] > 0.0)
                    {
                        Console.WriteLine($"{pair.Key}: {_threadStatistics[pair.Value]}");
                    }
                }
            }
        }

        public void ThreadBody()
        {
            DateTime prevDate = DateTime.Now;
            for (;;)
            {
                DateTime newDate = DateTime.Now;
                TimeSpan timeDiff = newDate - prevDate;

                if (timeDiff.TotalMilliseconds > TimeQuantLimit)
                {
                    //Console.WriteLine($"{Thread.CurrentThread.Name} didn't get the time quant for more than {TimeQuantLimit} mls. Actual waiting time: {timeDiff.TotalMilliseconds} mls.");
                    string threadName = Thread.CurrentThread.Name;

                    // ReSharper disable once AssignNullToNotNullAttribute
                    double maxQuantWaitingTime = _threadStatistics[_threadMap[threadName]];

                    if (timeDiff.TotalMilliseconds > maxQuantWaitingTime)
                    {
                        _threadStatistics[_threadMap[threadName]] = timeDiff.TotalMilliseconds;
                    }
                }

                prevDate = newDate;
            }
            // ReSharper disable once FunctionNeverReturns
        }
    }
}