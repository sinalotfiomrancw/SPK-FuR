using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;
using System.IO;

namespace ImportRoutine_Rechnungsbuchprüfung
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {

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

        private void btn_FileSearch_Click(object sender, EventArgs e)
        {
            openFileDialog1.Title = "Rechnungsbuch";
            openFileDialog1.Filter = "Text-Datei|*.CSV;*.csv";//|Excel|*.xlsx;*.XLSX";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                sTB_FilePath.Value = openFileDialog1.FileName;
            }
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            if (File.Exists(sTB_FilePath.Value) != true)
            {
                MessageBox.Show("Die Datei konnte nicht gefunden werden. Bitte prüfen Sie Ihre Auswahl.", Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DialogResult = DialogResult.OK;
            Close();
        }
    }
}
