using System;
using System.Reflection;

namespace SharedNetStandard
{
    public static class NetStandardClass
    {
        public static string GetSomeValue() => ".net standard";

        public static void LoadAssembly()
        {
            Assembly asm = Assembly.LoadFrom(@"C:\Projects\2017\C#\NetStandard\AnotherNetStandard\bin\Debug\netstandard2.0\AnotherNetStandard.dll");
            Type type = asm.GetType("AnotherNetStandard.SomeClass");

            Console.WriteLine(
                $"Net standard library dynamically loaded another net standard library and got a type from it: {type}");
        }
    }
}
