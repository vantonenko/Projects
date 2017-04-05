using System;
using System.Linq;
using System.ServiceProcess;

namespace DesktopCleaner
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        private static void Main(string []args)
        {
            if (args.Contains("/d"))
            {
                RunAsConsole();
                return;
            }

            var servicesToRun = new ServiceBase[]
            {
                new DesktopCleaner()
            };

            ServiceBase.Run(servicesToRun);
        }

        private static void RunAsConsole()
        {
            var processor = new Processor();
            processor.Start();
            Console.ReadKey();
            processor.Stop();
        }
    }
}
