using System.Collections.Generic;

namespace TraceLogParser
{
    internal class TraceScope
    {
        public string Action { get; set; }
        public string Duration { get; set; }
        public string Time { get; set; }
        public int Order { get; set; }
        public List<TraceScope> Entries { get; set; } = new List<TraceScope>();
    }

    internal class TraceScopeCompact : Dictionary<string, TraceScopeCompact>
    {
    }
}