using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace ThreadTimeQuant
{
    internal class ThreadsSample
    {
        private const int ThreadsCount = 5;
        private const double TimeQuantLimit = 50;

        public void Run()
        {
            IEnumerable<Thread> threads = 
                Enumerable
                    .Range(0, ThreadsCount)
                    .Select(i => new Thread(ThreadBody)
                    {
                        IsBackground = true,
                        Name = $"Thread {(char)('A' + i)}"
                    });

            foreach (Thread thread in threads) { thread.Start(); }

            Console.ReadKey();
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
                    Console.WriteLine($"{Thread.CurrentThread.Name} didn't get the time quant for more than {TimeQuantLimit} mls. Actual waiting time: {timeDiff.TotalMilliseconds} mls.");
                }

                prevDate = newDate;
            }
            // ReSharper disable once FunctionNeverReturns
        }
    }
}