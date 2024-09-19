using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace Import_OBR_Vergleich
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        public bool AskQuestion = false;
        public bool RealChange = true;
        string InitialDirectory;
        string[] fileEntriesCurrent;
        string[] fileEntriesPrev;
        public _DialogMainForm()
        {
            InitializeComponent();
            this.aktuellesGJAHRCSV.AutoCheck = false;
            this.aktuellesGJAHRCurrentProject.AutoCheck = false;
            this.aktuellesGJAHRDifferentProject.AutoCheck = false;
            this.aktuellesGJAHRCSV.MouseClick += this.aktuellesGJAHRCSV_Clicked;
            this.aktuellesGJAHRCurrentProject.MouseClick += this.aktuellesGJAHRCurrentProject_Clicked;
            this.aktuellesGJAHRDifferentProject.MouseClick += this.aktuellesGJAHRDifferentProject_Clicked;
            this.vorherigesGJAHRCSV.AutoCheck = false;
            this.vorherigesGJAHRCurrentProject.AutoCheck = false;
            this.vorherigesGJAHRDifferentProject.AutoCheck = false;
            this.vorherigesGJAHRCSV.MouseClick += this.vorherigesGJAHRCSV_Clicked;
            this.vorherigesGJAHRCurrentProject.MouseClick += this.vorherigesGJAHRCurrentProject_Clicked;
            this.vorherigesGJAHRDifferentProject.MouseClick += this.vorherigesGJAHRDifferentProject_Clicked;
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }
        }

        private void _DialogMainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (AskQuestion == true)
            {
                //aktuelles Geschäftsjahr
                //----------------------------------------------------------------------------------
                AskQuestion = false;
                if (aktuellesGeschäftsjahr.SelectedItem.ToString() == "keine Eingabe")
                {
                    string message = "Bitte geben Sie das aktuelle Geschäftsjahr ein.";
                    string caption = "Fehlendes Geschäftsjahr";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (aktuellesGJAHRCSV.Checked == true && (aktuellesGJAHROBR.Value == "")) // || aktuellesGJAHROBR.Value.Substring(aktuellesGJAHROBR.Value.Length - 4, 4) != ".csv"))
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende OBR Liste für den aktuellen Zeitraum aus.";
                    string caption = "Fehlende OBR Konten";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (aktuellesGJAHRDifferentProject.Checked == true && (aktuellesGJAHROBR.Value == ""))// || aktuellesGJAHROBR.Value.Substring(aktuellesGJAHROBR.Value.Length - 4, 4) != ".imd"))
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende OBR Liste für den aktuellen Zeitraum aus.";
                    string caption = "Fehlende OBR Konten";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (aktuellesGJAHRUmsetzungen.Value == "")
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende CSV Datei für die Umsetzungen für den aktuellen Zeitraum aus.";
                    string caption = "Fehlende Umsetzungen";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                //vorheriges Geschäftsjahr
                //-----------------------------------------------------------------------------------
                if (vorherigesGeschäftsjahr.SelectedItem.ToString() == "keine Eingabe")
                {
                    string message = "Bitte geben Sie das vorherige Geschäftsjahr ein.";
                    string caption = "Fehlendes Geschäftsjahr";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (vorherigesGJAHRCSV.Checked == true && (vorherigesGJAHROBR.Value == ""))// || vorherigesGJAHROBR.Value.Substring(vorherigesGJAHROBR.Value.Length - 4, 4) != ".csv"))
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende OBR Liste für den vorherigen Zeitraum aus.";
                    string caption = "Fehlende OBR Konten";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (vorherigesGJAHRDifferentProject.Checked == true && (vorherigesGJAHROBR.Value == ""))// || vorherigesGJAHROBR.Value.Substring(vorherigesGJAHROBR.Value.Length - 4, 4) != ".imd"))
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende OBR Liste für den vorherigen Zeitraum aus.";
                    string caption = "Fehlende OBR Konten";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
                if (vorherigesGJAHRUmsetzungen.Value == "")
                {
                    string message = "Sie haben keine gültige Datei für die Aufbereitung ausgewählt. Bitte wählen Sie eine entsprechende CSV Datei für die Umsetzungen für den vorherigen Zeitraum aus.";
                    string caption = "Fehlende Umsetzungen";
                    DialogResult result;
                    result = MessageBox.Show(message, caption);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                    return;
                }
            }
        }

        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;
            smartDataExchanger1.Value["bAktuellesGJAHRCSV"] = aktuellesGJAHRCSV;
            smartDataExchanger1.Value["bAktuellesGJAHRCurrentProject"] = aktuellesGJAHRCurrentProject;
            smartDataExchanger1.Value["bAktuellesGJAHRDifferentProject"] = aktuellesGJAHRDifferentProject;
            smartDataExchanger1.Value["bVorherigesGJAHRCSV"] = vorherigesGJAHRCSV;
            smartDataExchanger1.Value["bVorherigesGJAHRCurrentProject"] = vorherigesGJAHRCurrentProject;
            smartDataExchanger1.Value["bVorherigesGJAHRDifferentProject"] = vorherigesGJAHRDifferentProject;
            smartDataExchanger1.Value["sCurrentProjektFile"] = InitialDirectory + aktuellesGJAHROBRcurrent.SelectedItem;
            smartDataExchanger1.Value["sPrevProjektFile"] = InitialDirectory + vorherigesGJAHROBRcurrent.SelectedItem;

        }

        private void aktuellesGJAHRSearchOBR_Click(object sender, EventArgs e)
        {
            string Filterstring;
            openFileDialog1.Title = "OBR Konten";
            if(aktuellesGJAHRCSV.Checked == true)
            {
                Filterstring = "CSV Datei|*.csv;*.CSV";
            }
            else
            {
                Filterstring = "IDEA Datei|*.imd;*.IMD";
                openFileDialog1.InitialDirectory = InitialDirectory;
            }
            openFileDialog1.Filter = Filterstring;
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                aktuellesGJAHROBR.Value = replacePath;
            }
        }

        private void vorherigesGJAHRSearchOBR_Click(object sender, EventArgs e)
        {
            string Filterstring;
            openFileDialog1.Title = "OBR Konten";
            if (vorherigesGJAHRCSV.Checked == true)
            {
                Filterstring = "CSV Datei|*.csv;*.CSV";
            }
            else
            {
                Filterstring = "IDEA Datei|*.imd;*.IMD";
            }
            openFileDialog1.Filter = Filterstring;
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                vorherigesGJAHROBR.Value = replacePath;
            }
        }

        private void aktuellesGJAHRSearchUmsetzungen_Click(object sender, EventArgs e)
        {
            openFileDialog1.Title = "Umsetzungen";
            openFileDialog1.Filter = "CSV Datei|*.csv;*.CSV";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                aktuellesGJAHRUmsetzungen.Value = replacePath;
            }
        }

        private void vorherigesGJAHRSearchUmsetzungen_Click(object sender, EventArgs e)
        {
            openFileDialog1.Title = "Umsetzungen";
            openFileDialog1.Filter = "CSV Datei|*.csv;*.CSV";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                vorherigesGJAHRUmsetzungen.Value = replacePath;
            }
        }
        //------------------------------------------------------------------------------------------------------------
        private void aktuellesGJAHRCSV_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && aktuellesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;

                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    aktuellesGJAHROBRcurrent.Enabled = false;
                    aktuellesGJAHRSearchOBR.Enabled = true;
                    aktuellesGJAHROBR.Enabled = true;
                    aktuellesGJAHROBR.Value = "";
                    checkedButton.Checked = true;
                    aktuellesGJAHRCurrentProject.Checked = false;
                    aktuellesGJAHRDifferentProject.Checked = false;
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                aktuellesGJAHROBRcurrent.Enabled = false;
                aktuellesGJAHRSearchOBR.Enabled = true;
                aktuellesGJAHROBR.Enabled = true;
                checkedButton.Checked = true;
                aktuellesGJAHRCurrentProject.Checked = false;
                aktuellesGJAHRDifferentProject.Checked = false;
            }
        }
        private void aktuellesGJAHRCurrentProject_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && aktuellesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;

                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    if (fileEntriesCurrent == null || fileEntriesCurrent.Length == 0)
                    {
                        MessageBox.Show("Es wurden keine {OBR_Konten_YYYY} im aktuellen Projekt gefunden. Bitte wählen Sie eine andere Option aus.");
                    }
                    else
                    {
                        aktuellesGJAHROBRcurrent.Enabled = true;
                        aktuellesGJAHRSearchOBR.Enabled = false;
                        aktuellesGJAHROBR.Enabled = false;
                        aktuellesGJAHROBR.Value = "";
                        checkedButton.Checked = true;
                        aktuellesGJAHRCSV.Checked = false;
                        aktuellesGJAHRDifferentProject.Checked = false;
                    }
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                if (fileEntriesCurrent == null || fileEntriesCurrent.Length == 0)
                {
                    MessageBox.Show("Es wurden keine {OBR_Konten_YYYY} im aktuellen Projekt gefunden. Bitte wählen Sie eine andere Option aus.");
                }
                else
                {
                    aktuellesGJAHROBRcurrent.Enabled = true;
                    aktuellesGJAHRSearchOBR.Enabled = false;
                    aktuellesGJAHROBR.Enabled = false;
                    checkedButton.Checked = true;
                    aktuellesGJAHRCSV.Checked = false;
                    aktuellesGJAHRDifferentProject.Checked = false;
                }
            }
        }
        private void aktuellesGJAHRDifferentProject_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && aktuellesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;

                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    aktuellesGJAHROBRcurrent.Enabled = false;
                    aktuellesGJAHRSearchOBR.Enabled = true;
                    aktuellesGJAHROBR.Enabled = true;
                    aktuellesGJAHROBR.Value = "";
                    checkedButton.Checked = true;
                    aktuellesGJAHRCSV.Checked = false;
                    aktuellesGJAHRCurrentProject.Checked = false;
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                aktuellesGJAHROBRcurrent.Enabled = false;
                aktuellesGJAHRSearchOBR.Enabled = true;
                aktuellesGJAHROBR.Enabled = true;
                checkedButton.Checked = true;
                aktuellesGJAHRCSV.Checked = false;
                aktuellesGJAHRCurrentProject.Checked = false;

            }
        }
        private void vorherigesGJAHRCSV_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && vorherigesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;
   
                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    vorherigesGJAHROBRcurrent.Enabled = false;
                    vorherigesGJAHRSearchOBR.Enabled = true;
                    vorherigesGJAHROBR.Enabled = true;
                    vorherigesGJAHROBR.Value = "";
                    checkedButton.Checked = true;
                    vorherigesGJAHRCurrentProject.Checked = false;
                    vorherigesGJAHRDifferentProject.Checked = false;
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                vorherigesGJAHROBRcurrent.Enabled = false;
                vorherigesGJAHRSearchOBR.Enabled = true;
                vorherigesGJAHROBR.Enabled = true;
                checkedButton.Checked = true;
                vorherigesGJAHRCurrentProject.Checked = false;
                vorherigesGJAHRDifferentProject.Checked = false;
            }
        }
        private void vorherigesGJAHRCurrentProject_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && vorherigesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;
   
                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    if (fileEntriesPrev == null || fileEntriesPrev.Length == 0)
                    {
                        MessageBox.Show("Es wurden keine {OBR_Konten_YYYY} im aktuellen Projekt gefunden. Bitte wählen Sie eine andere Option aus.");
                    }
                    else
                    {
                        vorherigesGJAHROBRcurrent.Enabled = true;
                        vorherigesGJAHRSearchOBR.Enabled = false;
                        vorherigesGJAHROBR.Enabled = false;
                        vorherigesGJAHROBR.Value = "";
                        checkedButton.Checked = true;
                        vorherigesGJAHRCSV.Checked = false;
                        vorherigesGJAHRDifferentProject.Checked = false;
                    }
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                if (fileEntriesPrev == null || fileEntriesPrev.Length == 0)
                {
                    MessageBox.Show("Es wurden keine {OBR_Konten_YYYY} im aktuellen Projekt gefunden. Bitte wählen Sie eine andere Option aus.");
                }
                else
                {
                    vorherigesGJAHROBRcurrent.Enabled = true;
                    vorherigesGJAHRSearchOBR.Enabled = false;
                    vorherigesGJAHROBR.Enabled = false;
                    checkedButton.Checked = true;
                    vorherigesGJAHRCSV.Checked = false;
                    vorherigesGJAHRDifferentProject.Checked = false;
                }
            }
        }
        private void vorherigesGJAHRDifferentProject_Clicked(object sender, EventArgs e)
        {
            RadioButton checkedButton = (RadioButton)sender;
            if (!checkedButton.Checked && vorherigesGJAHROBR.Value != "")
            {
                string message = "Wenn Sie die Importart ändern, wird die bereits ausgewählte OBR Datei entfernt."
                    + Environment.NewLine
                    + "Möchten Sie die Importart ändern?";
                string caption = "Änderung Importart";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result;
   
                result = MessageBox.Show(message, caption, buttons);
                if (result == DialogResult.Yes)
                {
                    vorherigesGJAHROBRcurrent.Enabled = false;
                    vorherigesGJAHRSearchOBR.Enabled = true;
                    vorherigesGJAHROBR.Enabled = true;
                    vorherigesGJAHROBR.Value = "";
                    checkedButton.Checked = true;
                    vorherigesGJAHRCSV.Checked = false;
                    vorherigesGJAHRCurrentProject.Checked = false;
                }
                else if (result == DialogResult.No)
                {
                    //vorherigesGJAHRCSV.Checked = true;
                }
            }
            else
            {
                vorherigesGJAHROBRcurrent.Enabled = false;
                vorherigesGJAHRSearchOBR.Enabled = true;
                vorherigesGJAHROBR.Enabled = true;
                checkedButton.Checked = true;
                vorherigesGJAHRCSV.Checked = false;
                vorherigesGJAHRCurrentProject.Checked = false;

            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            if (smartDataExchanger1.Value.Contains("FilePathStandard"))
            {
                InitialDirectory = smartDataExchanger1.Value["FilePathStandard"].ToString();
            }

            aktuellesGJAHROBRcurrent.Enabled = false;
            vorherigesGJAHROBRcurrent.Enabled = false;

            FillCheckBox();

            if (smartDataExchanger1.Value.Contains("aktuellesGeschäftsjahr"))
            {
                if (smartDataExchanger1.Value["aktuellesGeschäftsjahr"].ToString() != "")
                {
                    if (fileEntriesCurrent == null || fileEntriesCurrent.Length == 0)
                    {
                        //nicht definiert
                    }
                    else
                    {
                        aktuellesGeschäftsjahr.SelectedItem = smartDataExchanger1.Value["aktuellesGeschäftsjahr"].ToString();
                        vorherigesGeschäftsjahr.SelectedItem = (Convert.ToInt32(smartDataExchanger1.Value["aktuellesGeschäftsjahr"]) - 1).ToString();
                        aktuellesGJAHROBRcurrent.Enabled = true;
                        try
                        {
                            aktuellesGJAHROBRcurrent.SelectedItem = "{OBR_Konten_" + smartDataExchanger1.Value["aktuellesGeschäftsjahr"].ToString() +"}.IMD";
                        }
                        catch
                        {

                        }
                        aktuellesGJAHRSearchOBR.Enabled = false;
                        aktuellesGJAHROBR.Enabled = false;
                        aktuellesGeschäftsjahr.Enabled = false;
                        aktuellesGJAHRCSV.Checked = false;
                        aktuellesGJAHRCurrentProject.Checked = true;
                        aktuellesGJAHRDifferentProject.Checked = false;
                    }
                }
                else
                {
                    overrideGJAHRaktuell.Enabled = false;
                }
            }
            else
            {
                overrideGJAHRaktuell.Enabled = false;
            }
        }

        private void overrideGJAHRaktuell_CheckedChanged(object sender, EventArgs e)
        {
            if(overrideGJAHRaktuell.Checked == true)
            {
                aktuellesGeschäftsjahr.Enabled = true;
            }
            if(overrideGJAHRaktuell.Checked == false)
            {
                aktuellesGeschäftsjahr.SelectedItem = smartDataExchanger1.Value["aktuellesGeschäftsjahr"].ToString();
                vorherigesGeschäftsjahr.SelectedItem = (Convert.ToInt32(smartDataExchanger1.Value["aktuellesGeschäftsjahr"]) - 1).ToString();
                aktuellesGeschäftsjahr.Enabled = false;
            }
        }

        private void FillCheckBox()
        {
            fileEntriesCurrent = Directory.GetFiles(InitialDirectory, "{OBR_Konten_*}.IMD").Select(Path.GetFileName).ToArray();
            fileEntriesPrev = Directory.GetFiles(InitialDirectory, "{OBR_Konten_*}.IMD").Select(Path.GetFileName).ToArray();
            if (fileEntriesCurrent != null && fileEntriesCurrent.Length != 0)
                aktuellesGJAHROBRcurrent.DataSource = fileEntriesCurrent;
            if (fileEntriesPrev != null && fileEntriesPrev.Length != 0)
                vorherigesGJAHROBRcurrent.DataSource = fileEntriesPrev;
        }
    }
}
