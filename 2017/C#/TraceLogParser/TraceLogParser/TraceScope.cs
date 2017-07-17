using System;
using System.Collections.Generic;

namespace TraceLogParser
{
    internal class TraceScope
    {
        public MatchLocation Action { get; set; }
        public MatchLocation Actor { get; set; }
        public int Duration { get; set; } = -1;
        public DateTime Time { get; set; }
        public Guid Unique { get; set; }
        public string ActionString => Chunk?.Substring(Action.Index, Action.Length) ?? throw new Exception("Chunk property is null");
        public string ActorString => Chunk?.Substring(Actor.Index, Actor.Length) ?? throw new Exception("Chunk property is null");
        public string Chunk { get; set; }
        public List<TraceScope> Entries { get; set; } = new List<TraceScope>();
    }

    internal class TraceScopeCompact : Dictionary<string, TraceScopeCompact>
    {
    }
}