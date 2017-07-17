using System.Collections.Generic;
using System.Linq;

namespace TraceLogParser
{
    internal class ProcessTraceRecords
    {
        public int Pid { get; set; }
        public IEnumerable<TraceRecord> Records { get; set; }
    }
}