using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace Dialog
{
    public partial class MacroForm : Form
    {

        public MacroForm()
        {
            InitializeComponent();
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }

        }

        private void MacroForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void smartLabel1_Click(object sender, EventArgs e)
        {

        }

        private void MacroForm_Load(object sender, EventArgs e)
        {

            // Form

            this.Text = DialogStrings.frmTitle;

            // Labels
            smartLabel1.Text = DialogStrings.labDateFrom;
            smartLabel2.Text = DialogStrings.labDateTo;
            //smartLabel3.Text = DialogStrings.labCheckbox;
            smartLabel4.Text = DialogStrings.labMinVal;
            smartLabel5.Text = DialogStrings.labShortText;
            smartLabel6.Text = DialogStrings.labOptions;

            // Textboxes
            smartTextBox1.ReportingName = DialogStrings.txtDateFromReportName;
            smartTextBox2.ReportingName = DialogStrings.txtDateToReportName;
            smartTextBox3.ReportingName = DialogStrings.txtMinValReportName;
            smartTextBox4.ReportingName = DialogStrings.txtShortTextReportName;

            // FTL            
            smartFromToList1.Caption = DialogStrings.ftlCaption;
            smartFromToList1.CaptionFrom = DialogStrings.ftlCaptionFrom;
            smartFromToList1.CaptionTo = DialogStrings.ftlCaptionTo;
            smartFromToList1.ReportingName = DialogStrings.ftlReportName;

            // FTL2            
            smartFromToList2.Caption = DialogStrings.ftlCaption2;
            smartFromToList2.CaptionFrom = DialogStrings.ftlCaptionFrom2;
            smartFromToList2.CaptionTo = DialogStrings.ftlCaptionTo2;
            smartFromToList2.ReportingName = DialogStrings.ftlReportName2;

            //SingleList2
            smartSingleList2.Caption = DialogStrings.slCaption2;
            smartSingleList2.ReportingName = DialogStrings.slCaptionReport2;

            //SingleList
            smartSingleList1.Caption = DialogStrings.slCaption;
            smartSingleList1.ReportingName = DialogStrings.slCaptionReport;

            // Checkboxes
            // smartCheckBox1.Text = DialogStrings.labCaption;
            // smartCheckBox1.ReportingName = DialogStrings.labCaptionReport;

            //smartCheckBox2.Text = DialogStrings.chkUser;
            //smartCheckBox2.ReportingName = DialogStrings.chkUserReport;

            //smartCheckBox3.Text = DialogStrings.chkVAT;
            //smartCheckBox3.ReportingName = DialogStrings.chkVATReport;

            //smartCheckBox4.Text = DialogStrings.chkCurrency;
            //smartCheckBox4.ReportingName = DialogStrings.chkCurrencyReport;

            //smartCheckBox5.Text = DialogStrings.chkSystem;
            //smartCheckBox5.ReportingName = DialogStrings.chkSystemReport;

            //smartCheckBox6.Text = DialogStrings.chkOrg;
            //smartCheckBox6.ReportingName = DialogStrings.chkOrgReport;

            smartCheckBox7.Text = DialogStrings.chkWordSearch;
            smartCheckBox7.ReportingName = DialogStrings.chkWordSearchReport;

            smartCheckBox8.Text = DialogStrings.chkShortText;
            smartCheckBox8.ReportingName = DialogStrings.chkShortTextReport;

            smartCheckBox10.Text = DialogStrings.chkCriticalText;
            smartCheckBox10.ReportingName = DialogStrings.chkCriticalTextReport;

            // Tabulator
            tabPage1.Text = DialogStrings.labTabPage1;
            tabPage2.Text = DialogStrings.labTabPage2;
            tabPage3.Text = DialogStrings.labTabPage3;
            tabPage4.Text = DialogStrings.labTabPage4;
            tabPage5.Text = DialogStrings.labTabPage5;

            if (smartCheckBox8.Checked == false)
            {
                smartTextBox4.Enabled = false;
            }
            if (smartCheckBox10.Checked == false)
            {
                smartCheckBox7.Enabled = false;
                smartSingleList1.Enabled = false;
            }
            
            smartTextBox1.Enabled = true;
            smartTextBox2.Enabled = true;

            try
            {
                if ((smartSingleList1.Value.Count == 0) && (smartCheckBox8.Checked == false))
                {
                    smartCheckBox10.Checked = true;
                    smartSingleList1.Enabled = true;
                    string[] paths = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "AuxData", "SK_FuR", "Kritische_Buchungstexte.txt" };
                    string fullPath = Path.Combine(paths);
                    List<string> list = (from x in File.ReadLines(fullPath)
                                         where !string.IsNullOrEmpty(x)
                                         select x).ToList();
                    list.ForEach(delegate (string x)
                    {
                        smartSingleList1.AddValueAndValidate(x);
                    });

                }

                // if ((smartSingleList1.Value.Count == 0) && (smartCheckBox8.Checked == true))
                // {
                //     smartCheckBox10.Checked = true;
                //     smartSingleList1.Enabled = true;
                //     string[] paths = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "AuxData", "SK_FuR", "Kritische_Buchungstexte.txt" };
                //     string fullPath = Path.Combine(paths);
                //     //string[] pathsdist = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "FilterParameters", "Kritische_Buchungstexte.txt" };
                //     // string fullPathdist = Path.Combine(pathsdist);
                //     // File.Copy(fullPath, fullPathdist, true);
                //     List<string> list = (from x in File.ReadLines(fullPath)
                //                          where !string.IsNullOrEmpty(x)
                //                          select x).ToList();
                //     list.ForEach(delegate (string x)
                //     {
                //         smartSingleList1.AddValueAndValidate(x);
                //     });
                //     smartSingleList1.Enabled = false;
                //     smartCheckBox10.Checked = false;
                // }
            }
            catch (Exception)
            { 
            }

            try
            {
                string[] paths = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "AuxData", "SK_FuR", "Kritische_Buchungstexte.txt" };
                string fullPath = Path.Combine(paths);

                string[] pathsdistfolder = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "FilterParameters" };
                string[] pathsdist = { Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CaseWare IDEA", "SmartAnalyzer", "FilterParameters", "Kritische_Buchungstexte.txt" };
                string fullPathdist = Path.Combine(pathsdist);
                string m_filterParametersPath = Path.Combine(pathsdistfolder);
                if (!Directory.Exists(m_filterParametersPath))
                {
                    Directory.CreateDirectory(m_filterParametersPath);
                }
                File.Copy(fullPath, fullPathdist, true);
            }
            catch
            {
            }


        }

        private void smartLabel3_Click(object sender, EventArgs e)
        {

        }

        private void smartSingleList1_Load(object sender, EventArgs e)
        {
        }

        private void smartLabel7_Click(object sender, EventArgs e)
        {

        }

        private bool Validation1()
        {
            if (smartTextBox1.Enabled && smartTextBox2.Enabled)
            {
                if ((string.IsNullOrEmpty(smartTextBox1.Value)) && (string.IsNullOrEmpty(smartTextBox2.Value)))
                {
                    return true;
                }
                else
                {
                    DateTime textBox1 = new DateTime();
        
                    DateTime textBox2 = new DateTime();
                    DateTime.TryParse(smartTextBox2.Value, out textBox2);
        
                    if (DateTime.TryParse(smartTextBox1.Value, out textBox1) && DateTime.TryParse(smartTextBox2.Value, out textBox2))
                    {
                        if (DateTime.Compare(textBox1, textBox2) <= 0)
                        {
                            return true;
                        }
                    }
                }
        
                MessageBox.Show(DialogStrings.msgDateValid, this.Text);
                return false;
            }
            else
            {
                return true;
            }
        }

        private bool Validation2()
        {
            if ((smartCheckBox10.Checked) && (smartSingleList1.Value.Count == 0))
            {
                MessageBox.Show(DialogStrings.msgValidCritText, this.Text);
                return false;
            }
            else
            {
                if ((smartCheckBox8.Checked) || ((smartCheckBox10.Checked) && (smartSingleList1.Value.Count > 0)))
                {
                    return true;
                }
                else
                {
                    MessageBox.Show(DialogStrings.msgAnalyzeValid, this.Text);
                    return false;
                }
            }

        }

        private void button1_Click(object sender, EventArgs e)
        {
            smartTextBox1.ShowInReport = smartTextBox1.Enabled;
            smartTextBox2.ShowInReport = smartTextBox2.Enabled;
            // smartTextBox3.ShowInReport = smartTextBox3.Enabled;
            smartTextBox4.ShowInReport = smartTextBox4.Enabled;
            // smartCheckBox1.ShowInReport = smartCheckBox1.Enabled;
            // smartCheckBox2.ShowInReport = smartCheckBox2.Enabled;
            // smartCheckBox3.ShowInReport = smartCheckBox3.Enabled;
            // smartCheckBox4.ShowInReport = smartCheckBox4.Enabled;
            // smartCheckBox5.ShowInReport = smartCheckBox5.Enabled;
            // smartCheckBox6.ShowInReport = smartCheckBox6.Enabled;
            smartCheckBox7.ShowInReport = smartCheckBox7.Enabled;
            smartSingleList1.ShowInReport = smartSingleList1.Enabled;

            if (Validation1() && Validation2() )
            {
                this.DialogResult = DialogResult.OK;
                this.Close();
            }
            
        }   

        private void Button_Cancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void smartTextBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e != null && e.KeyChar == 8)
            {
                smartTextBox1.Value = "";
            }
        }

        private void smartTextBox2_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e != null && e.KeyChar == 8)
            {
                smartTextBox2.Value = "";
            }
        }
    }
}
