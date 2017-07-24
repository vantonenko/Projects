using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
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
        private static readonly string FilePath = ConfigurationManager.AppSettings["TcmLogFilePath"];
        private static readonly string FileName = Path.GetFileNameWithoutExtension(FilePath);
        private readonly string _outPath = ConfigurationManager.AppSettings["OutPutFolder"];

        private readonly Regex _regex =
            new Regex(
                @"(?<time>\d\d:\d\d:\d\d\.\d\d\d) <(?<pid>\d\d\d\d)>(?<depthSpaces> *)(?<actor>[^:]*): (?<action>(.|\n|\r)*?(?=\d\d:\d\d:\d\d\.\d\d\d <\d\d\d\d>)|(.*$))", 
                RegexOptions.Compiled);

        public const int DecentMaxChunkSize = 500 * 1024 * 1024; // 500M chars

        public void Run()
        {
            TraceRecord[] records = 
                ReadAllTextChunks()
                    .SelectMany(chunk => 
                        GetTraceRecordMatches(chunk)
                        .Select(m => new TraceRecord
                            {
                                Time = DateTime.Parse(m.Groups["time"].Value),
                                Pid = int.Parse(m.Groups["pid"].Value),
                                Depth = m.Groups["depthSpaces"].Value.Length,
                                Actor = new MatchLocation(m.Groups["actor"].Index, m.Groups["actor"].Length),
                                Action = new MatchLocation(m.Groups["action"].Index, m.Groups["action"].Length),
                                ActionType = m.Groups["action"].Value.ParseActionType(),
                                OriginalStringLocation = new MatchLocation(m.Index, m.Length),
                                Duration = m.Groups["action"].Value.ParseDuration(),
                                Chunk = chunk
                            })
                    )
                    .ToArray();

            List<int> pids = records.Select(r => r.Pid).Distinct().ToList();

            IEnumerable<ProcessTraceRecords> processes = pids
                .Select(pid => new ProcessTraceRecords
                {
                    Pid = pid,
                    Records = records.Where(r => r.Pid == pid)
                });

            foreach (ProcessTraceRecords process in processes)
            {
                // Produce single process trace log file
                File.WriteAllLines(
                    Path.Combine(_outPath, $"{FileName}_{process.Pid}.txt"),
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
                                Unique = Guid.NewGuid(),
                                Chunk = record.Chunk
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
                SerializeToFileAsJson(traceScopeCompact, Path.Combine(_outPath, $"{FileName}_{process.Pid}.json"));
            }
        }

        private void SerializeToFileAsJson(TraceScopeCompact traceScopeCompact, string filePath)
        {
            using (var jsonTextWriter = new StreamWriter(filePath))
            {
                JsonSerializer jsonSerializer = JsonSerializer.CreateDefault(new JsonSerializerSettings());
                jsonSerializer.Formatting = Formatting.Indented;
                jsonSerializer.Serialize(jsonTextWriter, traceScopeCompact, null);
            }
        }

        /// <summary>
        /// In order to workaround max string size limit do read the file by chunks.
        /// A chunk can't be finished on a line which breaks the trace record (trace record can be multiline).
        /// </summary>
        private IEnumerable<string> ReadAllTextChunks()
        {
            var sb = new StringBuilder();
            foreach (string line in File.ReadLines(FilePath))
            {
                sb.AppendLine(line);

                if (sb.Length > DecentMaxChunkSize && IsExitAction(line))
                {
                    yield return sb.ToString();
                    sb = new StringBuilder();
                }
            }

            yield return sb.ToString();
            // ReSharper disable once RedundantAssignment
            sb = null;
        }

        private bool IsExitAction(string line)
        {
            return _regex.Match(line).Groups["action"].Value.ParseActionType() == ActionType.Exit;
        }

        /// <summary>
        /// Enumerates through the list of regex matches for the specified chunk of the text.
        /// </summary>
        private IEnumerable<Match> GetTraceRecordMatches(string chunk)
        {
            int startPosition = 0;
            while (startPosition < chunk.Length)
            {
                Match match = _regex.Match(chunk, startPosition, Math.Min(10 * 1024, chunk.Length - startPosition));
                if (!match.Success) yield break;

                startPosition = match.Index + match.Length;
                yield return match;
            }
        }

        /// <summary>
        /// Build the object to be serialized into JSON log file - {"action description": [{"subaction description" : [...]}, {...}]
        /// </summary>
        private static TraceScopeCompact BuildTraceScopeCompact(TraceScope scope)
        {
            var traceScopeCompact = new TraceScopeCompact();

            foreach (TraceScope traceScope in scope.Entries)
            {
                traceScopeCompact.Add(traceScope, BuildTraceScopeCompact(traceScope));
            }

            return traceScopeCompact;
        }
    }
}