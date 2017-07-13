using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace TraceLogParser
{
    internal class Parser
    {
        private const string FilePath = @"D:\Workflow\TraceLog_Parser\tcm_trace.log.txt";
        private const string OutDirectory = @"D:\Workflow\TraceLog_Parser\";

        // 04:06:14.646 <4672>     TcmPublisher: TransportEngine.GetDeploymentFeedback() exit. Duration: 1 ms. Returned value: '{}'
        // 04:06:14.644 <4672>     TcmPublisher: TransportEngine.GetDeploymentFeedback() entry.(in : line 162)
        private readonly Regex _regex = 
            new Regex(
                @"(?<time>\d\d:\d\d:\d\d\.\d\d\d) <(?<pid>\d*)>(?<level> *)(?<actor>[^:]*): (?<action>.*) (?<actionType>(entry)|(exit))\.((\(in : line (?<line>\d*)\))|( Duration: (?<duration>\d*) ms\. Returned value: (?<returnValue>.*)))");

        public void Proceed()
        {
            SplitTraceRecordsFile();
        }

        private IEnumerable<ProcessTraceRecordLines> GetProcessesTraceRecordLines()
        {
            int order = 0;
            IEnumerable<TraceRecordLine> traceRecordLines = File
                .ReadLines(FilePath)
                .Select(line => _regex.Match(line))
                .Where(match => match.Success)
                .Select(match => new TraceRecordLine
                {
                    Time = match.Groups["time"].Value,
                    ProcessId = match.Groups["pid"].Value,
                    LevelSpaces = match.Groups["level"].Value,
                    Actor = match.Groups["actor"].Value,
                    Action = match.Groups["action"].Value,
                    ActionType = match.Groups["actionType"].Value.ParseAction(),
                    Duration = match.Groups["duration"].Value,
                    ReturnValue = match.Groups["returnValue"].Value,
                    Line = match.Groups["line"].Value,
                    Order = order++, // time may be not precise enough if we later need to get the initial order of records
                    OriginalLine = match.Value
                });

            IEnumerable<ProcessTraceRecordLines> processesTraceRecordLines =
                traceRecordLines
                    .GroupBy(record => record.ProcessId)
                    .Select(g => new ProcessTraceRecordLines()
                    {
                        ProcessId = g.Key,
                        TraceRecordLines = g.OrderBy(record => record.Order)
                    });

            return processesTraceRecordLines;
        }

        private void SplitTraceRecordsFile()
        {
            IEnumerable<ProcessTraceRecordLines> processesTraceRecordLines = GetProcessesTraceRecordLines();

            foreach (var processTraceRecordLines in processesTraceRecordLines)
            {
                File.WriteAllLines(
                    Path.Combine(OutDirectory, $"Process_{processTraceRecordLines.ProcessId}.txt"),
                    processTraceRecordLines.TraceRecordLines.Select(record => record.PatchedLine));
            }
        }
    }
}