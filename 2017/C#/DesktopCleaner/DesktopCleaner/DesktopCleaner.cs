using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.ServiceProcess;

namespace DesktopCleaner
{
    public partial class DesktopCleaner : ServiceBase
    {
        private Processor _processor;

        public DesktopCleaner()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            _processor = new Processor();
            _processor.Start();
        }

        protected override void OnStop()
        {
            _processor?.Stop();
        }
    }

    public class Processor
    {
        private static readonly List<string> FilesToDelete = ConfigurationManager.AppSettings["filesToRemove"].Split(';').ToList();
        private static readonly string DesktopPath = ConfigurationManager.AppSettings["desktopPath"];
        private readonly FileSystemWatcher _fileSystemWatcher = new FileSystemWatcher(DesktopPath, "*.*") { NotifyFilter = NotifyFilters.FileName };

        public void Start()
        {
            foreach (string file in Directory.EnumerateFiles(DesktopPath).Where(IsFileToDelete))
            {
                File.Delete(file);
            }

            _fileSystemWatcher.Created += FileSystemWatcherOnCreated;
            _fileSystemWatcher.EnableRaisingEvents = true;
        }

        private void FileSystemWatcherOnCreated(object sender, FileSystemEventArgs fileSystemEventArgs)
        {
            if (!IsFileToDelete(fileSystemEventArgs.Name)) return;

            do
            {
                try
                {
                    File.Delete(fileSystemEventArgs.FullPath);
                }
                catch (IOException exc) when (exc.Message.EndsWith("because it is being used by another process."))
                {
                    continue;
                }
                break;
            } while (true);
        }

        private bool IsFileToDelete(string file)
        {
            return FilesToDelete.Contains(Path.GetFileNameWithoutExtension(file));
        }

        public void Stop()
        {
            _fileSystemWatcher.Created -= FileSystemWatcherOnCreated;
        }
    }
}
