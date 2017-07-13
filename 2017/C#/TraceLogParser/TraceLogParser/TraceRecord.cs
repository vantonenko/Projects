using System;
using System.Linq;

namespace TraceLogParser
{
    public class TraceRecord
    {
        public string Time { get; set; }

        public string ProcessId { get; set; }

        public string Actor { get; set; }

        public string Action { get; set; }

        public ActionType ActionType { get; set; }

        public string Duration { get; set; }

        public string ReturnValue { get; set; }

        public string Line { get; set; }

        public int Order { get; set; }

        public string OriginalLine { get; set; }

        public string LevelSpaces { get; set; }

        /// <summary>
        /// Somehow the 'entry' seems record always has a 2 spaces shift
        /// </summary>
        public int Level => ActionType == ActionType.Entry ? LevelSpaces.Length - 2 : LevelSpaces.Length;

        private string Details =>
            ActionType == ActionType.Exit ? 
                $" Duration: {Duration} ms. Returned value: {ReturnValue}" :
                $"(in : line {Line})";

        public string PatchedLine => $"{Time} <{ProcessId}>{new string(' ', Level)}{Actor}:{Action} {ActionType}.{Details}";
    }

    public enum ActionType
    {
        Entry,
        Exit
    }
}
