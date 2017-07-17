using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

namespace TraceLogParser
{
    /// <summary>
    /// Split tcm log file onto process specific ones.
    /// Also to be able to hide\show nested trace records it produces JSON files
    /// </summary>
    internal class Parser
    {
        private readonly string _filePath = ConfigurationManager.AppSettings["TcmLogFilePath"];
        private readonly string _outPath = ConfigurationManager.AppSettings["OutPutFolder"];

        private readonly Regex _regex =
            new Regex(@"(?<time>\d\d:\d\d:\d\d\.\d\d\d) <(?<pid>\d\d\d\d)>(?<depthSpaces> *)(?<actor>[^:]*): (?<action>(.|\n|\r)*?(?=\d\d:\d\d:\d\d\.\d\d\d <\d\d\d\d>)|(.*$))");

        public void Run()
        {
            int order = 0;
            IEnumerable<TraceRecord> records = _regex
                .Matches(File.ReadAllText(_filePath))
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
                });

            List<ProcessTraceRecords> processes = records
                .GroupBy(r => r.Pid)
                .Select(g => new ProcessTraceRecords
                {
                    Pid = g.Key,
                    Records = g.OrderBy(r => r.Order).ToList()
                })
                .ToList();

            foreach (ProcessTraceRecords process in processes)
            {
                // Produce single process trace log file
                File.WriteAllLines(
                    Path.Combine(_outPath, $"Process_{process.Pid}.txt"),
                    process.Records.Select(record => record.AsPatchedString));

                var stack = new Stack<TraceScope>();
                var currentScope = new TraceScope();

                foreach (TraceRecord record in process.Records)
                {
                    switch (record.ActionType)
                    {
                        case ActionType.Entry:
                            var scope = new TraceScope
                            {
                                Action = record.Action,
                                Actor = record.Actor,
                                Time = record.Time,
                                Order = record.Order
                            };
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

                // Produce single process JSON log file (so that can collapse\expand nested records)
                TraceScopeCompact traceScopeCompact = BuildTraceScopeCompact(currentScope);
                string json = JsonConvert.SerializeObject(traceScopeCompact, Formatting.Indented);
                File.WriteAllText(Path.Combine(_outPath, $"Process_{process.Pid}.json"), json);
            }
        }

        private static TraceScopeCompact BuildTraceScopeCompact(TraceScope scope)
        {
            var traceScopeCompact = new TraceScopeCompact();

            foreach (TraceScope traceScope in scope.Entries)
            {
                traceScopeCompact.Add(
                    $"{traceScope.Time} [{traceScope.Duration ?? "?"} ms] {traceScope.Actor}:{traceScope.Action} @{traceScope.Order}", 
                    BuildTraceScopeCompact(traceScope));
            }

            return traceScopeCompact;
        }
    }
}