namespace TraceLogParser
{
    public struct MatchLocation
    {
        public int Index { get; set; }
        public int Length { get; set; }

        public MatchLocation(int index, int length)
        {
            Index = index;
            Length = length;
        }
    }
}