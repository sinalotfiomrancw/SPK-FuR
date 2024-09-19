using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace Auswahl_Differenz
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

        private void sCheckBAbsDiff_CheckedChanged(object sender, EventArgs e)
        {
            if(sCheckBAbsDiff.Checked == true)
            {
                sTBAbsDiff.Enabled = true;
            }
            else
            {
                sTBAbsDiff.Enabled = false;
                sTBAbsDiff.Value = string.Empty;
            }
            Activate_LogicalConnection();
            DefineIsOptional();
        }

        private void Activate_LogicalConnection()
        {
            if(sCheckBAbsDiff.Checked == true && sCheckBPercDiff.Checked == true)
            {
                sCBLogicalConnection.Enabled = true;
            }
            else
            {
                sCBLogicalConnection.Enabled = false;
            }
        }

        private void DefineIsOptional()
        {
            if(sCB_A.Checked == false && sCB_P.Checked == false && sCB_E.Checked == false && sCB_V.Checked == false)
            {
                if (sCheckBAbsDiff.Checked == true && sCheckBPercDiff.Checked == true)
                {
                    sTBAbsDiff.IsOptional = false;
                    sTBPercDiff.IsOptional = false;
                }
                else if (sCheckBAbsDiff.Checked == true && sCheckBPercDiff.Checked == false)
                {
                    sTBAbsDiff.IsOptional = false;
                    sTBPercDiff.IsOptional = true;
                }
                else if (sCheckBAbsDiff.Checked == false && sCheckBPercDiff.Checked == true)
                {
                    sTBAbsDiff.IsOptional = true;
                    sTBPercDiff.IsOptional = false;
                }
                else if (sCheckBAbsDiff.Checked == false && sCheckBPercDiff.Checked == false)
                {
                    sTBAbsDiff.IsOptional = false;
                    sTBPercDiff.IsOptional = false;
                }
            }
        }

        private void sCheckBPercDiff_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckBPercDiff.Checked == true)
            {
                sTBPercDiff.Enabled = true;
            }
            else
            {
                sTBPercDiff.Enabled = false;
                sTBPercDiff.Value = string.Empty;
            }
            Activate_LogicalConnection();
            DefineIsOptional();
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            if (sCheckBAbsDiff.Checked == true)
            {
                sTBAbsDiff.Enabled = true;
            }
            else
            {
                sTBAbsDiff.Enabled = false;
            }

            if (sCheckBPercDiff.Checked == true)
            {
                sTBPercDiff.Enabled = true;
            }
            else
            {
                sTBPercDiff.Enabled = false;
            }
            Activate_LogicalConnection();
            DefineIsOptional();
        }

        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;
        }

        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (AskQuestion == true)
            {
                if ((sCheckBAbsDiff.Checked == true && sTBAbsDiff.Value == "") || (sCheckBPercDiff.Checked == true && sTBPercDiff.Value == ""))
                {
                    string message = "Sie haben eine Differenz als Filter gewählt, jedoch keinen Wert eingetragen. Bitte tragen Sie einen Wert ein oder deaktivieren Sie die Checkbox.";
                    string caption = "Leere Filterkrieterien";
                    MessageBox.Show(message, caption);

                    e.Cancel = true;
                }
                AskQuestion = false;
            }
        }

        private void PositionChoice_CheckChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            if(sCB_A.Checked == true || sCB_P.Checked == true || sCB_E.Checked == true || sCB_V.Checked == true)
            {
                sTBAbsDiff.IsOptional = true;
                sTBPercDiff.IsOptional = true;
            }
            else
            {
                DefineIsOptional();
            }
        }
    }
}
