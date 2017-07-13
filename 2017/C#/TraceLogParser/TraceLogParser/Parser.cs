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
                @"(?<time>\d\d:\d\d:\d\d\.\d\d\d) <(?<pid>\d*)>(?<level> *)(?<actor>[^:]*): (?<action>[^ ]*) (?<actionType>[^\.]*)\.((\(in : line (?<line>\d*)\))|( Duration: (?<duration>\d*) ms\. Returned value: (?<returnValue>.*)))");

        public void Proceed()
        {
            int order = 0;
            IEnumerable<TraceRecord> enumerableTraceRecords = File
                .ReadLines(FilePath)
                .Select(line => _regex.Match(line))
                .Where(match => match.Success)
                .Select(match => new TraceRecord
                {
                    Time = match.Groups["time"].Value,
                    ProcessId = match.Groups["pid"].Value,
                    LevelSpaces = match.Groups["level"].Value,
                    Actor = match.Groups["actor"].Value,
                    Action = match.Groups["action"].Value,
                    ActionType = match.Groups["actionType"].Value == "entry" ? ActionType.Entry : ActionType.Exit,
                    Duration = match.Groups["duration"].Value,
                    ReturnValue = match.Groups["returnValue"].Value,
                    Line = match.Groups["line"].Value,
                    Order = order++, // time may be not precise enough if we later need to get the initial order of records
                    OriginalLine = match.Value
                });

            var groupByProcessId = 
                enumerableTraceRecords
                    .GroupBy(record => record.ProcessId)
                    .Select(g => new
                    {
                        ProcessId = g.Key,
                        TraceRecords = g.OrderBy(record => record.Order)
                    });

            foreach (var processRecord in groupByProcessId)
            {
                File.WriteAllLines(
                    Path.Combine(OutDirectory, $"Process_{processRecord.ProcessId}.txt"), 
                    processRecord.TraceRecords.Select(record => record.PatchedLine));
            }
        }
    }
}