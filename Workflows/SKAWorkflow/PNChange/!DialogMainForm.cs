using Audicon.SmartAnalyzer.Common.Interfaces;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;
using Audicon.SmartAnalyzer.Common.Types.ExecutionContext;
using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Utilities;
using System.Resources;

namespace PNChange
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        private IExecutionContext executionContext;
        private string strProjectPNAE;

        const string PNAE_KEY = "ac.global.PNAE";

        const char barDelimiter = '|';
        const char commaDelimiter = 'µ';
        const char tabDelimiter = ';';
        const char lineFeedDelimiter = '\n';
        const char carriageReturnDelimiter = '\r';

        private string libraryPath = "";

        public _DialogMainForm()
        {
            InitializeComponent();
            tabControl.SelectedIndexChanged += tabControl1_SelectedIndexChanged;
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            InitSmartContext();
            //InitLabels();
            Boolean globalParametersWhereWritten = false;
            globalParametersWhereWritten = CheckIfGlobalParametersWhereWrittenInIDEA();

            InitDialogFromSTDELFiles();

            if (globalParametersWhereWritten)
            {
                InitDialogFromIDEA();
            }
            else
            {
                InitDialogFromDELFiles();
            }
        }

        private bool CheckIfGlobalParametersWhereWrittenInIDEA()
        {
            bool result = true;
            strProjectPNAE = executionContext.MacroCommands.GlobalParameters().Get4Project(PNAE_KEY, false);
            if ((strProjectPNAE == null) || ((strProjectPNAE != null) && (strProjectPNAE.Equals(""))))
                result = false;
            return result;
        }

        private void InitSmartContext()
        {
            foreach (DictionaryEntry item in smartDataExchanger.Value)
            {
                if (item.Key.ToString().Equals("SmartContextKey"))
                {
                    executionContext = (IExecutionContext)item.Value;
                }
                //else if (item.Key.ToString().Equals("LibraryKey"))
                //{
                //    libraryPath = (String)item.Value;
                //}
            }
        }

        private void InitDialogFromIDEA()
        {
            HandlePNAETabFromIDEA(strProjectPNAE, barDelimiter, commaDelimiter);
        }

        private void InitDialogFromSTDELFiles()
        {
            var assembly = Assembly.GetExecutingAssembly();
            string resourcePNST = "PNChange.Resources.Primanotenplan.csv";
            string result;
            Encoding inputEncoding = Encoding.GetEncoding("Windows-1252");

            Stream stream = assembly.GetManifestResourceStream(resourcePNST);
            StreamReader reader = new StreamReader(stream, inputEncoding);
            result = reader.ReadToEnd();
            //result = result.Replace("\r", "");
            //result = result.Replace("\"", "");
            HandlePSTETabFromDELFiles(result, lineFeedDelimiter, tabDelimiter);
        }

        private void InitDialogFromDELFiles()
        {
            var assembly = Assembly.GetExecutingAssembly();
            string resourcePNAE = "PNChange.Resources.Primanotenplan_AE.csv";
            string result;
            Encoding inputEncoding = Encoding.GetEncoding("Windows-1252");

            Stream stream = assembly.GetManifestResourceStream(resourcePNAE);
            StreamReader reader = new StreamReader(stream, inputEncoding);
            result = reader.ReadToEnd();
            //result = result.Replace("\r", "");
            //result = result.Replace("\"", "");
            HandlePNAETabFromDELFiles(result, lineFeedDelimiter, tabDelimiter);
        }

        private void HandlePNAETabFromIDEA(string content, char wordSplitter, char entriesSplitter)
        {
            try
            {
                dataGridViewPNAE.Rows.Clear();
                dataGridViewPNAE.Refresh();

                string[] lines = content.Split(entriesSplitter);
                string[] words;
                // int x = 0;
                foreach (string line in lines)
                {
                    // words = line.Split(wordSplitter);
                    // if (x != 0) //skip first line
                    // {
                    words = line.Split(wordSplitter);
                    if (!line.Trim().Equals(""))
                    {
                        int ID = this.dataGridViewPNAE.Rows.Add();
                        DataGridViewRow row = dataGridViewPNAE.Rows[ID];
                        for (int i = 0; i < 4; i++)
                        {
                            row.Cells[i].Value = words[i];
                        }
                    }
                    // }
                    // ++x;

                }
            }
            catch
            {
                MessageBox.Show("Die Datenquelle für die Primanotenänderungen-Tabelle von IDEA ist nicht valide.");
            }
        }

        private void HandlePNAETabFromFile(string content, char wordSplitter, char entriesSplitter)
        {
            try
            {
                dataGridViewPNAE.Rows.Clear();
                dataGridViewPNAE.Refresh();

                string[] lines = content.Split(entriesSplitter);
                string[] words;
                int x = 0;
                foreach (string line in lines)
                {
                    // words = line.Split(wordSplitter);
                    if (x != 0) //skip first line
                    {
                        words = line.Split(wordSplitter);
                        if (!line.Trim().Equals(""))
                        {
                            int ID = this.dataGridViewPNAE.Rows.Add();
                            DataGridViewRow row = dataGridViewPNAE.Rows[ID];
                            for (int i = 0; i < 4; i++)
                            {
                                row.Cells[i].Value = words[i];
                            }
                        }
                    }
                    ++x;

                }
            }
            catch
            {
                MessageBox.Show("Die Datenquelle für die Primanotenänderungen-Tabelle von Datei ist nicht valide.");
            }
        }

        private void HandlePNAETabFromDELFiles(string content, char entriesSplitter, char wordSplitter)
        {
            try
            {
                dataGridViewPNAE.Rows.Clear();
                dataGridViewPNAE.Refresh();

                string[] lines = content.Split(entriesSplitter);
                string[] words;
                int x = 0;
                foreach (string line in lines)
                {
                    if (x != 0) //skip first line
                    {
                        words = line.Split(wordSplitter);
                        if (!line.Trim().Equals(""))
                        {
                            int ID = this.dataGridViewPNAE.Rows.Add();
                            DataGridViewRow row = dataGridViewPNAE.Rows[ID];
                            for (int i = 0; i < 4; i++)
                            {
                                row.Cells[i].Value = words[i];
                            }
                        }
                    }
                    ++x;
                }
            }
            catch
            {
                MessageBox.Show("Die Datenquelle für die Ref-Primanotenänderungen-Tabelle ist nicht valide.");
            }
        }

        private void HandlePSTETabFromDELFiles(string content, char entriesSplitter, char wordSplitter)
        {
            try
            {
                dataGridViewPNST.Rows.Clear();
                dataGridViewPNST.Refresh();

                string[] lines = content.Split(entriesSplitter);
                string[] words;
                int x = 0;
                foreach (string line in lines)
                {
                    if (x != 0) //skip first line
                    {
                        words = line.Split(wordSplitter);
                        if (!line.Trim().Equals(""))
                        {
                            int ID = this.dataGridViewPNST.Rows.Add();
                            DataGridViewRow row = dataGridViewPNST.Rows[ID];
                            for (int i = 0; i < 4; i++)
                            {
                                row.Cells[i].Value = words[i];
                            }
                        }
                    }
                    ++x;
                }
            }
            catch
            {
                MessageBox.Show("Die Datenquelle für die Standard-Primanoten-Tabelle ist nicht valide.");
            }
        }

        private string PopulateStrPNAE()
        {
            string strPNAE = "";
            // Add column headers as the first row
            foreach (DataGridViewColumn column in dataGridViewPNAE.Columns)
            {
                strPNAE += column.HeaderText + ";";
            }
            strPNAE = strPNAE.TrimEnd(';');

            foreach (DataGridViewRow row in dataGridViewPNAE.Rows)
            {
                if ((row.Cells[0].Value != null) && (row.Cells[0].Value.ToString() != ""))
                {
                    if (String.IsNullOrEmpty(strPNAE))
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNAE += row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNAE += tabDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                    else
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNAE += lineFeedDelimiter + row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNAE += tabDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                }
            }

            return strPNAE;
        }

        private string PopulateStrPNST()
        {
            string strPNST = "";
            // Add column headers as the first row
            foreach (DataGridViewColumn column in dataGridViewPNST.Columns)
            {
                strPNST += column.HeaderText + ";";
            }
            strPNST = strPNST.TrimEnd(';');

            foreach (DataGridViewRow row in dataGridViewPNST.Rows)
            {
                if ((row.Cells[0].Value != null) && (row.Cells[0].Value.ToString() != ""))
                {
                    if (String.IsNullOrEmpty(strPNST))
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNST += row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNST += tabDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                    else
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNST += lineFeedDelimiter + row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNST += tabDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                }
            }

            return strPNST;
        }

        private string PopulateStrPNAEForIDEA()
        {
            string strPNAE = "";
            foreach (DataGridViewRow row in dataGridViewPNAE.Rows)
            {
                if ((row.Cells[0].Value != null) && (row.Cells[0].Value.ToString() != ""))
                {
                    if (String.IsNullOrEmpty(strPNAE))
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNAE += row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNAE += barDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                    else
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (i == 0)
                            {
                                strPNAE += commaDelimiter + row.Cells[i].Value?.ToString();
                            }
                            else
                            {
                                strPNAE += barDelimiter + row.Cells[i].Value?.ToString();
                            }
                        }
                    }
                }
            }

            return strPNAE;
        }

        private void _DialogMainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void buttonLoadFromFile_Click(object sender, EventArgs e)
        {
            string fileContent = "";

            string strOpenFileHeaderText = "Datei für Primanotenänderungen laden";

            OpenFileDialog openFileDialog = new OpenFileDialog();

            openFileDialog.Filter = "CSVdateien" + " (*.csv)|*.csv|" + "Alle Dateien" + " (*.*)|*.*";
            openFileDialog.Title = strOpenFileHeaderText;

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                fileContent = Utilities.OpenFile(openFileDialog.FileName);
            }

            if (!fileContent.Equals(""))
            {
                HandlePNAETabFromFile(fileContent, tabDelimiter, lineFeedDelimiter);
            }
        }

        private void buttonSaveToFile_Click(object sender, EventArgs e)
        {
            if (tabControl.SelectedTab == tabControl.TabPages["tabPNST"])
            {
                string strSaveFileHeaderText = "Standard-Primanoten in einer Datei speichern";
                string strFileName = "Standard-Primanoten.csv";
                string strFileContent = PopulateStrPNST();

                // Displays a SaveFileDialog so the user can save the Image  
                // assigned to Button2.  
                SaveFileDialog saveFileDialog1 = new SaveFileDialog();
                saveFileDialog1.Filter = "CSV-Dateien" + " (*.csv)|*.csv|" + "Alle Dateien" + " (*.*)|*.*";
                saveFileDialog1.Title = strSaveFileHeaderText;
                saveFileDialog1.DefaultExt = "csv";
                saveFileDialog1.FileName = strFileName;
                DialogResult result;
                result = saveFileDialog1.ShowDialog();

                // If the file name is not an empty string open it for saving.  
                if (result == DialogResult.OK && saveFileDialog1.FileName != "")
                {
                    System.IO.FileStream fs =
                       (System.IO.FileStream)saveFileDialog1.OpenFile();
                    Utilities.SaveFile(fs, strFileContent);
                }
            }
            if (tabControl.SelectedTab == tabControl.TabPages["tabPNAE"])
            {
                string strSaveFileHeaderText = "Primanotenänderungen in einer Datei speichern";
                string strFileName = "Primanoten-Änderungen.csv";
                string strFileContent = PopulateStrPNAE();

                // Displays a SaveFileDialog so the user can save the Image  
                // assigned to Button2.  
                SaveFileDialog saveFileDialog1 = new SaveFileDialog();
                saveFileDialog1.Filter = "CSV-Dateien" + " (*.csv)|*.csv|" + "Alle Dateien" + " (*.*)|*.*";
                saveFileDialog1.Title = strSaveFileHeaderText;
                saveFileDialog1.DefaultExt = "csv";
                saveFileDialog1.FileName = strFileName;
                DialogResult result;
                result = saveFileDialog1.ShowDialog();

                // If the file name is not an empty string open it for saving.  
                if (result == DialogResult.OK && saveFileDialog1.FileName != "")
                {
                    System.IO.FileStream fs =
                       (System.IO.FileStream)saveFileDialog1.OpenFile();
                    Utilities.SaveFile(fs, strFileContent);
                }
            }
        }

        private void dataGridViewPNAE_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyData == Keys.Delete)
            {
                foreach (DataGridViewRow row in dataGridViewPNAE.SelectedRows)
                    if (!row.IsNewRow) dataGridViewPNAE.Rows.Remove(row);
            }
        }

        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            string strPNAE = "";
            if (this.DialogResult == DialogResult.OK)
            {
                // if (strProjectPNAE != strPNAE)
                // {
                DialogResult result = MessageBox.Show("Möchten Sie den aktuellen Inhalt speichern?", "Bestätigung", MessageBoxButtons.YesNoCancel);
                if (result == DialogResult.No)
                {
                    e.Cancel = false;
                    return;
                }
                else if (result == DialogResult.Cancel)
                {
                    e.Cancel = true;
                    return;
                }
                if ((strProjectPNAE != null) && (!strProjectPNAE.Equals("")))
                {
                    executionContext.MacroCommands.GlobalParameters().Delete4Project(PNAE_KEY, false);
                }
                strPNAE = PopulateStrPNAEForIDEA();
                executionContext.MacroCommands.GlobalParameters().Set4Project(PNAE_KEY, strPNAE);
                // string shortMessage = strPNAE.Length > 1000 ? strPNAE.Substring(0, 1000) : strPNAE;
                // MessageBox.Show(shortMessage);
                // }
                // else
                // {
                //     e.Cancel = false;
                //     return;
                // }
            }
            else if (this.DialogResult == DialogResult.Cancel)
            {
                DialogResult result = MessageBox.Show("Möchten Sie die Dialogbox wirklich schließen?", "Bestätigung", MessageBoxButtons.YesNoCancel);
                if ((result == DialogResult.No) || (result == DialogResult.Cancel))
                {
                    e.Cancel = true;
                }
            }
        }

        private void Button_Cancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void buttonResetGrid_Click(object sender, EventArgs e)
        {
            DialogResult check = MessageBox.Show("Möchten Sie Ihre Eingaben zurücksetzen?\n\nIhre Eingaben gehen dadurch verloren.\nSpeichern Sie diese bei Bedarf ab.", "Zurücksetzen", MessageBoxButtons.YesNo);
            if (check == DialogResult.Yes)
            {
                //executionContext.MacroCommands.GlobalParameters().Delete4Project(PNAE_KEY, false);
                InitDialogFromDELFiles();
            }
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl.SelectedTab == tabControl.TabPages["tabPNST"])
            {
                buttonLoadFromFile.Enabled = false;
                buttonResetGrid.Enabled = false;
                toolTip1.SetToolTip(buttonSaveToFile, "Speichert den Standard-Primanotenplan in einer csv-Datei zur Ansicht/Veränderung z.B. in Excel");
            }
            else if (tabControl.SelectedTab == tabControl.TabPages["tabPNAE"])
            {
                buttonLoadFromFile.Enabled = true;
                buttonResetGrid.Enabled = true;
                toolTip1.SetToolTip(buttonSaveToFile, "Speichert die Modifizierungen in einer CSV-Datei zur späteren Verwendung.");
            }
            // Add more conditions for other tabs if needed
        }
    }
}
