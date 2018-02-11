using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;

namespace FindDuplicateFiles
{
    internal static class Program
    {
        const string path = @"./../..";
        
        private static void Main(string[] args)
        {
            Console.WriteLine($"Start looking for duplicated files in '{path}' folder...");

            DateTime startTime = DateTime.Now;

            var result = Directory
                .EnumerateFiles(path, "*", SearchOption.AllDirectories)
                .AsParallel()
                .Select(filePath => new 
                    {
                        FilePath = filePath,
                        Hash = filePath.CalculateFileHash()
                    })
                .Where(o => !string.IsNullOrEmpty(o.Hash)) // ignore the files failed to be opened
                .GroupBy(o => o.Hash)
                .Where(g => g.Count() > 1)
                .Select(g => new 
                    { 
                        Hash = g.Key, 
                        Files = g.Select(f => f.FilePath) 
                    })
                .ToList();

            TimeSpan timeSpent = DateTime.Now - startTime;

            var isAre = result.Count == 1 ? "is" : "are";
            var s = result.Count == 1 ? string.Empty : "s";
            Console.WriteLine($"There {isAre} {result.Count} duplicated file{s}:");

            int counter = 0;
            Console.WriteLine(
                string.Join(
                    "\n", 
                    result.Select(r => 
                        $"{++counter}:\n{string.Join(",\n", r.Files.Select(f => $"\t'{f}'"))}")));

            Console.WriteLine($"Time spent for the whole LINQ query: {timeSpent.TotalMilliseconds} ms.");
        }
    }

    public static class StringExtensions 
    {
        public static string CalculateFileHash(this string filePath) 
        {
            using (MD5 md5 = MD5.Create())
            {
                try 
                {
                    using (FileStream stream = File.OpenRead(filePath))
                    {
                        return BitConverter.ToString(md5.ComputeHash(stream));
                    }
                }
                catch 
                {
                    return string.Empty;
                }
            }
        } 
    }
}
