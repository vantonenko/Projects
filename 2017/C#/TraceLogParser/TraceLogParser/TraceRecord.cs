using System;
using System.Linq;

namespace TraceLogParser
{
    public class TraceRecord
    {
        public string Time { get; set; }

        public string ProcessId { get; set; }

        public int Level { get; set; }

        public string Actor { get; set; }

        public string Action { get; set; }

        public string ActionType { get; set; }

        public string Duration { get; set; }

        public string ReturnValue { get; set; }

        public string Line { get; set; }

        public int Order { get; set; }

        public string OriginalLine { get; set; }

        private string LevelSpaces => new string(' ', ActionType == "exit" ? Level : Level - 2);

        private string Details =>
            ActionType == "exit" ? 
                $" Duration: {Duration} ms. Returned value: {ReturnValue}" :
                $"(in : line {Line})";

        public string PatchedLine => $"{Time} <{ProcessId}>{LevelSpaces}{Actor}:{Action} {ActionType}.{Details}";
    }
}
