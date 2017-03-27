using System.Collections.Generic;
using System.Linq;

namespace Bridge17
{
    public static class EnumerableExtensions
    {
        public static IEnumerable<IReadOnlyList<int>> GetAllPairs(this IEnumerable<int> items)
        {
            List<int> itemsList = items.ToList();

            return
                Enumerable
                    .Range(0, itemsList.Count)
                    .SelectMany(
                        i => Enumerable.Range(i + 1, itemsList.Count - i - 1),
                        (i, j) => new List<int> { itemsList[i], itemsList[j] });
        }
    }
}