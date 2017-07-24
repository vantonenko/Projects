using System.Collections.Generic;
using Newtonsoft.Json;

namespace TraceLogParser
{
    [JsonConverter(typeof(TraceScopeCompactJsonConverter))]
    internal class TraceScopeCompact : Dictionary<TraceScope, TraceScopeCompact>
    {
    }
}