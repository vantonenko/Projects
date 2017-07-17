using System;
using System.Text.RegularExpressions;

namespace TraceLogParser
{
    public struct TraceRecord
    {
        // ReSharper disable UnusedAutoPropertyAccessor.Global
        public DateTime Time { get; set; }
        public int Pid { get; set; }
        public int Depth { get; set; }
        public MatchLocation Actor { get; set; }
        public MatchLocation Action { get; set; }
        public ActionType ActionType { get; set; }
        public MatchLocation OriginalStringLocation { get; set; }
        // ReSharper restore UnusedAutoPropertyAccessor.Global

        public string ActionString => Chunk?.Substring(Action.Index, Action.Length) ?? throw new Exception("Chunk property is null");
        public string ActorString => Chunk?.Substring(Actor.Index, Actor.Length) ?? throw new Exception("Chunk property is null");
        public string Chunk { get; set; }
        public string AsOriginalString => Chunk?.Substring(OriginalStringLocation.Index, OriginalStringLocation.Length) ?? throw new Exception("Chunk property is null");
        public int Duration => int.Parse(new Regex(@"Duration: (?<duration>\d*) ms.").Match(ActionString).Groups["duration"].Value);
        public string AsPatchedString =>
            (ActionType == ActionType.Entry
                ? AsOriginalString.Replace(new string(' ', Depth), new string(' ', Depth - 2))
                : AsOriginalString).TrimEnd('\n', '\r');
    }

    public enum ActionType
    {
        Entry,
        Exit,
        None
    }

    public static class StringExtensions
    {
        public static ActionType ParseActionType(this string action)
        {
            return
                action == null
                    ? ActionType.None
                    : action.Contains(" entry.")
                        ? ActionType.Entry
                        : action.Contains(" exit. Duration: ")
                            ? ActionType.Exit
                            : ActionType.None;
        }
    }
}