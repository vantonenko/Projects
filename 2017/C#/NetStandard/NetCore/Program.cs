using System;
using SharedNetStandard;

namespace NetCore
{
    internal class Program
    {
        private static void Main()
        {
            Console.WriteLine($"Core framework references net standard library: {NetStandardClass.GetSomeValue()}");

            NetStandardClass.LoadStandardAssembly();
        }
    }
}