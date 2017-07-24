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

        /// <summary>
        /// Used to generate huge dummy log files
        /// </summary>
        // ReSharper disable once UnusedMember.Local
        private static void GenerateHugeLogFile()
        {
            var allText = File.ReadAllLines(
                @"C:\Git\ContentManager\Source\Tools\Misc\TcmTraceLogParser\TraceLogParser\bin\x64\Debug\SampleLogFile\tcm_trace-2.7MB.log.txt");

            // copy the file content count times
            const int count = 800;
            const string outPath = @"C:\Git\ContentManager\Source\Tools\Misc\TcmTraceLogParser\TraceLogParser\bin\x64\Debug\SampleLogFile\tcm_trace-~MB.log.txt";
            File.WriteAllLines(outPath, Enumerable.Range(0, count).SelectMany(i => allText));
        }
    }
}
