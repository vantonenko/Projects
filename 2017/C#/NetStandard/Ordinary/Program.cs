using System;
using SharedNetStandard;

namespace Ordinary
{
    internal static class Program
    {
        private static void Main()
        {
            Console.WriteLine($"Ordinary framework references net standard library: {NetStandardClass.GetSomeValue()}");
        }
    }
}
