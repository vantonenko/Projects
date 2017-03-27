using System.Collections.Generic;

namespace Bridge17
{
    public class State
    {
        public List<int> Left { get; set; }
        public List<int> Right { get; set; }
        public bool IsFlashAtLeft { get; set; }
    }
}