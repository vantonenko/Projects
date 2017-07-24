using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace TraceLogParser
{
    internal static class Program
    {
        private static void Main()
        {
            new Parser().Run();

            //GenerateHugeLogFile();
        }

        // ReSharper disable once UnusedMember.Local
        private static void GenerateHugeLogFile()
        {
            var allText = File.ReadAllLines(
                @"C:\Git\ContentManager\Source\Tools\Misc\TcmTraceLogParser\TraceLogParser\bin\Debug\SampleLogFile\tcm_trace-160MB.log.txt");

            File.WriteAllLines(
                @"C:\Git\ContentManager\Source\Tools\Misc\TcmTraceLogParser\TraceLogParser\bin\Debug\SampleLogFile\tcm_trace-~MB.log.txt",
                Enumerable.Range(0, 7).SelectMany(i => allText));
        }
    }
}
