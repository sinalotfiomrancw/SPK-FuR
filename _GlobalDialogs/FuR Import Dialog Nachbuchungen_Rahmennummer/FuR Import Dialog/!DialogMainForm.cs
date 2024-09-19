using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Types;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Dialog
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        public bool AskQuestion = false;
        public _DialogMainForm()
        {
            InitializeComponent();
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

        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;
            // smartDataExchanger1.Value["FilePathStandard"] = smartTextBox1.Value;
            // smartDataExchanger1.Value["AccountChoice"] = smartFromToList1.Count;
            smartDataExchanger1.Value["AccountFilter"] = AccountFilter.Checked;
            smartDataExchanger1.Value["RahmenFilter"] = RahmenFilter.Checked;

        }
        private void smartHelp1_Click(object sender, EventArgs e)
        {
            openFileDialog1.InitialDirectory = smartDataExchanger1.Value["FilePathStandard"].ToString();
            openFileDialog1.Title = "Nachbuchungen";
            openFileDialog1.Filter = "Text-Datei|*.CSV;*.csv";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath1;
                replacePath1 = openFileDialog1.FileName;
                // MessageBox.Show(replacePath1);
                smartTextBox1.Value = replacePath1;
            }
        }

        private void smartHelp2_Click(object sender, EventArgs e)
        {
            openFileDialog2.InitialDirectory = smartDataExchanger1.Value["FilePathStandard"].ToString();
            openFileDialog2.Title = "OBR-Konten";
            openFileDialog2.Filter = "Text-Datei|*.CSV;*.csv";
            if (openFileDialog2.ShowDialog() == DialogResult.OK)
            {
                string replacePath2;
                replacePath2 = openFileDialog2.FileName;
                //MessageBox.Show(replacePath);
                smartTextBox2.Value = replacePath2;
            }
        }

        private void _DialogMainForm_Load_1(object sender, EventArgs e)
        {
            smartCheckBox1.Text = DialogStrings.UpdatePostings;

            smartLabel4.Text = DialogStrings.LebelOBRFile;

           // if (smartDataExchanger1.Value.Contains("FilePathStandard"))
           // {
           //     smartTextBox1.Value = smartDataExchanger1.Value["FilePathStandard"].ToString();
           //     smartTextBox2.Value = smartDataExchanger1.Value["FilePathStandard"].ToString();
           // }
            if (AccountFilter.Checked == false)
            {
                AccountList.Enabled = false;
            }
            if (RahmenFilter.Checked == false)
            {
                RahmenList.Enabled = false;
            }
        }

        private void AccountFilter_CheckedChanged(object sender, EventArgs e)
        {
            if (AccountFilter.Checked == true)
            {
                AccountList.Enabled = true;
                RahmenFilter.Checked = false;
            }
            if (AccountFilter.Checked == false)
            {
                AccountList.Enabled = false;
            }
        }

        private void RahmenFilter_CheckedChanged(object sender, EventArgs e)
        {
            if (RahmenFilter.Checked == true)
            {
                RahmenList.Enabled = true;
                AccountFilter.Checked = false;
            }
            if (RahmenFilter.Checked == false)
            {
                RahmenList.Enabled = false;
            }
        }

        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (AskQuestion == true)
            {
                if (AccountFilter.Checked == true && AccountList.Count == 0)
                {
                    string message = "Sie haben die Filterung auf Kontennummer ausgewählt, jedoch keine Eingaben bestätigt. Bitte geben Sie die gewünschten Kontennummer ein.";
                    string caption = "Leere Filterkrieterien";
                    MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption, buttons);
                    if (result == System.Windows.Forms.DialogResult.Yes)
                    {
                        e.Cancel = true;
                    }
                    else if (result == System.Windows.Forms.DialogResult.No)
                    {
                        e.Cancel = false;
                    }
                }
                if (RahmenFilter.Checked == true && RahmenList.Count == 0)
                {
                    string message = "Sie haben die Filterung auf Rahmennummer ausgewählt, jedoch keine Eingaben bestätigt. Bitte geben Sie die gewünschten Rahmennummern ein.";
                    string caption = "Leere Filterkrieterien";
                    MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption, buttons);
                    if (result == System.Windows.Forms.DialogResult.Yes)
                    {
                        e.Cancel = true;
                    }
                    else if (result == System.Windows.Forms.DialogResult.No)
                    {
                        e.Cancel = false;
                    }
                }
                if (string.IsNullOrEmpty(smartTextBox1.Value))
                {
                    string message = "Sie haben keine Nachbuchungsdatei ausgewählt. Bitte wählen Sie eine aus.";
                    string caption = "Keine Nachbuchungen Datei";
                    MessageBox.Show(message, caption);
                    e.Cancel = true;
                }
                AskQuestion = false;
            }
        }
    }
}
