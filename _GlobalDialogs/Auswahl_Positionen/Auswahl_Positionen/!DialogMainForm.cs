using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace Auswahl_Positionen
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

        private void Button_OK_Click(object sender, EventArgs e)
        {
            //if(sCB_A.Checked==false && sCB_P.Checked == false && sCB_E.Checked == false && sCB_V.Checked == false)
            //{
            //    DialogResult = DialogResult.Cancel;
            //    Close();
            //}
            //else
            //{
                DialogResult = DialogResult.OK;
                Close();
            //}
        }
    }
}
