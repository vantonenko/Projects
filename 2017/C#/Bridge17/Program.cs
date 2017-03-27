using System;
using System.Collections.Generic;

namespace Bridge17
{
    internal class Program
    {
        private static void Main()
        {
            IEnumerable<State> solution = new Solver().Solve();

            foreach (State state in solution)
            {
                string flashAtLeft = state.IsFlashAtLeft ? " @" : "";
                string flashAtRight = state.IsFlashAtLeft ? "" : "@ ";

                Console.WriteLine($"{string.Join(", ",state.Left)}{flashAtLeft}\t>==<\t{flashAtRight}{string.Join(", ", state.Right)}");
            }
        }
    }
}
