using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace SK_FuR_StandardImportFilter
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

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
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

        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;
            smartDataExchanger1.Value["AccountFilter"] = AccountFilter.Checked;
            smartDataExchanger1.Value["RahmenFilter"] = RahmenFilter.Checked;
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
                AskQuestion = false;
            }
        }
    }
}
