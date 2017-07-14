using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

namespace TraceLogParser
{
    internal class Parser
    {
        private const string FilePath = @"D:\Workflow\TraceLog_Parser\tcm_trace.log.txt";
        private const string OutPath = @"D:\Workflow\TraceLog_Parser\";

        private readonly Regex _regex = 
            new Regex(@"(?<time>\d\d:\d\d:\d\d\.\d\d\d) <(?<pid>\d\d\d\d)>(?<depthSpaces> *)(?<actor>[^:]*): (?<action>(.|\n|\r)*?(?=\d\d:\d\d:\d\d\.\d\d\d <\d\d\d\d>)|(.*$))");

        public void Run()
        {
            int order = 0;
            List<TraceRecord> records = _regex
                .Matches(File.ReadAllText(FilePath))
                .Cast<Match>()
                .Select(m => new TraceRecord
                {
                    Time = m.Groups["time"].Value,
                    Pid = m.Groups["pid"].Value,
                    DepthSpaces = m.Groups["depthSpaces"].Value,
                    Actor = m.Groups["actor"].Value,
                    Action = m.Groups["action"].Value.TrimEnd('\n', '\r'),
                    ActionType = m.Groups["action"].Value.ParseActionType(),
                    AsOriginalString = m.Value,
                    Order = order++
                })
                .ToList();

            var processes = records
                .GroupBy(r => r.Pid)
                .Select(g => new
                {
                    Pid = g.Key,
                    Records = g.OrderBy(r => r.Order).ToList()
                })
                .ToList();
            
            foreach (var process in processes)
            {
                File.WriteAllLines(
                    Path.Combine(OutPath, $"Process_{process.Pid}.txt"), 
                    process.Records.Select(record => record.AsPatchedString));

                var stack = new Stack<TraceScope>();
                var currentScope = new TraceScope();

                foreach (TraceRecord record in process.Records)
                {
                    switch (record.ActionType)
                    {
                        case ActionType.Entry:
                            var scope = new TraceScope { Action = record.Action };
                            currentScope.Entries.Add(scope);
                            stack.Push(currentScope);
                            currentScope = scope;
                            break;
                        case ActionType.Exit:
                            currentScope.Duration = record.Duration;
                            currentScope = stack.Pop();
                            break;
                        case ActionType.None:
                            break;
                    }
                }

                // we may have missing exit records
                while (stack.Count > 0) currentScope = stack.Pop();

                string json = JsonConvert.SerializeObject(currentScope, Formatting.Indented);
                File.WriteAllText(Path.Combine(OutPath, $"Process_{process.Pid}.json"), json);
            }
        }
    }
}