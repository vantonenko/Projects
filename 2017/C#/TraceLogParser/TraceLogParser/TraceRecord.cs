using System.Text.RegularExpressions;

namespace TraceLogParser
{
    public class TraceRecord
    {
        // ReSharper disable UnusedAutoPropertyAccessor.Global
        public string Time { get; set; }
        public string Pid { get; set; }
        public string DepthSpaces { get; set; }
        public string Actor { get; set; }
        public string Action { get; set; }
        public ActionType ActionType { get; set; }
        public string AsOriginalString { get; set; }
        public int Order { get; set; }
        // ReSharper restore UnusedAutoPropertyAccessor.Global

        public string Duration => new Regex(@"Duration: (?<duration>\d*) ms.").Match(Action).Groups["duration"].Value;

        public string AsPatchedString =>
            (ActionType == ActionType.Entry
                ? AsOriginalString.Replace(DepthSpaces, new string(' ', DepthSpaces.Length - 2))
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
            return action.Contains(" entry.")
                ? ActionType.Entry
                : action.Contains(" exit. Duration: ")
                    ? ActionType.Exit
                    : ActionType.None;
        }
    }
}