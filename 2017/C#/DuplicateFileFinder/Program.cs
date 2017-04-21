using System;
using System.IO;
using System.Linq;

namespace DuplicateFileFinder
{
    internal class Program
    {
        private const string FolderPath = @"E:\_Photo1";
        private const string OutputPath = @"E:\__duplicate_Photo1";
        private const string FileExtensions = @"*.mp4;*.jpg";

        private static void Main()
        {

            Console.WriteLine($"Calculating dulicated files in a '{FolderPath}' folder...");

            var duplicateFiles =
                FileExtensions.Split(';').SelectMany(ext => Directory.EnumerateFiles(FolderPath, ext, SearchOption.AllDirectories))
                    .Select(file => new FileInfo(file))
                    .GroupBy(file => new {
                        file.Name,
                        file.Length
                    })
                    .Where(g => g.Count() > 1)
                    .SelectMany(g => g.OrderBy(o => o.CreationTime).Skip(1))
                    .Select(o => new { o.FullName, o.Name }).ToList();

            Console.WriteLine($"Moving {duplicateFiles.Count} dulicated files to '{OutputPath}' folder...");

            if (!Directory.Exists(OutputPath))
            {
                Directory.CreateDirectory(OutputPath);
            }

            foreach (var file in duplicateFiles)
            {
                File.Move(file.FullName, Path.Combine(OutputPath, $"{Guid.NewGuid()}_{file.Name}"));
            }
        }
    }
}
