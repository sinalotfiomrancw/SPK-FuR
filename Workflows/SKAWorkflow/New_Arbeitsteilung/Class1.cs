using Audicon.SmartAnalyzer.Common.Components.ExecutionContext;
using Audicon.SmartAnalyzer.Common.Interfaces;
using Audicon.SmartAnalyzer.Common.Interfaces.AppStartWorkflow;
using Audicon.SmartAnalyzer.Common.Interfaces.Storage;
using Audicon.SmartAnalyzer.Common.Interfaces.TestResults;
using Audicon.SmartAnalyzer.Common.Interfaces.Tracking;
using Audicon.SmartAnalyzer.Common.Types.AppStartWorkflow;
using Audicon.SmartAnalyzer.Components.Protocol;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace New_Arbeitsteilung
{
    public class ShareProject : IAppStartWorkflowCustomAction
    {
        public void Execute(AppStartWorkflowExecutionContext context, string commandLine)
        {
            //Debugger.Launch ();
            var execSrv = TaskExecutionContext.Services.GetService<IDataAccessFactory>()?.GetDataAccessTracking() ??
                          throw new InvalidOperationException("DB Execution Service not found");
            var dataSrv = TaskExecutionContext.Services.GetService<IDataAccessFactory>()?.GetDataAccessStorage() ??
                          throw new InvalidOperationException("DB Storage Service not found");

            var testIds2ExecRecs = execSrv.GetExecutions(false);
            var protocoller = new ResultProtocolReader();
            var report = new StringBuilder();

            foreach (var pair in testIds2ExecRecs)
            {
                var execRecs = pair.Value.Where(rec => rec.SessionID != Guid.Empty).ToArray();
                if (!execRecs.Any()) continue;

                var testInfo = dataSrv.GetContentObject<ITest>(pair.Key, Audicon.SmartAnalyzer.Common.Types.AdditionalDataFlags.Info4Test);
                if (null == testInfo) continue;

                foreach (var execRec in execRecs)
                {
                    if (report.Length > 0)
                    {
                        report.AppendLine("\r\n-------------------------------------------------------------");
                    }

                    report.AppendLine($"Audit Test: '{testInfo.Name}', ID = '{testInfo.Id}', Owner = '{testInfo.OwnerName}', State = '{execRec.TaskState}'");

                    ITestResultInfo resInfo = protocoller.GetResultsInfo(new Guid[] { execRec.SessionID }).FirstOrDefault();
                    if (null == resInfo) continue;

                    ITestResultInputFile inputFile = resInfo.GetPrimaryInputFile();

                    if (null != inputFile)
                    {
                        report.AppendLine($"Input file: Path = '{inputFile.Path}', ID = '{inputFile.FileId}'");
                    }

                    report.AppendLine("\r\nOutput files:");

                    foreach (var resFile in resInfo.TestResultFiles.Where(rf => rf.Type != Audicon.SmartAnalyzer.Common.Types.TestResults.TestResultFileTypes.SourceTable))
                    {
                        report.AppendLine($"Name = '{resFile.Name}', ID = '{resFile.FileId}', Type = '{resFile.Type}'");
                    }
                }
            }

            string[] paths = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "AuxData", "SK_FuR", "report.txt" };
            var reportFilePath = Path.Combine(paths);
            //var reportFilePath = Path.Combine (Path.GetTempPath(), "report.txt");

            File.WriteAllText(reportFilePath, report.ToString(), Encoding.Default);
            MessageBox.Show("Die Liste der erstellten Ergebnisdateien wurde erfolgreich erstellt.");
            //Process.Start (reportFilePath);
        }
    }
}
