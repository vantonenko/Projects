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
}
