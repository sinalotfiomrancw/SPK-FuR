using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace SK_FuR___Import_Routine__Parameter_
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

        private void button1_Click(object sender, EventArgs e)
        {
            //openFileDialog1.InitialDirectory = smartDataExchanger1.Value["FilePathStandard"].ToString();
            openFileDialog1.Title = "OBR-Konten";
            openFileDialog1.Filter = "Text-Datei|*.CSV;*.csv;*.txt;*.TXT";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                //MessageBox.Show(replacePath);
                smartTextBox3.Value = replacePath;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = folderBrowserDialog1.SelectedPath;
                //MessageBox.Show(replacePath);
                smartTextBox4.Value = replacePath;
            }
        }

        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (AskQuestion == true)
            {
                AskQuestion = false;
                if (smartTextBox2.Value == "")
                {
                    string message = "Sie haben kein Geschäftsjahr angegeben.";
                    string caption = "Fehlendes Geschäftsjahr";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                        tabControl1.SelectedTab = TabPageAllgemein;
                    }
                }
                if (smartTextBox3.Value == "")
                {
                    string message = "Sie haben keine Datei für die OBR-Konten angegeben.";
                    string caption = "Fehlende Datei oder Verzeichnis";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                        tabControl1.SelectedTab = TabPageOBRKonten;
                    }
                }
                if (smartTextBox4.Value == "")
                {
                    string message = "Sie haben kein Verzeichnis für die Umsatzdateien angegeben.";
                    string caption = "Fehlende Datei oder Verzeichnis";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == DialogResult.OK)
                    {
                        e.Cancel = true;
                        tabControl1.SelectedTab = TabPageUmsaetze;
                    }
                }
            }
        }

        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            if (smartDataExchanger1.Value.Contains("sGeschäftsjahr"))
            {
                smartTextBox2.Value = smartDataExchanger1.Value["sGeschäftsjahr"].ToString();
            }
        }
    }
}
