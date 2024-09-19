using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Types;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using static System.Windows.Forms.LinkLabel;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Dialog_Arbeitsteilung
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {

        public _DialogMainForm()
        {
            InitializeComponent();
            smartComboBox1.SelectedIndexChanged += smartComboBox1_SelectedIndexChanged;
            smartComboBox2.SelectedIndexChanged += smartComboBox2_SelectedIndexChanged;
            smartComboBox3.SelectedIndexChanged += smartComboBox3_SelectedIndexChanged;
            smartComboBox4.SelectedIndexChanged += smartComboBox4_SelectedIndexChanged;
            smartComboBox5.SelectedIndexChanged += smartComboBox5_SelectedIndexChanged;
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
        private void smartTextBox1_Load(object sender, EventArgs e)
        {

        }

        private void smartHelp1_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog = new FolderBrowserDialog())
            {
                // Set the initial directory (optional)
                try {
                    folderDialog.SelectedPath = smartDataExchanger1.Value["FolderPathStandard"].ToString();
                }
                catch
                {

                }

                // Show the dialog and check if the user clicked OK
                if (folderDialog.ShowDialog() == DialogResult.OK)
                {
                    // Get the selected folder path
                    string selectedFolderPath = folderDialog.SelectedPath;

                    smartTextBox2.Value = selectedFolderPath;

                    lastchosenFolderPath = selectedFolderPath;

                    // Do something with the selected folder path
                    // MessageBox.Show("Selected Folder Path: " + selectedFolderPath);
                }
            }
        }
        private void smartHelp2_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog2 = new FolderBrowserDialog())
            {
                // Set the initial directory (optional)
                try
                {
                    if (string.IsNullOrEmpty(lastchosenFolderPath))
                    {
                        folderDialog2.SelectedPath = smartDataExchanger1.Value["FolderPathStandard"].ToString();
                    }
                    else 
                    {
                        folderDialog2.SelectedPath = lastchosenFolderPath;
                    }
                       
                }
                catch
                {

                }

                // Show the dialog and check if the user clicked OK
                if (folderDialog2.ShowDialog() == DialogResult.OK)
                {
                    // Get the selected folder path
                    string selectedFolderPath = folderDialog2.SelectedPath;

                    smartTextBox6.Value = selectedFolderPath;

                    lastchosenFolderPath = selectedFolderPath;

                    // Do something with the selected folder path
                    // MessageBox.Show("Selected Folder Path: " + selectedFolderPath);
                }
            }
        }
        private void smartHelp3_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog3 = new FolderBrowserDialog())
            {
                // Set the initial directory (optional)
                try
                {
                    if (string.IsNullOrEmpty(lastchosenFolderPath))
                    {
                        folderDialog3.SelectedPath = smartDataExchanger1.Value["FolderPathStandard"].ToString();
                    }
                    else
                    {
                        folderDialog3.SelectedPath = lastchosenFolderPath;
                    }
                }
                catch
                {

                }

                // Show the dialog and check if the user clicked OK
                if (folderDialog3.ShowDialog() == DialogResult.OK)
                {
                    // Get the selected folder path
                    string selectedFolderPath = folderDialog3.SelectedPath;

                    smartTextBox10.Value = selectedFolderPath;

                    lastchosenFolderPath = selectedFolderPath;

                    // Do something with the selected folder path
                    // MessageBox.Show("Selected Folder Path: " + selectedFolderPath);
                }
            }
        }
        private void smartHelp4_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog4 = new FolderBrowserDialog())
            {
                // Set the initial directory (optional)
                try
                {
                    if (string.IsNullOrEmpty(lastchosenFolderPath))
                    {
                        folderDialog4.SelectedPath = smartDataExchanger1.Value["FolderPathStandard"].ToString();
                    }
                    else
                    {
                        folderDialog4.SelectedPath = lastchosenFolderPath;
                    }
                }
                catch
                {

                }

                // Show the dialog and check if the user clicked OK
                if (folderDialog4.ShowDialog() == DialogResult.OK)
                {
                    // Get the selected folder path
                    string selectedFolderPath = folderDialog4.SelectedPath;

                    smartTextBox14.Value = selectedFolderPath;

                    lastchosenFolderPath = selectedFolderPath;

                    // Do something with the selected folder path
                    // MessageBox.Show("Selected Folder Path: " + selectedFolderPath);
                }
            }
        }
        private void smartHelp5_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog5 = new FolderBrowserDialog())
            {
                // Set the initial directory (optional)
                try
                {
                    if (string.IsNullOrEmpty(lastchosenFolderPath))
                    {
                        folderDialog5.SelectedPath = smartDataExchanger1.Value["FolderPathStandard"].ToString();
                    }
                    else
                    {
                        folderDialog5.SelectedPath = lastchosenFolderPath;
                    }
                }
                catch
                {

                }

                // Show the dialog and check if the user clicked OK
                if (folderDialog5.ShowDialog() == DialogResult.OK)
                {
                    // Get the selected folder path
                    string selectedFolderPath = folderDialog5.SelectedPath;

                    smartTextBox18.Value = selectedFolderPath;

                    lastchosenFolderPath = selectedFolderPath;

                    // Do something with the selected folder path
                    // MessageBox.Show("Selected Folder Path: " + selectedFolderPath);
                }
            }
        }

        private bool Validation()
        {
            if (string.IsNullOrEmpty(smartTextBox1.Value) || string.IsNullOrEmpty(smartTextBox2.Value) || (string.IsNullOrEmpty(smartTextBox3.Value) && (smartComboBox6.SelectedItem.ToString() == "keine Eingabe") && (string.IsNullOrEmpty(smartTextBox4.Value))))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        private void Button_Cancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void Button_OK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void MyDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (this.DialogResult == DialogResult.OK)
            {
                // Check if the special condition is not met
                if (Validation())
                {
                    e.Cancel = false;
                    MessageBox.Show("Der Ablauf kann ein paar Minuten dauern. Bitte warten Sie, bis Sie die Erfolgsbestätigung erhalten.");
                    return;
                }
                else
                {
                    // Cancel the closing of the dialog
                    MessageBox.Show("Bitte geben Sie die erforderlichen Angaben ein.");
                    e.Cancel = true;
                    return;
                }
            }
            else if (this.DialogResult == DialogResult.Cancel)
            {
                e.Cancel = false;
            }
        }

        private void smartComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (smartComboBox1.SelectedItem.ToString() == "Bilanzposition (abgekürzt)")
            {
                smartComboBox6.Enabled = false;
                smartComboBox6.Visible = false;
                smartTextBox4.Enabled = true;
                smartTextBox4.Visible = true;
            }
            else
            {
                smartComboBox6.Enabled = true;
                smartComboBox6.Visible = true;
                smartTextBox4.Enabled = false;
                smartTextBox4.Visible = false;
            }
        }
        private void smartComboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (smartComboBox2.SelectedItem.ToString() == "Bilanzposition (abgekürzt)")
            {
                smartComboBox7.Enabled = false;
                smartComboBox7.Visible = false;
                smartTextBox8.Enabled = true;
                smartTextBox8.Visible = true;
            }
            else
            {
                smartComboBox7.Enabled = true;
                smartComboBox7.Visible = true;
                smartTextBox8.Enabled = false;
                smartTextBox8.Visible = false;
            }
        }
        private void smartComboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (smartComboBox3.SelectedItem.ToString() == "Bilanzposition (abgekürzt)")
            {
                smartComboBox8.Enabled = false;
                smartComboBox8.Visible = false;
                smartTextBox12.Enabled = true;
                smartTextBox12.Visible = true;
            }
            else
            {
                smartComboBox8.Enabled = true;
                smartComboBox8.Visible = true;
                smartTextBox12.Enabled = false;
                smartTextBox12.Visible = false;
            }
        }
        private void smartComboBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (smartComboBox4.SelectedItem.ToString() == "Bilanzposition (abgekürzt)")
            {
                smartComboBox9.Enabled = false;
                smartComboBox9.Visible = false;
                smartTextBox16.Enabled = true;
                smartTextBox16.Visible = true;
            }
            else
            {
                smartComboBox9.Enabled = true;
                smartComboBox9.Visible = true;
                smartTextBox16.Enabled = false;
                smartTextBox16.Visible = false;
            }
        }
        private void smartComboBox5_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (smartComboBox5.SelectedItem.ToString() == "Bilanzposition (abgekürzt)")
            {
                smartComboBox10.Enabled = false;
                smartComboBox10.Visible = false;
                smartTextBox20.Enabled = true;
                smartTextBox20.Visible = true;
            }
            else
            {
                smartComboBox10.Enabled = true;
                smartComboBox10.Visible = true;
                smartTextBox20.Enabled = false;
                smartTextBox20.Visible = false;
            }
        }

    }
}
