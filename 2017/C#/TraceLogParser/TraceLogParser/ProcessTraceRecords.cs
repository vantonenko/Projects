using System.Collections.Generic;

namespace TraceLogParser
{
    internal class ProcessTraceRecords
    {
        public string Pid { get; set; }
        public List<TraceRecord> Records { get; set; }
    }
}