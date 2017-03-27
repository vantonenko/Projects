using System.Collections.Generic;
using System.Linq;

namespace Bridge17
{
    public class Solver
    {
        private static readonly IReadOnlyList<int> People = new List<int> {10, 5, 2, 1};
        private static readonly int TimeGoal = 17;
        private static readonly List<IReadOnlyList<int>> Moves = People.GetAllPairs().Concat(People.Select(p => new List<int> { p })).ToList();
        private readonly Stack<State> _stateStack = new Stack<State>();

        public static bool IsValidMove(State state, IReadOnlyList<int> move)
        {
            List<int> side = state.IsFlashAtLeft ? state.Left : state.Right;
            return move.All(side.Contains);
        }

        private bool NextStep(State state, int time)
        {
            if (time > TimeGoal) return false;
            _stateStack.Push(state);
            if (time == TimeGoal && !state.Left.Any()) return true;

            IEnumerable<bool> checkMoves = 
                Moves
                    .Where(
                        move => IsValidMove(state, move))
                    .Select(
                        move => NextStep(new State
                            {
                                Left = (state.IsFlashAtLeft ? state.Left.Except(move) : state.Left.Concat(move)).ToList(),
                                Right = (state.IsFlashAtLeft ? state.Right.Concat(move) : state.Right.Except(move)).ToList(),
                                IsFlashAtLeft = !state.IsFlashAtLeft
                            }, time + move.Max()));

            if (checkMoves.Any(isSolutionFound => isSolutionFound))
            {
                return true;
            }

            _stateStack.Pop();

            return false;
        }

        public IEnumerable<State> Solve()
        {
            var state = new State
            {
                Left = People.ToList(),
                Right = new List<int>(),
                IsFlashAtLeft = true
            };

            NextStep(state, 0);
            return _stateStack.Reverse();
        }
    }
}